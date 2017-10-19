# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class FixDevTimezoneSchema < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  # Set this constant to true if this migration requires downtime.
  DOWNTIME = false

  # When a migration requires downtime you **must** uncomment the following
  # constant and define a short and easy to understand explanation as to why the
  # migration requires downtime.
  # DOWNTIME_REASON = ''

  # When using the methods "add_concurrent_index", "remove_concurrent_index" or
  # "add_column_with_default" you must disable the use of transactions
  # as these methods can not run in an existing transaction.
  # When using "add_concurrent_index" or "remove_concurrent_index" methods make sure
  # that either of them is the _only_ method called in the migration,
  # any other changes should go in a separate migration.
  # This ensures that upon failure _only_ the index creation or removing fails
  # and can be retried or reverted easily.
  #
  # To disable transactions uncomment the following line and remove these
  # comments:
  # disable_ddl_transaction!

  TIMEZONE_TABLES = %i(appearances ci_group_variables ci_pipeline_schedule_variables events gpg_keys gpg_signatures project_auto_devops)

  def up
    return unless Rails.env.development? || Rails.env.test?

    TIMEZONE_TABLES.each do |table|
      change_column table, :created_at, :datetime_with_timezone
      change_column table, :updated_at, :datetime_with_timezone
    end
  end

  def down
  end
end
