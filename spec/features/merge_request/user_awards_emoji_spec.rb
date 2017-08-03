require 'rails_helper'

feature 'Merge request > User awards emoji', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given(:merge_request) { create(:merge_request, source_project: project) }

  describe 'logged in' do
    background do
      sign_in(user)
      visit project_merge_request_path(project, merge_request)
    end

    scenario 'adds award to merge request' do
      first('.js-emoji-btn').click
      expect(page).to have_selector('.js-emoji-btn.active')
      expect(first('.js-emoji-btn')).to have_content '1'

      visit project_merge_request_path(project, merge_request)
      expect(first('.js-emoji-btn')).to have_content '1'
    end

    scenario 'removes award from merge request' do
      first('.js-emoji-btn').click
      find('.js-emoji-btn.active').click
      expect(first('.js-emoji-btn')).to have_content '0'

      visit project_merge_request_path(project, merge_request)
      expect(first('.js-emoji-btn')).to have_content '0'
    end

    scenario 'has only one menu on the page' do
      first('.js-add-award').click
      expect(page).to have_selector('.emoji-menu')

      expect(page).to have_selector('.emoji-menu', count: 1)
    end
  end

  describe 'logged out' do
    background do
      visit project_merge_request_path(project, merge_request)
    end

    scenario 'does not see award menu button' do
      expect(page).not_to have_selector('.js-award-holder')
    end
  end
end
