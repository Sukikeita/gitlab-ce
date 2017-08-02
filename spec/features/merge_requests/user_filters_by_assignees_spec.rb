require 'rails_helper'

feature 'Merge Requests > User filters by assignees', :js do
  include FilteredSearchHelpers

  given(:project) { create(:project, :public, :repository) }
  given(:user)    { project.creator }

  background do
    create(:merge_request, assignee: user, title: 'Bugfix1', source_project: project, target_project: project, source_branch: 'bugfix1')
    create(:merge_request, title: 'Bugfix2', source_project: project, target_project: project, source_branch: 'bugfix2')

    sign_in(user)
    visit project_merge_requests_path(project)
  end

  context 'filtering by assignee:none' do
    scenario 'applies the filter' do
      input_filtered_search('assignee:none')

      expect(page).to have_issuable_counts(open: 1, closed: 0, all: 1)
      expect(page).not_to have_content 'Bugfix1'
      expect(page).to have_content 'Bugfix2'
    end
  end

  context 'filtering by assignee:@username' do
    scenario 'applies the filter' do
      input_filtered_search("assignee:@#{user.username}")

      expect(page).to have_issuable_counts(open: 1, closed: 0, all: 1)
      expect(page).to have_content 'Bugfix1'
      expect(page).not_to have_content 'Bugfix2'
    end
  end
end
