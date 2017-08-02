require 'rails_helper'

feature 'Merge request > User merges when pipeline succeeds', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given(:merge_request) do
    create(:merge_request_with_diffs, source_project: project,
                                      author: user,
                                      title: 'Bug NS-04',
                                      merge_params: { force_remove_source_branch: '1' })
  end
  given(:pipeline) do
    create(:ci_pipeline, project: project,
                         sha: merge_request.diff_head_sha,
                         ref: merge_request.source_branch,
                         head_pipeline_of: merge_request)
  end

  background do
    project.add_master(user)
  end

  context 'when there is active pipeline for merge request' do
    background do
      create(:ci_build, pipeline: pipeline)
      sign_in(user)
      visit project_merge_request_path(project, merge_request)
    end

    describe 'enabling Merge when pipeline succeeds' do
      shared_examples 'Merge when pipeline succeeds activator' do
        scenario 'activates the Merge when pipeline succeeds feature' do
          click_button "Merge when pipeline succeeds"

          expect(page).to have_content "Set by #{user.name} to be merged automatically when the pipeline succeeds"
          expect(page).to have_content "The source branch will not be removed"
          expect(page).to have_selector ".js-cancel-auto-merge"
          visit project_merge_request_path(project, merge_request) # Needed to refresh the page
          expect(page).to have_content /enabled an automatic merge when the pipeline for \h{8} succeeds/i
        end
      end

      context "when enabled immediately" do
        it_behaves_like 'Merge when pipeline succeeds activator'
      end

      context 'when enabled after pipeline status changed' do
        background do
          pipeline.run!

          # We depend on merge request widget being reloaded
          # so we have to wait for asynchronous call to reload it
          # and have_content expectation handles that.
          #
          expect(page).to have_content "Pipeline ##{pipeline.id} running"
        end

        it_behaves_like 'Merge when pipeline succeeds activator'
      end

      context 'when enabled after it was previously canceled' do
        background do
          click_button "Merge when pipeline succeeds"
          click_link "Cancel automatic merge"
        end

        it_behaves_like 'Merge when pipeline succeeds activator'
      end

      context 'when it was enabled and then canceled' do
        given(:merge_request) do
          create(:merge_request_with_diffs,
                 :merge_when_pipeline_succeeds,
                   source_project: project,
                   title: 'Bug NS-04',
                   author: user,
                   merge_user: user,
                   merge_params: { force_remove_source_branch: '1' })
        end

        background do
          click_link "Cancel automatic merge"
        end

        it_behaves_like 'Merge when pipeline succeeds activator'
      end
    end

    describe 'enabling Merge when pipeline succeeds via dropdown' do
      it 'activates the Merge when pipeline succeeds feature' do
        find('.js-merge-moment').click
        click_link 'Merge when pipeline succeeds'

        expect(page).to have_content "Set by #{user.name} to be merged automatically when the pipeline succeeds"
        expect(page).to have_content "The source branch will not be removed"
        expect(page).to have_link "Cancel automatic merge"
      end
    end
  end

  context 'when merge when pipeline succeeds is enabled' do
    given(:merge_request) do
      create(:merge_request_with_diffs, :simple,  source_project: project,
                                                  author: user,
                                                  merge_user: user,
                                                  title: 'MepMep',
                                                  merge_when_pipeline_succeeds: true)
    end
    given!(:build) do
      create(:ci_build, pipeline: pipeline)
    end

    background do
      sign_in user
      visit project_merge_request_path(project, merge_request)
    end

    scenario 'allows to cancel the automatic merge' do
      click_link "Cancel automatic merge"

      expect(page).to have_button "Merge when pipeline succeeds"

      refresh

      expect(page).to have_content "canceled the automatic merge"
    end

    context 'when pipeline succeeds' do
      background do
        build.success
        refresh
      end

      scenario 'merges merge request' do
        expect(page).to have_content 'The changes were merged'
        expect(merge_request.reload).to be_merged
      end
    end

    context 'view merge request with MWPS enabled but automatically merge fails' do
      background do
        merge_request.update(
          merge_user: merge_request.author,
          merge_error: 'Something went wrong'
        )
        refresh
      end

      scenario 'shows information about the merge error' do
        # Wait for the `ci_status` and `merge_check` requests
        wait_for_requests

        page.within('.mr-widget-body') do
          expect(page).to have_content('Something went wrong')
        end
      end
    end

    context 'view merge request with MWPS enabled but automatically merge fails' do
      background do
        merge_request.update(
          merge_user: merge_request.author,
          merge_error: 'Something went wrong'
        )
        refresh
      end

      scenario 'shows information about the merge error' do
        # Wait for the `ci_status` and `merge_check` requests
        wait_for_requests

        page.within('.mr-widget-body') do
          expect(page).to have_content('Something went wrong')
        end
      end
    end
  end

  context 'when pipeline is not active' do
    it "does not allow to enable merge when pipeline succeeds" do
      visit project_merge_request_path(project, merge_request)

      expect(page).not_to have_link 'Merge when pipeline succeeds'
    end
  end
end
