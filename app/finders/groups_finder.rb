class GroupsFinder < UnionFinder
  def initialize(current_user = nil, params = {})
    @current_user = current_user
    @params = params
  end

  def execute
    groups = find_union(all_groups, Group).with_route.order_id_desc
    by_parent(groups)
  end

  private

  attr_reader :current_user, :params

  def all_groups
    groups = []

    if current_user
      groups_for_ancestors = find_union([current_user.authorized_groups, authorized_project_groups], Group)
      groups_for_descendants = current_user.authorized_groups
      groups << Gitlab::GroupHierarchy.new(groups_for_ancestors, groups_for_descendants).all_groups
    end
    groups << Group.unscoped.public_to_user(current_user)

    groups
  end

  def by_parent(groups)
    return groups unless params[:parent]

    groups.where(parent: params[:parent])
  end

  def authorized_project_groups
    return Group.none unless current_user

    Group.where(id: current_user.authorized_projects.select(:namespace_id))
  end
end
