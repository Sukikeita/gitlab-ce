require 'rails_helper'

describe 'Merge request > User sees deleted target branch', :js do
  let(:merge_request) { create(:merge_request) }
  let(:project) { merge_request.project }
  let(:user) { project.owner }

  before do
    DeleteBranchService.new(project, user).execute(merge_request.target_branch)
    sign_in(user)
    visit project_merge_request_path(project, merge_request)
  end

  it 'shows a message about missing target branch' do
    expect(page).to have_content('Target branch does not exist')
    expect(page).not_to have_selector('.mr-widget-body .js-branch-text a')
  end
end
