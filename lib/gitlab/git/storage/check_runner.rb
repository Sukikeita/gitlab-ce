module Gitlab
  module Git
    module Storage
      class CheckRunner
        extend CircuitBreakerSettings

        def self.start_checking!
          loop do
            # The check all spins up a thread performing the check and continues
            # immeadiatly.
            #
            # The check is then performed in a separate process that is killed
            # when it doesn't return in time.
            Checker.check_all
            sleep circuitbreaker_check_interval
          end
        end

        def self.logger
          Logger.new(STDOUT)
        end
      end
    end
  end
end
