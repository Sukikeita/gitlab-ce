require 'rails_helper'

feature 'Merge request > User creates MR from forked project' do
  it_behaves_like 'a creatable merge request' do
    given(:source_project) { create(:project, :repository, forked_from_project: target_project) }
  end
end
