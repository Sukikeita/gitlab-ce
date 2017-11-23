# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class UpdateCircuitbreakerDefaults < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  class MigrationApplicationSetting < ActiveRecord::Base
    self.table_name = 'application_settings'
  end

  def up
    change_column_default :application_settings,
                          :circuitbreaker_failure_count_threshold,
                          3
    change_column_default :application_settings,
                          :circuitbreaker_storage_timeout,
                          15

    MigrationApplicationSetting
      .update_all(circuitbreaker_failure_count_threshold: 3,
                  circuitbreaker_storage_timeout: 15)
  end

  def down
    change_column_default :application_settings,
                          :circuitbreaker_failure_count_threshold,
                          160
    change_column_default :application_settings,
                          :circuitbreaker_storage_timeout,
                          30

    MigrationApplicationSetting
      .update_all(circuitbreaker_failure_count_threshold: 160,
                  circuitbreaker_storage_timeout: 30)
  end

end
