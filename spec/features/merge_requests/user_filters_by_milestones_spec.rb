require 'rails_helper'

feature 'Merge Requests > User filters by milestones', :js do
  include FilteredSearchHelpers

  given(:project)   { create(:project, :public, :repository) }
  given(:user)      { project.creator }
  given(:milestone) { create(:milestone, project: project) }

  background do
    create(:merge_request, :with_diffs, source_project: project)
    create(:merge_request, :simple, source_project: project, milestone: milestone)

    sign_in(user)
    visit project_merge_requests_path(project)
  end

  scenario 'filters by no milestone' do
    input_filtered_search('milestone:none')

    expect(page).to have_issuable_counts(open: 1, closed: 0, all: 1)
    expect(page).to have_css('.merge-request', count: 1)
  end

  scenario 'filters by a specific milestone' do
    input_filtered_search("milestone:%'#{milestone.title}'")

    expect(page).to have_issuable_counts(open: 1, closed: 0, all: 1)
    expect(page).to have_css('.merge-request', count: 1)
  end

  describe 'filters by upcoming milestone' do
    scenario 'does not show merge requests with no expiry' do
      input_filtered_search('milestone:upcoming')

      expect(page).to have_issuable_counts(open: 0, closed: 0, all: 0)
      expect(page).to have_css('.merge-request', count: 0)
    end

    context 'with an upcoming milestone' do
      given(:milestone) { create(:milestone, project: project, due_date: Date.tomorrow) }

      scenario 'shows merge requests' do
        input_filtered_search('milestone:upcoming')

        expect(page).to have_issuable_counts(open: 1, closed: 0, all: 1)
        expect(page).to have_css('.merge-request', count: 1)
      end
    end

    context 'with a due milestone' do
      given(:milestone) { create(:milestone, project: project, due_date: Date.yesterday) }

      scenario 'does not show any merge requests' do
        input_filtered_search('milestone:upcoming')

        expect(page).to have_issuable_counts(open: 0, closed: 0, all: 0)
        expect(page).to have_css('.merge-request', count: 0)
      end
    end
  end
end
