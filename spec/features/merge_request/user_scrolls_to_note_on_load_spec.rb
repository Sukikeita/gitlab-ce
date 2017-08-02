require 'rails_helper'

feature 'Merge request > User scrolls to note on load', :js do
  given(:project) { create(:project, :public, :repository) }
  given(:user) { project.creator }
  given(:merge_request) { create(:merge_request, source_project: project, author: user) }
  given(:note) { create(:diff_note_on_merge_request, noteable: merge_request, project: project) }
  given(:fragment_id) { "#note_#{note.id}" }

  background do
    sign_in(user)
    page.current_window.resize_to(1000, 300)
    visit "#{project_merge_request_path(project, merge_request)}#{fragment_id}"
  end

  scenario 'scrolls down to fragment' do
    page_height = page.current_window.size[1]
    page_scroll_y = page.evaluate_script("window.scrollY")
    fragment_position_top = page.evaluate_script("Math.round($('#{fragment_id}').offset().top)")

    expect(find('.js-toggle-content').visible?).to eq true
    expect(find(fragment_id).visible?).to eq true
    expect(fragment_position_top).to be >= page_scroll_y
    expect(fragment_position_top).to be < (page_scroll_y + page_height)
  end
end
