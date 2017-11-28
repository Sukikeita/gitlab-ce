require 'yaml'

module Gitlab
  module SidekiqConfig
    def self.redis_queues
      @redis_queues ||= Sidekiq::Queue.all.map(&:name)
    end

    def self.config_queues
      @config_queues ||= YAML.load_file(Rails.root.join('config', 'sidekiq_queues.yml').to_s).fetch(:queues).map { |queue, _| queue }
    end

    def self.cron_workers
      @cron_workers ||= Settings.cron_jobs.map { |job_name, options| options['job_class'].constantize }
    end

    def self.workers(rails_root = Rails.root)
      @workers = {}
      @workers[rails_root.to_s] ||=
        find_workers(rails_root.join('app', 'workers'))
    end

    def self.worker_queues(rails_root = Rails.root)
      @worker_queues = {}
      @worker_queues[rails_root.to_s] ||= begin
        workers = workers(rails_root)
        queues = workers.map(&:queue)
        queues << 'mailers' # ActionMailer::DeliveryJob.queue_name
        queues << 'default'
        queues
      end
    end

    def self.expand_queues(queues, all_queues = nil)
      return [] if queues.empty?

      all_queues ||= worker_queues.to_set

      queues.flat_map do |queue|
        next queue if all_queues.include?(queue)

        all_queues.grep(/\A#{queue}:/)
      end
    end

    private

    def self.workers_by_queue
      @workers_by_queue ||= workers.index_by(&:queue)
    end

    def self.find_workers(root)
      concerns = root.join('concerns').to_s

      workers = Dir[root.join('**', '*.rb')]
        .reject { |path| path.start_with?(concerns) }

      workers.map! do |path|
        ns = Pathname.new(path).relative_path_from(root).to_s.gsub('.rb', '')

        ns.camelize.constantize
      end

      # Skip concerns
      workers.select { |w| w < Sidekiq::Worker }
    end
  end
end
