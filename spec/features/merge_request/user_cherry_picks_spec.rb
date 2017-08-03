require 'rails_helper'

feature 'Merge request > User cherry-picks', :js do
  given(:group) { create(:group) }
  given(:project) { create(:project, :repository, namespace: group) }
  given(:user) { project.creator }
  given(:merge_request) { create(:merge_request_with_diffs, source_project: project, author: user) }

  before do
    project.add_master(user)
    sign_in(user)
  end

  context 'Viewing a merged merge request' do
    before do
      service = MergeRequests::MergeService.new(project, user)

      perform_enqueued_jobs do
        service.execute(merge_request)
      end
    end

    # Fast-forward merge, or merged before GitLab 8.5.
    context 'Without a merge commit' do
      before do
        merge_request.merge_commit_sha = nil
        merge_request.save
      end

      scenario 'does not show a Cherry-pick button' do
        visit project_merge_request_path(project, merge_request)

        expect(page).not_to have_link 'Cherry-pick'
      end
    end

    context 'With a merge commit' do
      scenario 'shows a Cherry-pick button' do
        visit project_merge_request_path(project, merge_request)

        expect(page).to have_link 'Cherry-pick'
      end
    end
  end
end
