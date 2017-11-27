require "pry-byebug"

module QA
  module Scenario
    module Gitlab
      module Project
        module Repository
          class PushFile < Scenario::Template
            attr_writer :file_name,
                        :file_content,
                        :commit_message,
                        :branch_name

            def initialize
              @file_name = 'file.txt'
              @file_content = '# This is test project'
              @commit_message = 'ADD #{file_name}'
            end

            def attrs
              { file_name: @file_name, branch_name: @branch_name, file_content: @file_content, commit_message: @commit_message }
            end

            def perform
              Git::Repository.perform do |repository|
                repository.location = Page::Project::Show.act do
                  choose_repository_clone_http
                  repository_location
                end

                repository.use_default_credentials

                repository.act(attrs) do |attrs|
                  clone
                  configure_identity('GitLab QA', 'root@gitlab.com')
                  add_file(attrs[:file_name], attrs[:file_content])
                  commit(attrs[:commit_message])
                  push_changes(attrs[:branch_name])
                end
              end
            end
          end
        end
      end
    end
  end
end
