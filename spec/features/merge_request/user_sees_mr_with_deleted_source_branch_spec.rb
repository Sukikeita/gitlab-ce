require 'rails_helper'

# This test serves as a regression test for a bug that caused an error
# message to be shown by JavaScript when the source branch was deleted.
describe 'Merge request > User sees MR with deleted source branch', :js do
  let(:project) { create(:project, :public, :repository) }
  let(:merge_request) { create(:merge_request, source_project: project) }
  let(:user) { project.owner }

  before do
    merge_request.update!(source_branch: 'this-branch-does-not-exist')
    sign_in(user)
    visit project_merge_request_path(project, merge_request)
  end

  it 'shows a message about missing source branch and ' do
    expect(page).to have_content('Source branch does not exist.')

    within '.merge-request-details' do
      expect(page).to have_content('Discussion')
      expect(page).to have_content('Commits')
      expect(page).to have_content('Changes')
    end

    click_on 'Changes'
    wait_for_requests

    expect(page).to have_selector('.diffs.tab-pane .nothing-here-block')
    expect(page).to have_content('Source branch does not exist.')
  end
end
