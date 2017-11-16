module Gitlab
  module Git
    module Storage
      module CircuitBreakerSettings
        def failure_count_threshold
          application_settings.circuitbreaker_failure_count_threshold
        end

        def failure_wait_time
          application_settings.circuitbreaker_failure_wait_time
        end

        def failure_reset_time
          application_settings.circuitbreaker_failure_reset_time
        end

        def storage_timeout
          application_settings.circuitbreaker_storage_timeout
        end

        def access_retries
          application_settings.circuitbreaker_access_retries
        end

        def backoff_threshold
          application_settings.circuitbreaker_backoff_threshold
        end

        def circuitbreaker_check_interval
          # TODO: move this to the database
          10
        end

        def cache_key
          @cache_key ||= "#{Gitlab::Git::Storage::REDIS_KEY_PREFIX}#{storage}:#{hostname}"
        end

        private

        def application_settings
          Gitlab::CurrentSettings.current_application_settings
        end
      end
    end
  end
end
