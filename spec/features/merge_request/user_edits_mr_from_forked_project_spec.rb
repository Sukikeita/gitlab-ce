require 'rails_helper'

describe 'Merge request > User edits MR from forked project' do
  it_behaves_like 'an editable merge request' do
    let(:source_project) { create(:project, :repository, forked_from_project: target_project) }
  end
end
