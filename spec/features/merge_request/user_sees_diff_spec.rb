require 'rails_helper'

feature 'Merge request > User sees diff', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:merge_request) { create(:merge_request, source_project: project) }

  context 'when visit with */* as accept header' do
    background do
      page.driver.add_header('Accept', '*/*')
    end

    scenario 'renders the notes' do
      create :note_on_merge_request, project: project, noteable: merge_request, note: 'Rebasing with master'

      visit diffs_project_merge_request_path(project, merge_request)

      # Load notes and diff through AJAX
      expect(page).to have_css('.note-text', visible: false, text: 'Rebasing with master')
      expect(page).to have_css('.diffs.tab-pane.active')
    end
  end

  context 'when linking to note' do
    describe 'with unresolved note' do
      given(:note) { create :diff_note_on_merge_request, project: project, noteable: merge_request }
      given(:fragment) { "#note_#{note.id}" }

      background do
        visit "#{diffs_project_merge_request_path(project, merge_request)}#{fragment}"
      end

      scenario 'shows expanded note' do
        expect(page).to have_selector(fragment, visible: true)
      end
    end

    describe 'with resolved note' do
      given(:note) { create :diff_note_on_merge_request, :resolved, project: project, noteable: merge_request }
      given(:fragment) { "#note_#{note.id}" }

      background do
        visit "#{diffs_project_merge_request_path(project, merge_request)}#{fragment}"
      end

<<<<<<< HEAD:spec/features/merge_requests/diffs_spec.rb
      it 'shows collapsed note' do
        wait_for_requests

        expect(page).to have_selector('.discussion-notes.collapsed') do |note_container|
          expect(note_container).to have_selector(fragment, visible: false)
        end
=======
      scenario 'shows expanded note' do
        expect(page).to have_selector(fragment, visible: true)
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_diff_spec.rb
      end
    end
  end

  context 'when merge request has overflow' do
    scenario 'displays warning' do
      allow(Commit).to receive(:max_diff_options).and_return(max_files: 3)

      visit diffs_project_merge_request_path(project, merge_request)

      page.within('.alert') do
        expect(page).to have_text("Too many changes to show. Plain diff Email patch To preserve
          performance only 3 of 3+ files are displayed.")
      end
    end
  end

  context 'when editing file' do
<<<<<<< HEAD:spec/features/merge_requests/diffs_spec.rb
    let(:author_user) { create(:user) }
    let(:user) { create(:user) }
    let(:forked_project) { fork_project(project, author_user, repository: true) }
    let(:merge_request) { create(:merge_request_with_diffs, source_project: forked_project, target_project: project, author: author_user) }
    let(:changelog_id) { Digest::SHA1.hexdigest("CHANGELOG") }
=======
    given(:author_user) { create(:user) }
    given(:user) { create(:user) }
    given(:forked_project) { Projects::ForkService.new(project, author_user).execute }
    given(:merge_request) { create(:merge_request_with_diffs, source_project: forked_project, target_project: project, author: author_user) }
    given(:changelog_id) { Digest::SHA1.hexdigest("CHANGELOG") }
>>>>>>> Continue to improve MR feature specs and reduce duplication:spec/features/merge_request/user_sees_diff_spec.rb

    background do
      forked_project.repository.after_import
    end

    context 'as author' do
      scenario 'shows direct edit link' do
        sign_in(author_user)
        visit diffs_project_merge_request_path(project, merge_request)

        # Throws `Capybara::Poltergeist::InvalidSelector` if we try to use `#hash` syntax
        expect(page).to have_selector("[id=\"#{changelog_id}\"] a.js-edit-blob")
      end
    end

    context 'as user who needs to fork' do
      scenario 'shows fork/cancel confirmation' do
        sign_in(user)
        visit diffs_project_merge_request_path(project, merge_request)

        # Throws `Capybara::Poltergeist::InvalidSelector` if we try to use `#hash` syntax
        find("[id=\"#{changelog_id}\"] .js-edit-blob").trigger('click')

        expect(page).to have_selector('.js-fork-suggestion-button', count: 1)
        expect(page).to have_selector('.js-cancel-fork-suggestion-button', count: 1)
      end
    end
  end
end
