require 'spec_helper'

describe API::V3::V3::SidekiqMetrics do
  let(:admin) { create(:user, :admin) }

  describe 'GET sidekiq/*' do
    it 'defines the `queue_metrics` endpoint' do
      get v3_api('/sidekiq/queue_metrics', admin)

      expect(response).to have_http_status(200)
      expect(json_response).to be_a Hash
    end

    it 'defines the `process_metrics` endpoint' do
      get v3_api('/sidekiq/process_metrics', admin)

      expect(response).to have_http_status(200)
      expect(json_response['processes']).to be_an Array
    end

    it 'defines the `job_stats` endpoint' do
      get v3_api('/sidekiq/job_stats', admin)

      expect(response).to have_http_status(200)
      expect(json_response).to be_a Hash
    end

    it 'defines the `compound_metrics` endpoint' do
      get v3_api('/sidekiq/compound_metrics', admin)

      expect(response).to have_http_status(200)
      expect(json_response).to be_a Hash
      expect(json_response['queues']).to be_a Hash
      expect(json_response['processes']).to be_an Array
      expect(json_response['jobs']).to be_a Hash
    end
  end
end
