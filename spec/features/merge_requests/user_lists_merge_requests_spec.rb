require 'rails_helper'

feature 'Merge requests > User lists merge requests' do
  include MergeRequestHelpers
  include SortingHelper

  given(:project) { create(:project, :public, :repository) }
  given(:user) { create(:user) }

  background do
    @fix = create(:merge_request,
                  title: 'fix',
                  source_project: project,
                  source_branch: 'fix',
                  assignee: user,
                  milestone: create(:milestone, due_date: '2013-12-11'),
                  created_at: 1.minute.ago,
                  updated_at: 1.minute.ago)
    create(:merge_request,
           title: 'markdown',
           source_project: project,
           source_branch: 'markdown',
           assignee: user,
           milestone: create(:milestone, due_date: '2013-12-12'),
           created_at: 2.minutes.ago,
           updated_at: 2.minutes.ago)
    create(:merge_request,
           title: 'merge-test',
           source_project: project,
           source_branch: 'merge-test',
           created_at: 3.minutes.ago,
           updated_at: 10.seconds.ago)
  end

  scenario 'sorts by newest' do
    visit_merge_requests(project, sort: sort_value_recently_created)

    expect(first_merge_request).to include('fix')
    expect(last_merge_request).to include('merge_lfs')
    expect(count_merge_requests).to eq(3)
  end

  scenario 'sorts by oldest' do
    visit_merge_requests(project, sort: sort_value_oldest_created)

    expect(first_merge_request).to include('merge_lfs')
    expect(last_merge_request).to include('fix')
    expect(count_merge_requests).to eq(3)
  end

  scenario 'sorts by last updated' do
    visit_merge_requests(project, sort: sort_value_recently_updated)

    expect(first_merge_request).to include('merge_lfs')
    expect(count_merge_requests).to eq(3)
  end

  scenario 'sorts by oldest updated' do
    visit_merge_requests(project, sort: sort_value_oldest_updated)

    expect(first_merge_request).to include('markdown')
    expect(count_merge_requests).to eq(3)
  end

  scenario 'sorts by milestone due soon' do
    visit_merge_requests(project, sort: sort_value_milestone_soon)

    expect(first_merge_request).to include('fix')
    expect(count_merge_requests).to eq(3)
  end

  scenario 'sorts by milestone due later' do
    visit_merge_requests(project, sort: sort_value_milestone_later)

    expect(first_merge_request).to include('markdown')
    expect(count_merge_requests).to eq(3)
  end

  scenario 'filters on one label and sorts by due soon' do
    label = create(:label, project: project)
    create(:label_link, label: label, target: @fix)

    visit_merge_requests(project, label_name: [label.name],
                                  sort: sort_value_due_date)

    expect(first_merge_request).to include('fix')
    expect(count_merge_requests).to eq(1)
  end

  context 'while filtering on two labels' do
    given(:label) { create(:label, project: project) }
    given(:label2) { create(:label, project: project) }

    background do
      create(:label_link, label: label, target: @fix)
      create(:label_link, label: label2, target: @fix)
    end

    scenario 'sorts by due soon' do
      visit_merge_requests(project, label_name: [label.name, label2.name],
                                    sort: sort_value_due_date)

      expect(first_merge_request).to include('fix')
      expect(count_merge_requests).to eq(1)
    end

    context 'filter on assignee and' do
      scenario 'sorts by due soon' do
        visit_merge_requests(project, label_name: [label.name, label2.name],
                                      assignee_id: user.id,
                                      sort: sort_value_due_date)

        expect(first_merge_request).to include('fix')
        expect(count_merge_requests).to eq(1)
      end

      scenario 'sorts by recently due milestone' do
        visit project_merge_requests_path(project,
          label_name: [label.name, label2.name],
          assignee_id: user.id,
          sort: sort_value_milestone)

        expect(first_merge_request).to include('fix')
      end
    end
  end

  def count_merge_requests
    page.all('ul.mr-list > li').count
  end
end
