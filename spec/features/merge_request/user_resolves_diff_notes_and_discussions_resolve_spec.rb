require 'rails_helper'

feature 'Merge request > User resolves diff notes and discussions', :js do
  given(:project)       { create(:project, :public, :repository) }
  given(:user)          { project.creator }
  given(:guest)         { create(:user) }
  given(:merge_request) { create(:merge_request_with_diffs, source_project: project, author: user, title: "Bug NS-04") }
  let!(:note)           { create(:diff_note_on_merge_request, project: project, noteable: merge_request) }
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

  context 'no discussions' do
    background do
      project.add_master(user)
      sign_in(user)
      note.destroy
      visit_merge_request
    end

    scenario 'displays no discussion resolved data' do
      expect(page).not_to have_content('discussion resolved')
      expect(page).not_to have_selector('.discussion-next-btn')
    end
  end

  context 'as authorized user' do
    background do
      project.add_master(user)
      sign_in(user)
      visit_merge_request
    end

    context 'single discussion' do
      scenario 'shows text with how many discussions' do
        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'allows user to mark a note as resolved' do
        page.within '.diff-content .note' do
          find('.line-resolve-btn').click

          expect(page).to have_selector('.line-resolve-btn.is-active')
          expect(find('.line-resolve-btn')['data-original-title']).to eq("Resolved by #{user.name}")
        end

        page.within '.diff-content' do
          expect(page).to have_selector('.btn', text: 'Unresolve discussion')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to mark discussion as resolved' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'
        end

        expect(page).to have_selector('.discussion-body', visible: false)

        page.within '.diff-content .note' do
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to unresolve discussion' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'
          click_button 'Unresolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'allows user to resolve from reply form without a comment' do
        page.within '.diff-content' do
          click_button 'Reply...'

          click_button 'Resolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to unresolve from reply form without a comment' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'
          sleep 1

          click_button 'Reply...'

          click_button 'Unresolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
          expect(page).not_to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to comment & resolve discussion' do
        page.within '.diff-content' do
          click_button 'Reply...'

          find('.js-note-text').set 'testing'

          click_button 'Comment & resolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to comment & unresolve discussion' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'

          click_button 'Reply...'

          find('.js-note-text').set 'testing'

          click_button 'Comment & unresolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'allows user to quickly scroll to next unresolved discussion' do
        page.within '.line-resolve-all-container' do
          page.find('.discussion-next-btn').click
        end

        expect(page.evaluate_script("$('body').scrollTop()")).to be > 0
      end

      scenario 'hides jump to next button when all resolved' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'
        end

        expect(page).to have_selector('.discussion-next-btn', visible: false)
      end

      scenario 'updates updated text after resolving note' do
        page.within '.diff-content .note' do
          find('.line-resolve-btn').click
        end

        expect(page).to have_content("Resolved by #{user.name}")
      end

      scenario 'hides jump to next discussion button' do
        page.within '.discussion-reply-holder' do
          expect(page).not_to have_selector('.discussion-next-btn')
        end
      end
    end

    context 'multiple notes' do
      background do
        create(:diff_note_on_merge_request, project: project, noteable: merge_request, in_reply_to: note)
        visit_merge_request
      end

<<<<<<< HEAD:spec/features/merge_requests/diff_notes_resolve_spec.rb
      it 'does not mark discussion as resolved when resolving single note' do
        page.within("#note_#{note.id}") do
