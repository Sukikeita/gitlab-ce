class CreateBranchService < BaseService
  include ActionView::Helpers::SanitizeHelper

  def execute(branch_name, ref, issue = nil)
    create_master_branch if project.empty_repo?

    sanitized_branch_name = sanitize_branch_name_for(branch_name)

    result = ValidateNewBranchService.new(project, current_user)
      .execute(sanitized_branch_name)

    return result if result[:status] == :error

    new_branch = repository.add_branch(current_user, sanitized_branch_name, ref)

    if new_branch
      SystemNoteService.new_issue_branch(issue, project, current_user, sanitized_branch_name) if issue
      success(new_branch)
    else
      error('Invalid reference name')
    end
  rescue Gitlab::Git::HooksService::PreReceiveError => ex
    error(ex.message)
  end

  def success(branch)
    super().merge(branch: branch)
  end

  private

  def create_master_branch
    project.repository.create_file(
      current_user,
      '/README.md',
      '',
      message: 'Add README.md',
      branch_name: 'master'
    )
  end

  def sanitize_branch_name_for(branch_name)
    Addressable::URI.unescape(sanitize(strip_tags(branch_name)))
  end
end
