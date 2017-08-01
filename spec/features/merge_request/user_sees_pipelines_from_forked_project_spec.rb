require 'spec_helper'

feature 'Merge request > User sees pipelines from forked project', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given(:fork_project) { create(:project, :public, :repository) }
  given!(:merge_request) do
    create(:forked_project_link, forked_to_project: fork_project,
                                 forked_from_project: project)

    create(:merge_request_with_diffs, source_project: fork_project,
                                      target_project: project,
                                      description: 'Test merge request')
  end
  given(:pipeline) do
    create(:ci_pipeline,
           project: fork_project,
           sha: merge_request.diff_head_sha,
           ref: merge_request.source_branch)
  end

  background do
    create(:ci_build, pipeline: pipeline, name: 'rspec')
    create(:ci_build, pipeline: pipeline, name: 'spinach')

    sign_in(user)
    visit project_merge_request_path(project, merge_request)
  end

  scenario 'user visits a pipelines page' do
    page.within('.merge-request-tabs') { click_link 'Pipelines' }

    page.within('.ci-table') do
      expect(page).to have_content pipeline.status
      expect(page).to have_content pipeline.id
    end
  end
end
