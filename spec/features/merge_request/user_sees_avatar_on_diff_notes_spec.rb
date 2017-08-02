require 'rails_helper'

feature 'Merge request > User sees avatars on diff notes', :js do
  include NoteInteractionHelpers

  given(:project)       { create(:project, :public, :repository) }
  given(:user)          { project.creator }
  given(:merge_request) { create(:merge_request_with_diffs, source_project: project, author: user, title: "Bug NS-04") }
  given(:path)          { "files/ruby/popen.rb" }
  given(:position) do
    Gitlab::Diff::Position.new(
      old_path: path,
      new_path: path,
      old_line: nil,
      new_line: 9,
      diff_refs: merge_request.diff_refs
    )
  end
  given!(:note) { create(:diff_note_on_merge_request, project: project, noteable: merge_request, position: position) }

  background do
    project.add_master(user)
    sign_in user

    page.driver.set_cookie('sidebar_collapsed', 'true')
  end

  context 'discussion tab' do
    background do
      visit project_merge_request_path(project, merge_request)
    end

    scenario 'does not show avatars on discussion tab' do
      expect(page).not_to have_selector('.js-avatar-container')
      expect(page).not_to have_selector('.diff-comment-avatar-holders')
    end

    scenario 'does not render avatars after commening on discussion tab' do
      click_button 'Reply...'

      page.within('.js-discussion-note-form') do
        find('.note-textarea').native.send_keys('Test comment')

        click_button 'Comment'
      end

      expect(page).to have_content('Test comment')
      expect(page).not_to have_selector('.js-avatar-container')
      expect(page).not_to have_selector('.diff-comment-avatar-holders')
    end
  end

  context 'commit view' do
    background do
      visit project_commit_path(project, merge_request.commits.first.id)
    end

    scenario 'does not render avatar after commenting' do
      first('.diff-line-num').trigger('mouseover')
      find('.js-add-diff-note-button').click

      page.within('.js-discussion-note-form') do
        find('.note-textarea').native.send_keys('test comment')

        click_button 'Comment'

        wait_for_requests
      end

      visit project_merge_request_path(project, merge_request)

      expect(page).to have_content('test comment')
      expect(page).not_to have_selector('.js-avatar-container')
      expect(page).not_to have_selector('.diff-comment-avatar-holders')
    end
  end

  %w(inline parallel).each do |view|
    context "#{view} view" do
      background do
        visit diffs_project_merge_request_path(project, merge_request, view: view)

        wait_for_requests
      end

<<<<<<< HEAD:spec/features/merge_requests/diff_notes_avatars_spec.rb
      it 'shows note avatar' do
        page.within find_line(position.line_code(project.repository)) do
=======
      scenario 'shows note avatar' do
        page.within find("[id='#{position.line_code(project.repository)}']") do
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_avatar_on_diff_notes_spec.rb
          find('.diff-notes-collapse').click

          expect(page).to have_selector('img.js-diff-comment-avatar', count: 1)
        end
      end

<<<<<<< HEAD:spec/features/merge_requests/diff_notes_avatars_spec.rb
      it 'shows comment on note avatar' do
        page.within find_line(position.line_code(project.repository)) do
=======
      scenario 'shows comment on note avatar' do
        page.within find("[id='#{position.line_code(project.repository)}']") do
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_avatar_on_diff_notes_spec.rb
          find('.diff-notes-collapse').click

          expect(first('img.js-diff-comment-avatar')["data-original-title"]).to eq("#{note.author.name}: #{note.note.truncate(17)}")
        end
      end

<<<<<<< HEAD:spec/features/merge_requests/diff_notes_avatars_spec.rb
      it 'toggles comments when clicking avatar' do
        page.within find_line(position.line_code(project.repository)) do
=======
      scenario 'toggles comments when clicking avatar' do
        page.within find("[id='#{position.line_code(project.repository)}']") do
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_avatar_on_diff_notes_spec.rb
          find('.diff-notes-collapse').click
        end

        expect(page).to have_selector('.notes_holder', visible: false)

        page.within find_line(position.line_code(project.repository)) do
          first('img.js-diff-comment-avatar').click
        end

        expect(page).to have_selector('.notes_holder')
      end

      scenario 'removes avatar when note is deleted' do
        open_more_actions_dropdown(note)

        page.within find(".note-row-#{note.id}") do
          find('.js-note-delete').click
        end

        wait_for_requests

        page.within find_line(position.line_code(project.repository)) do
          expect(page).not_to have_selector('img.js-diff-comment-avatar')
        end
      end

      scenario 'adds avatar when commenting' do
        click_button 'Reply...'

        page.within '.js-discussion-note-form' do
          find('.js-note-text').native.send_keys('Test')

          click_button 'Comment'

          wait_for_requests
        end

        page.within find_line(position.line_code(project.repository)) do
          find('.diff-notes-collapse').trigger('click')

          expect(page).to have_selector('img.js-diff-comment-avatar', count: 2)
        end
      end

      scenario 'adds multiple comments' do
        3.times do
          click_button 'Reply...'

          page.within '.js-discussion-note-form' do
            find('.js-note-text').native.send_keys('Test')
<<<<<<< HEAD:spec/features/merge_requests/diff_notes_avatars_spec.rb

            find('.js-comment-button').trigger('click')
=======
            find('.js-comment-button').trigger 'click'
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_avatar_on_diff_notes_spec.rb

            wait_for_requests
          end
        end

        page.within find_line(position.line_code(project.repository)) do
          find('.diff-notes-collapse').trigger('click')

          expect(page).to have_selector('img.js-diff-comment-avatar', count: 3)
          expect(find('.diff-comments-more-count')).to have_content '+1'
        end
      end

      context 'multiple comments' do
        background do
          create_list(:diff_note_on_merge_request, 3, project: project, noteable: merge_request, in_reply_to: note)
          visit diffs_project_merge_request_path(project, merge_request, view: view)

          wait_for_requests
        end

<<<<<<< HEAD:spec/features/merge_requests/diff_notes_avatars_spec.rb
        it 'shows extra comment count' do
          page.within find_line(position.line_code(project.repository)) do
=======
        scenario 'shows extra comment count' do
          page.within find("[id='#{position.line_code(project.repository)}']") do
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_avatar_on_diff_notes_spec.rb
            find('.diff-notes-collapse').click

            expect(find('.diff-comments-more-count')).to have_content '+1'
          end
        end
      end
    end
  end

  def find_line(line_code)
    line = find("[id='#{line_code}']")
    line = line.find(:xpath, 'preceding-sibling::*[1][self::td]') if line.tag_name == 'td'
    line
  end
end
