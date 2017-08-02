require 'rails_helper'

feature 'Merge requests > User merges immediately', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given!(:merge_request) do
    create(:merge_request_with_diffs, source_project: project,
                                      author: user,
                                      title: 'Bug NS-04',
                                      head_pipeline: pipeline,
                                      source_branch: pipeline.ref)
  end
  given(:pipeline) do
    create(:ci_pipeline, project: project,
                         ref: 'master',
                         sha: project.repository.commit('master').id)
  end

  context 'when there is active pipeline for merge request' do
    background do
      create(:ci_build, pipeline: pipeline)
      project.add_master(user)
      sign_in(user)
      visit project_merge_request_path(project, merge_request)
    end

    scenario 'enables merge immediately' do
      page.within '.mr-widget-body' do
        find('.dropdown-toggle').click

        Sidekiq::Testing.fake! do
          click_link 'Merge immediately'

          expect(find('.accept-merge-request.btn-info')).to have_content('Merge in progress')

          wait_for_requests
        end
      end
    end
  end
end
