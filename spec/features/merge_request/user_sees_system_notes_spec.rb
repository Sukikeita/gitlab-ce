require 'rails_helper'

feature 'Merge request > User sees system notes' do
  given(:public_project) { create(:project, :public, :repository) }
  given(:private_project) { create(:project, :private, :repository) }
  given(:user)            { private_project.creator }
  given(:issue) { create(:issue, project: private_project) }
  given(:merge_request) { create(:merge_request, source_project: public_project, source_branch: 'markdown') }
  given!(:note) { create(:note_on_merge_request, :system, noteable: merge_request, project: public_project, note: "mentioned in #{issue.to_reference(public_project)}") }

  context 'when logged-in as a member of the private project' do
    background do
      private_project.add_developer(user)
      sign_in(user)
    end

    scenario 'shows the system note' do
      visit project_merge_request_path(public_project, merge_request)

      expect(page).to have_css('.system-note')
    end
  end

  context 'when not logged-in' do
    scenario 'hides the system note' do
      visit project_merge_request_path(public_project, merge_request)

      expect(page).not_to have_css('.system-note')
    end
  end
end
