require 'rails_helper'

feature 'Merge request > User selects branches for new MR', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }

  background do
    project.add_master(user)
    sign_in user
  end

  scenario 'selects the source branch sha when a tag with the same name exists' do
    visit project_merge_requests_path(project)

    page.within '.content' do
      click_link 'New merge request'
    end
    expect(page).to have_content('Source branch')
    expect(page).to have_content('Target branch')

    first('.js-source-branch').click
    find('.dropdown-source-branch .dropdown-content a', match: :first).click

    expect(page).to have_content "b83d6e3"
  end

  scenario 'selects the target branch sha when a tag with the same name exists' do
    visit project_merge_requests_path(project)

    page.within '.content' do
      click_link 'New merge request'
    end

    expect(page).to have_content('Source branch')
    expect(page).to have_content('Target branch')

    first('.js-target-branch').click
    find('.dropdown-target-branch .dropdown-content a', text: 'v1.1.0', match: :first).click

    expect(page).to have_content "b83d6e3"
  end

  scenario 'generates a diff for an orphaned branch' do
    visit project_merge_requests_path(project)

    page.within '.content' do
      click_link 'New merge request'
    end
    expect(page).to have_content('Source branch')
    expect(page).to have_content('Target branch')

    find('.js-source-branch', match: :first).click
    find('.dropdown-source-branch .dropdown-content a', text: 'orphaned-branch', match: :first).click

    click_button "Compare branches"
    click_link "Changes"

    expect(page).to have_content "README.md"
    expect(page).to have_content "wm.png"

    fill_in "merge_request_title", with: "Orphaned MR test"
    click_button "Submit merge request"

    click_link "Check out branch"

    expect(page).to have_content 'git checkout -b orphaned-branch origin/orphaned-branch'
  end

  context 'when target project cannot be viewed by the current user' do
    scenario 'does not leak the private project name & namespace' do
      private_project = create(:project, :private, :repository)

      visit project_new_merge_request_path(project, merge_request: { target_project_id: private_project.id })

      expect(page).not_to have_content private_project.full_path
      expect(page).to have_content project.full_path
    end
  end

  context 'when source project cannot be viewed by the current user' do
    scenario 'does not leak the private project name & namespace' do
      private_project = create(:project, :private, :repository)

      visit project_new_merge_request_path(project, merge_request: { source_project_id: private_project.id })

      expect(page).not_to have_content private_project.full_path
      expect(page).to have_content project.full_path
    end
  end

  scenario 'populates source branch button' do
    visit project_new_merge_request_path(project, change_branches: true, merge_request: { target_branch: 'master', source_branch: 'fix' })

    expect(find('.js-source-branch')).to have_content('fix')
  end

  scenario 'allows to change the diff view' do
    visit project_new_merge_request_path(project, merge_request: { target_branch: 'master', source_branch: 'fix' })

    click_link 'Changes'

    expect(page).to have_css('a.btn.active', text: 'Inline')
    expect(page).not_to have_css('a.btn.active', text: 'Side-by-side')

    click_link 'Side-by-side'

    within '.merge-request' do
      expect(page).not_to have_css('a.btn.active', text: 'Inline')
      expect(page).to have_css('a.btn.active', text: 'Side-by-side')
    end
  end

  scenario 'does not allow non-existing branches' do
    visit project_new_merge_request_path(project, merge_request: { target_branch: 'non-exist-target', source_branch: 'non-exist-source' })

    expect(page).to have_content('The form contains the following errors')
    expect(page).to have_content('Source branch "non-exist-source" does not exist')
    expect(page).to have_content('Target branch "non-exist-target" does not exist')
  end

  context 'when a branch contains commits that both delete and add the same image' do
    scenario 'renders the diff successfully' do
      visit project_new_merge_request_path(project, merge_request: { target_branch: 'master', source_branch: 'deleted-image-test' })

      click_link "Changes"

      expect(page).to have_content "6049019_460s.jpg"
    end
  end

  # Isolates a regression (see #24627)
  scenario 'does not show error messages on initial form' do
    visit project_new_merge_request_path(project)
    expect(page).not_to have_selector('#error_explanation')
    expect(page).not_to have_content('The form contains the following error')
  end

  context 'when a new merge request has a pipeline' do
    given!(:pipeline) do
      create(:ci_pipeline, sha: project.commit('fix').id,
                           ref: 'fix',
                           project: project)
    end

    scenario 'shows pipelines for a new merge request' do
      visit project_new_merge_request_path(
        project,
        merge_request: { target_branch: 'master', source_branch: 'fix' })

      page.within('.merge-request') do
        click_link 'Pipelines'
        wait_for_requests

        expect(page).to have_content "##{pipeline.id}"
      end
    end
  end
end
