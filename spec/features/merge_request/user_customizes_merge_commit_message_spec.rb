require 'rails_helper'

feature 'Merge request < User customizes merge commit message', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given(:issue_1) { create(:issue, project: project)}
  given(:issue_2) { create(:issue, project: project)}
  given(:merge_request) do
    create(
      :merge_request,
      :simple,
      source_project: project,
      description: "Description\n\nclosing #{issue_1.to_reference}, #{issue_2.to_reference}"
    )
  end
  given(:textbox) { page.find(:css, '.js-commit-message', visible: false) }
  given(:default_message) do
    [
      "Merge branch 'feature' into 'master'",
      merge_request.title,
      "Closes #{issue_1.to_reference} and #{issue_2.to_reference}",
      "See merge request #{merge_request.to_reference(full: true)}"
    ].join("\n\n")
  end
  given(:message_with_description) do
    [
      "Merge branch 'feature' into 'master'",
      merge_request.title,
      merge_request.description,
      "See merge request #{merge_request.to_reference(full: true)}"
    ].join("\n\n")
  end

  background do
    project.add_master(user)
    sign_in(user)
    visit project_merge_request_path(project, merge_request)
  end

  scenario 'toggles commit message between message with description and without description' do
    expect(page).not_to have_selector('.js-commit-message')
    click_button "Modify commit message"
    expect(textbox).to be_visible
    expect(textbox.value).to eq(default_message)

    click_link "Include description in commit message"

    expect(textbox.value).to eq(message_with_description)

    click_link "Don't include description in commit message"

    expect(textbox.value).to eq(default_message)
  end
end
