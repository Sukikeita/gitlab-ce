class MergeRequestStatisticsEntity < Grape::Entity
  expose :closed_at
  expose :merged_at
  expose :closed_by, using: UserEntity
  expose :merged_by, using: UserEntity
end
