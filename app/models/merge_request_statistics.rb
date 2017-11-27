class MergeRequestStatistics < ActiveRecord::Base
  belongs_to :merge_request

  validates :merge_request, presence: true, uniqueness: true
end
