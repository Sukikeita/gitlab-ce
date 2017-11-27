class CreateMergeRequestStatistics < ActiveRecord::Migration
  DOWNTIME = false

  def change
    create_table :merge_request_statistics do |t|
      t.references :merge_request, null: false, index: { unique: true }, foreign_key: { on_delete: :cascade }
      t.integer :merged_by_id
      t.datetime :merged_at
      t.integer :closed_by_id
      t.datetime :closed_at
    end
  end
end
