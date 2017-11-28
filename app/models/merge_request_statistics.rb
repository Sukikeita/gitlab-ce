class MergeRequestStatistics < ActiveRecord::Base
  belongs_to :merge_request
  belongs_to :closed_by, class_name: 'User'
  belongs_to :merged_by, class_name: 'User'

  validates :merge_request, presence: true, uniqueness: true
end
