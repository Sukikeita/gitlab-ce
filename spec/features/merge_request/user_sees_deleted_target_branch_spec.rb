require 'rails_helper'

feature 'Merge request > User sees deleted target branch', :js do
  given(:merge_request) { create(:merge_request) }
  given(:project) { merge_request.project }
  given(:user) { project.creator }

  background do
    project.add_master(user)
    DeleteBranchService.new(project, user).execute('feature')
    sign_in(user)
    visit project_merge_request_path(project, merge_request)
  end

  scenario 'shows a message about missing target branch' do
    expect(page).to have_content('Target branch does not exist')
  end

  scenario 'does not show link to target branch' do
    expect(page).not_to have_selector('.mr-widget-body .js-branch-text a')
  end
end
