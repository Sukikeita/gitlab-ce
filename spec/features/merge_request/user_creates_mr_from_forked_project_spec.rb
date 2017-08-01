require 'rails_helper'

describe 'Merge request > User creates MR from forked project', :js do
  it_behaves_like 'a creatable merge request' do
    let(:source_project) { create(:project, :repository, forked_from_project: target_project) }
  end
end
