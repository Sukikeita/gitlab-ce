require 'spec_helper'

describe MergeRequests::PostMergeService do
  let(:user) { create(:user) }
  let(:merge_request) { create(:merge_request, assignee: user) }
  let(:project) { merge_request.project }

  before do
    project.team << [user, :master]
  end

  describe '#execute' do
    it_behaves_like 'cache counters invalidator'

    it 'refreshes the number of open merge requests for a valid MR', :use_clean_rails_memory_store_caching do
      # Cache the counter before the MR changed state.
      project.open_merge_requests_count
      merge_request.update!(state: 'merged')

      service = described_class.new(project, user, {})

      expect { service.execute(merge_request) }
        .to change { project.open_merge_requests_count }.from(1).to(0)
    end

    it 'updates statistics' do
      service = described_class.new(project, user, {})
      service.execute(merge_request)

      statistics = merge_request.statistics

      expect(statistics.merged_by).to eq(user)
      expect(statistics.merged_at).to be_present
    end
  end
end
