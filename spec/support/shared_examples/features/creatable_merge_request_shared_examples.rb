RSpec.shared_examples 'a creatable merge request' do
  # Can be overriden
  let(:source_project) { target_project }

  let(:target_project) { create(:project, :public, :repository) }
  let(:user) { source_project.owner }
  let(:user2) { target_project.owner }
  let!(:milestone) { create(:milestone, project: target_project) }
  let!(:label) { create(:label, project: target_project) }
  let!(:label2) { create(:label, project: target_project) }

  before do
    target_project.add_master(user)

    sign_in(user)
    visit project_new_merge_request_path(
      target_project,
      merge_request: {
        source_project_id: source_project.id,
        target_project_id: target_project.id,
        source_branch: 'fix',
        target_branch: 'master'
      })
  end

  it 'creates new merge request', :js do
    click_button 'Assignee'
    page.within '.dropdown-menu-user' do
      click_link user2.name
    end
    expect(find('input[name="merge_request[assignee_id]"]', visible: false).value).to match(user2.id.to_s)
    page.within '.js-assignee-search' do
      expect(page).to have_content user2.name
    end

    find('a', text: 'Assign to me').trigger('click')
    expect(find('input[name="merge_request[assignee_id]"]', visible: false).value).to match(user.id.to_s)
    page.within '.js-assignee-search' do
      expect(page).to have_content user.name
    end

    click_button 'Milestone'
    page.within '.issue-milestone' do
      click_link milestone.title
    end
    expect(find('input[name="merge_request[milestone_id]"]', visible: false).value).to match(milestone.id.to_s)
    page.within '.js-milestone-select' do
      expect(page).to have_content milestone.title
    end

    click_button 'Labels'
    page.within '.dropdown-menu-labels' do
      click_link label.title
      click_link label2.title
    end
    page.within '.js-label-select' do
      expect(page).to have_content label.title
    end
    expect(page.all('input[name="merge_request[label_ids][]"]', visible: false)[1].value).to match(label.id.to_s)
    expect(page.all('input[name="merge_request[label_ids][]"]', visible: false)[2].value).to match(label2.id.to_s)

    click_button 'Submit merge request'

    page.within '.issuable-sidebar' do
      page.within '.assignee' do
        expect(page).to have_content user.name
      end

      page.within '.milestone' do
        expect(page).to have_content milestone.title
      end

      page.within '.labels' do
        expect(page).to have_content label.title
        expect(page).to have_content label2.title
      end
    end
  end
end
