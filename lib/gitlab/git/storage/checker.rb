module Gitlab
  module Git
    module Storage
      class Checker
        include CircuitBreakerSettings

        attr_reader :storage_path, :storage, :hostname

        def self.check_all
          threads = []

          Gitlab.config.repositories.storages.keys.each do |storage_name|
            threads << Thread.new { new(storage_name).check_with_lease }
          end
        end

        def initialize(storage)
          @storage = storage
          config = Gitlab.config.repositories.storages[@storage]
          @storage_path = config['path']

          @hostname = Gitlab::Environment.hostname
        end

        def check_with_lease
          lease_key = "storage_check:#{cache_key}"
          lease = Gitlab::ExclusiveLease.new(lease_key, timeout: storage_timeout)
          if uuid = lease.try_obtain
            check

            Gitlab::ExclusiveLease.cancel(lease_key, uuid)
          end
        end

        def check
          if Gitlab::Git::Storage::ForkedStorageCheck
               .storage_available?(storage_path, storage_timeout, access_retries)
            track_storage_accessible
          else
            track_storage_inaccessible
          end
        end

        private

        def track_storage_inaccessible
          first_failure = current_failure_info.first_failure || Time.now
          last_failure = Time.now

          Gitlab::Git::Storage.redis.with do |redis|
            redis.pipelined do
              redis.hset(cache_key, :first_failure, first_failure.to_i)
              redis.hset(cache_key, :last_failure, last_failure.to_i)
              redis.hincrby(cache_key, :failure_count, 1)
              redis.expire(cache_key, failure_reset_time)
            end
          end
        end

        def track_storage_accessible
          Gitlab::Git::Storage.redis.with do |redis|
            redis.pipelined do
              redis.hset(cache_key, :first_failure, nil)
              redis.hset(cache_key, :last_failure, nil)
              redis.hset(cache_key, :failure_count, 0)
            end
          end
        end

        def current_failure_info
          FailureInfo.load(cache_key)
        end
      end
    end
  end
end
