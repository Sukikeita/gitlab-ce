module Gitlab
  module Git
    module Storage
      class CheckRunner
        extend CircuitBreakerSettings

        def self.start_checking!
          logger.info 'Starting NFS monitor...'

          previous_check_interval = 0
          previous_access_retries = 0
          previous_storage_timeout = 0

          loop do
            log_settings_if_changed(previous_check_interval,
                                    previous_access_retries,
                                    previous_storage_timeout)
            previous_check_interval = check_interval
            previous_access_retries = access_retries
            previous_storage_timeout = storage_timeout

            # The check all spins up a thread performing the check and continues
            # immeadiatly.
            #
            # The check is then performed in a separate process that is killed
            # when it doesn't return in time.
            Checker.check_all(logger)
            sleep check_interval
          end
        rescue Interrupt
          logger.info 'Stopping NFS-check...'
        end

        def self.log_settings_if_changed(previous_check_interval, previous_access_retries, previous_storage_timeout)
          settings_changed = (
            previous_check_interval != check_interval ||
            previous_access_retries != access_retries ||
            previous_storage_timeout != storage_timeout
          )
          if settings_changed
            logger.info "Interval: #{check_interval} - Retries: #{access_retries} - Timeout: #{storage_timeout}"
          end
        end

        def self.logger
          @logger ||= Logger.new(STDOUT)
        end
      end
    end
  end
end
