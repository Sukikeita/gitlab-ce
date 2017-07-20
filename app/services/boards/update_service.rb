module Boards
  class UpdateService < BaseService
    def execute(board)
      params.delete(:milestone_id) unless project.feature_available?(:issue_board_milestone)

      board.update(params)
    end
  end
end