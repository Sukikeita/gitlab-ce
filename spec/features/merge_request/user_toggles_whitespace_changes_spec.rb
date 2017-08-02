require 'rails_helper'

feature 'Merge request > User toggles whitespace changes', :js do
  given(:merge_request) { create(:merge_request) }
  given(:project) { merge_request.project }
  given(:user) { project.creator }

  background do
    project.add_master(user)
    sign_in(user)
    visit diffs_project_merge_request_path(project, merge_request)
  end

  scenario 'has a button to toggle whitespace changes' do
    expect(page).to have_content 'Hide whitespace changes'
  end

  describe 'clicking "Hide whitespace changes" button' do
    scenario 'toggles the "Hide whitespace changes" button' do
      click_link 'Hide whitespace changes'

      expect(page).to have_content 'Show whitespace changes'
    end
  end
end
