require 'spec_helper'

describe ClusterQueue do
  let(:worker) do
    Class.new do
      include ApplicationWorker
      include ClusterQueue
    end
  end

  it 'sets a default pipelines queue automatically' do
    expect(worker.sidekiq_options['queue'])
      .to eq :gcp_cluster
  end
end
