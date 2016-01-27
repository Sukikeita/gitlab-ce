class Spinach::Features::Groups < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedGroup
  include SharedProject
  include SharedUser

  step 'I should see back to dashboard button' do
    expect(page).to have_content 'Go to dashboard'
  end

  step 'I should see group "Owned"' do
    expect(page).to have_content '@owned'
  end

  step 'I should see "All"' do
    expect(page).to have_link "All"
  end

  step 'I should see "Contributed"' do
    expect(page).to have_link "Contributed"
  end

  step 'I should see "Starred"' do
    expect(page).to have_link "Starred"
  end

  step 'I am a signed out user' do
    logout
  end

  step 'Group "Owned" has a public project "Public-project"' do
    group = owned_group

    @project = Project.find_by(name: "Public-project") || create(:empty_project, :public,
                 group: group,
                 name: "Public-project")
  end

  step 'Group "Owned" has a public project "Star-project" with 2 stars including 1 from "John Doe"' do
    group = owned_group

    @project = Project.find_by(name: 'Star-project') || create(:project, :public,
                 group: group,
                 name: 'Star-project',
                 path: 'star_project')
    user_exists('John Doe').toggle_star(@project)
    user_exists('Mary Jane').toggle_star(@project)
  end

  step 'Group "Owned" has an internal project "Moon-project" with 1 star from "John Doe"' do
    group = owned_group

    @project = Project.find_by(name: 'Moon-project') || create(:project, :internal,
                 group: group,
                 name: 'Moon-project',
                 path: 'moon_project')
    user_exists('John Doe').toggle_star(@project)
  end

  step 'project "Moon-project" has push event' do
    event_for_project(Project.find_by(name: "Moon-project"), user_exists('John Doe'))
  end

  step 'I should see project "Public-project"' do
    expect(page).to have_content 'Public-project'
  end

  step 'I should see group "Owned" projects list' do
    owned_group.projects.each do |project|
      expect(page).to have_link project.name
    end
  end

  step 'I should see projects activity feed' do
    expect(page).to have_content 'closed issue'
  end

  step 'I should see issues from group "Owned" assigned to me' do
    assigned_to_me(:issues).each do |issue|
      expect(page).to have_content issue.title
    end
  end

  step 'I should see merge requests from group "Owned" assigned to me' do
    assigned_to_me(:merge_requests).each do |issue|
      expect(page).to have_content issue.title[0..80]
    end
  end

  step 'project from group "Owned" has issues assigned to me' do
    create :issue,
      project: project,
      assignee: current_user,
      author: current_user
  end

  step 'project from group "Owned" has merge requests assigned to me' do
    create :merge_request,
      source_project: project,
      target_project: project,
      assignee: current_user,
      author: current_user
  end

  step 'I change group "Owned" name to "new-name"' do
    fill_in 'group_name', with: 'new-name'
    fill_in 'group_path', with: 'new-name'
    click_button "Save group"
  end

  step 'I should see new group "Owned" name' do
    page.within ".navbar-gitlab" do
      expect(page).to have_content "new-name"
    end
  end

  step 'I change group "Owned" avatar' do
    attach_file(:group_avatar, File.join(Rails.root, 'spec', 'fixtures', 'banana_sample.gif'))
    click_button "Save group"
    owned_group.reload
  end

  step 'I should see new group "Owned" avatar' do
    expect(owned_group.avatar).to be_instance_of AvatarUploader
    expect(owned_group.avatar.url).to eq "/uploads/group/avatar/#{Group.find_by(name:"Owned").id}/banana_sample.gif"
  end

  step 'I should see the "Remove avatar" button' do
    expect(page).to have_link("Remove avatar")
  end

  step 'I have group "Owned" avatar' do
    attach_file(:group_avatar, File.join(Rails.root, 'spec', 'fixtures', 'banana_sample.gif'))
    click_button "Save group"
    owned_group.reload
  end

  step 'I remove group "Owned" avatar' do
    click_link "Remove avatar"
    owned_group.reload
  end

  step 'I should not see group "Owned" avatar' do
    expect(owned_group.avatar?).to eq false
  end

  step 'I should not see the "Remove avatar" button' do
    expect(page).not_to have_link("Remove avatar")
  end

  step 'Group "Owned" has archived project' do
    group = Group.find_by(name: 'Owned')
    create(:project, namespace: group, archived: true, path: "archived-project")
  end

  step 'I should see "archived" label' do
    expect(page).to have_xpath("//span[@class='label label-warning']", text: 'archived')
  end

  # ----------------------------------------
  # Sorting
  # ----------------------------------------

  step 'I should see "Star-project" at the top' do
    expect_top_project_in_list("Star-project")
  end

  step 'I should see "Moon-project" at the top' do
    expect_top_project_in_list("Moon-project")
  end

  step 'I should see a nav block' do
    expect(page).to have_selector(:css, '.nav-block')
  end

  step 'I should not see a nav block' do
    expect(page).not_to have_selector(:css, '.nav-block')
  end

  private

  def assigned_to_me(key)
    project.send(key).where(assignee_id: current_user.id)
  end

  def project
    owned_group.projects.first
  end
end
