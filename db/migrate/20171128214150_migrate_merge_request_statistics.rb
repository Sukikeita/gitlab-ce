class MigrateMergeRequestStatistics < ActiveRecord::Migration
  DOWNTIME = false

  def up
    execute "INSERT INTO merge_request_statistics (merge_request_id) SELECT id as merge_request_id FROM merge_requests"

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      # Updates closed_at and closed_by_id columns according to existing "CLOSED" events.
      execute <<-SQL.strip_heredoc
        UPDATE merge_request_statistics ms SET (closed_at, closed_by_id) = (mrs.closed_at, mrs.closed_by_id) FROM
          (SELECT DISTINCT ON (merge_request_id) * FROM (
            SELECT target_id as merge_request_id, author_id AS closed_by_id, updated_at as closed_at
            FROM events
            WHERE action = 3 AND target_type = 'MergeRequest'
            ORDER BY events.id DESC) AS foo) AS mrs
          WHERE mrs.merge_request_id = ms.merge_request_id
      SQL

      # Updates merged_at and merged_by_id columns according to existing "MERGED" events.
      execute <<-SQL.strip_heredoc
        UPDATE merge_request_statistics ms SET (merged_at, merged_by_id) = (mrs.merged_at, mrs.merged_by_id) FROM
          (SELECT DISTINCT ON (merge_request_id) * FROM (
            SELECT target_id as merge_request_id, author_id AS merged_by_id, updated_at as merged_at
            FROM events
            WHERE action = 7 AND target_type = 'MergeRequest'
            ORDER BY events.id DESC) AS foo) AS mrs
          WHERE mrs.merge_request_id = ms.merge_request_id;
      SQL
    else
      # TODO implement MySQL version
    end
  end

  def down
    execute "delete from merge_request_statistics"
  end
end
