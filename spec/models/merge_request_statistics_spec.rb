require 'rails_helper'

describe MergeRequestStatistics do
  set(:merge_request) { create(:merge_request) }
  subject { merge_request.statistics }

  describe 'associations' do
    it { is_expected.to belong_to(:merge_request) }
    it { is_expected.to belong_to(:closed_by).class_name('User') }
    it { is_expected.to belong_to(:merged_by).class_name('User') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:merge_request) }
    it { is_expected.to validate_uniqueness_of(:merge_request) }
  end
end
