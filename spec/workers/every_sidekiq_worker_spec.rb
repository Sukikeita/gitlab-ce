require 'spec_helper'

describe 'Every Sidekiq worker' do
  it 'includes ApplicationWorker', :aggregate_failures do
    Gitlab::SidekiqConfig.workers.each do |worker|
      expect(worker).to include(ApplicationWorker)
    end
  end

  it 'does not use the default queue', :aggregate_failures do
    Gitlab::SidekiqConfig.workers.each do |worker|
      expect(worker.queue).not_to eq('default')
    end
  end

  it 'uses the cronjob queue when the worker runs as a cronjob', :aggregate_failures do
    cron_workers = Gitlab::SidekiqConfig.cron_workers.to_set

    Gitlab::SidekiqConfig.workers.each do |worker|
      next unless cron_workers.include?(worker)

      expect(worker.queue).to eq('cronjob')
    end
  end

  it 'defines the queue in the Sidekiq configuration file', :aggregate_failures do
    config_queue_names = Gitlab::SidekiqConfig.config_queues.to_set

    Gitlab::SidekiqConfig.worker_queues.each do |queue_name|
      queue_namespace = queue_name.split(':').first

      expect(config_queue_names).to include(queue_name).or(include(queue_namespace))
    end
  end
end