=======
      scenario 'does not mark discussion as resolved when resolving single note' do
        page.first '.diff-content .note' do
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_resolves_diff_notes_and_discussions_resolve_spec.rb
          first('.line-resolve-btn').click

          wait_for_requests

          expect(first('.line-resolve-btn')['data-original-title']).to eq("Resolved by #{user.name}")
        end

        expect(page).to have_content('Last updated')

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'resolves discussion' do
        page.all('.note').each do |note|
          note.all('.line-resolve-btn').each do |button|
            button.click
          end
        end

        expect(page).to have_content('Resolved by')

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
        end
      end
    end

    context 'muliple discussions' do
      background do
        create(:diff_note_on_merge_request, project: project, position: position, noteable: merge_request)
        visit_merge_request
      end

      scenario 'shows text with how many discussions' do
        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/2 discussions resolved')
        end
      end

      scenario 'allows user to mark a single note as resolved' do
        click_button('Resolve discussion', match: :first)

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/2 discussions resolved')
        end
      end

      scenario 'allows user to mark all notes as resolved' do
        page.all('.line-resolve-btn').each do |btn|
          btn.click
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('2/2 discussions resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user user to mark all discussions as resolved' do
        page.all('.discussion-reply-holder').each do |reply_holder|
          page.within reply_holder do
            click_button 'Resolve discussion'
          end
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('2/2 discussions resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to quickly scroll to next unresolved discussion' do
        page.within first('.discussion-reply-holder') do
          click_button 'Resolve discussion'
        end

        page.within '.line-resolve-all-container' do
          page.find('.discussion-next-btn').trigger('click')
        end

        expect(page.evaluate_script("$('body').scrollTop()")).to be > 0
      end

      scenario 'updates updated text after resolving note' do
        page.within first('.diff-content .note') do
          find('.line-resolve-btn').click
        end

        expect(page).to have_content("Resolved by #{user.name}")
      end

      scenario 'shows jump to next discussion button' do
        page.all('.discussion-reply-holder').each do |holder|
          expect(holder).to have_selector('.discussion-next-btn')
        end
      end

      scenario 'displays next discussion even if hidden' do
        page.all('.note-discussion').each do |discussion|
          page.within discussion do
            click_button 'Toggle discussion'
          end
        end

        page.within('.issuable-discussion #notes') do
          expect(page).not_to have_selector('.btn', text: 'Resolve discussion')
        end

        page.within '.line-resolve-all-container' do
          page.find('.discussion-next-btn').click
        end

        expect(find('.discussion-with-resolve-btn')).to have_selector('.btn', text: 'Resolve discussion')
      end
    end

    context 'changes tab' do
      scenario 'shows text with how many discussions' do
        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'allows user to mark a note as resolved' do
        page.within '.diff-content .note' do
          find('.line-resolve-btn').click

          expect(page).to have_selector('.line-resolve-btn.is-active')
        end

        page.within '.diff-content' do
          expect(page).to have_selector('.btn', text: 'Unresolve discussion')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to mark discussion as resolved' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'
        end

        page.within '.diff-content .note' do
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to unresolve discussion' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'
          click_button 'Unresolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'allows user to comment & resolve discussion' do
        page.within '.diff-content' do
          click_button 'Reply...'

          find('.js-note-text').set 'testing'

          click_button 'Comment & resolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end

      scenario 'allows user to comment & unresolve discussion' do
        page.within '.diff-content' do
          click_button 'Resolve discussion'

          click_button 'Reply...'

          find('.js-note-text').set 'testing'

          click_button 'Comment & unresolve discussion'
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end
    end
  end

  context 'as a guest' do
    background do
      project.add_guest(guest)
      sign_in(guest)
    end

    context 'someone elses merge request' do
      background do
        visit_merge_request
      end

      scenario 'does not allow user to mark note as resolved' do
        page.within '.diff-content .note' do
          expect(page).not_to have_selector('.line-resolve-btn')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end

      scenario 'does not allow user to mark discussion as resolved' do
        page.within '.diff-content .note' do
          expect(page).not_to have_selector('.btn', text: 'Resolve discussion')
        end
      end
    end

    context 'guest users merge request' do
      let(:user) { guest }

      background do
        visit_merge_request
      end

      scenario 'allows user to mark a note as resolved' do
        page.within '.diff-content .note' do
          find('.line-resolve-btn').click

          expect(page).to have_selector('.line-resolve-btn.is-active')
        end

        page.within '.diff-content' do
          expect(page).to have_selector('.btn', text: 'Unresolve discussion')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('1/1 discussion resolved')
          expect(page).to have_selector('.line-resolve-btn.is-active')
        end
      end
    end
  end

  context 'unauthorized user' do
    context 'no resolved comments' do
      background do
        visit_merge_request
      end

      scenario 'does not allow user to mark note as resolved' do
        page.within '.diff-content .note' do
          expect(page).not_to have_selector('.line-resolve-btn')
        end

        page.within '.line-resolve-all-container' do
          expect(page).to have_content('0/1 discussion resolved')
        end
      end
    end

    context 'resolved comment' do
      background do
        note.resolve!(user)
        visit_merge_request
      end

      scenario 'shows resolved icon' do
        expect(page).to have_content '1/1 discussion resolved'

        click_button 'Toggle discussion'
        expect(page).to have_selector('.line-resolve-btn.is-active')
      end

      scenario 'does not allow user to click resolve button' do
        expect(page).to have_selector('.line-resolve-btn.is-disabled')
        click_button 'Toggle discussion'

        expect(page).to have_selector('.line-resolve-btn.is-disabled')
      end
    end
  end

  def visit_merge_request(mr = nil)
    mr = mr || merge_request
    visit project_merge_request_path(mr.project, mr)
  end
end
