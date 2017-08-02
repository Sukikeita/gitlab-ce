require 'rails_helper'

feature 'Merge request > User sees notes from forked project', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given(:fork_project) { create(:project, :public, :repository, forked_from_project: project) }
  given!(:merge_request) do
    create(:merge_request_with_diffs, source_project: fork_project,
                                      target_project: project,
                                      description: 'Test merge request')
  end

  background do
    create(:note_on_commit, note: 'A commit comment',
                            project: fork_project,
                            commit_id: merge_request.commit_shas.first)
    sign_in(user)
  end

  scenario 'user can reply to the comment' do
    visit project_merge_request_path(project, merge_request)

    expect(page).to have_content('A commit comment')

    page.within('.discussion-notes') do
      find('.btn-text-field').click
      find('#note_note').send_keys('A reply comment')
      find('.comment-btn').click
    end

    wait_for_requests

    expect(page).to have_content('A reply comment')
  end
end
