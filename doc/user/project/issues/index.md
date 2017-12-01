# Issues

The GitLab Issue Tracker is an advanced and complete tool
for tracking the evolution of a new idea or the process
of solving a problem.

GitLab问题跟踪器是一个先进的和完整的工具，用于跟踪新想法的演变或解决问题的过程。

It allows you, your team, and your collaborators to share
and discuss proposals before and while implementing them.

它允许您，您的团队和您的合作者在实施前分享和讨论提案。

GitLab Issues and the GitLab Issue Tracker are available in all
[GitLab Products](https://about.gitlab.com/products/) as
part of the [GitLab Workflow](https://about.gitlab.com/2016/10/25/gitlab-workflow-an-overview/).

作为GitLab工作流程的一部分，所有GitLab产品都提供GitLab问题和GitLab问题跟踪器。

## Use cases--用户场景

Issues can have endless applications. Just to exemplify, these are
some cases for which creating issues are most used:

Issues可能有无尽的应用。 为了举例说明，这些是创建问题最常用的一些情况：

- Discussing the implementation of a new idea 讨论一个新的想法的实现
- Submitting feature proposals 提交功能提议
- Asking questions 提问
- Reporting bugs and malfunction 报告错误和故障
- Obtaining support 获得支持
- Elaborating new code implementations 阐述新的代码实现


See also the blog post "[Always start a discussion with an issue](https://about.gitlab.com/2016/03/03/start-with-an-issue/)".

另见博客文章“总是从开始讨论一个问题”。

### Keep private things private 保持个人的私密性

For instance, let's assume you have a public project but want to start a discussion on something
you don't want to be public. With [Confidential Issues](#confidential-issues),
you can discuss private matters among the project members, and still keep
your project public, open to collaboration.

例如，假设你有一个公共项目，但是想要开始讨论一些你不想公开的事情。 通过保密问题（Confidential Issues），您可以在项目成员之间讨论私人事务，并且仍然公开您的项目，对同事开放。

### Streamline collaboration 简化协作

With [Multiple Assignees for Issues](https://docs.gitlab.com/ee/user/project/issues/multiple_assignees_for_issues.html),
available in [GitLab Enterprise Edition Starter](https://about.gitlab.com/gitlab-ee/)
you can streamline collaboration and allow shared responsibilities to be clearly displayed.
All assignees are shown across your workflows and receive notifications (as they
would as single assignees), simplifying communication and ownership.

通过GitLab Enterprise Edition Starter中的多个Assignees for Issues，您可以简化协作，并可以清楚显示共享责任。 所有受托人都显示在您的工作流程中，并接收通知（如同单个受托人一样），从而简化沟通和所有权。

### Consistent collaboration 一致的协作

Create [issue templates](#issue-templates) to make collaboration consistent and
containing all information you need. For example, you can create a template
for feature proposals and another one for bug reports.

创建问题模板，使协作保持一致并包含您所需的所有信息。 例如，您可以为功能需求创建一个模板，为错误报告创建另一个模板。

## Issue Tracker--问题跟踪

The Issue Tracker is the collection of opened and closed issues created in a project.
It is available for all projects, from the moment the project is created.

问题跟踪器是在项目中创建的已打开和已关闭问题的集合。 从项目创建的那一刻起，它就可用于所有项目。

Find the issue tracker by navigating to your **Project's homepage** > **Issues**.

通过导航 **Project's homepage** > **Issues** 找到问题跟踪器。

### Issues per project--项目的Issues

When you access your project's issues, GitLab will present them in a list,
and you can use the tabs available to quickly filter by open and closed issues.

当你访问你的项目问题时，GitLab将把它们显示在一个列表中，你可以使用可用的标签快速地过滤开放和封闭的问题。

![Project issues list view](img/project_issues_list_view.png)

You can also [search and filter](../../search/index.md#issues-and-merge-requests-per-project) the results more deeply with GitLab's search capacities.

您还可以使用GitLab的搜索功能更深入地搜索和过滤结果。

### Issues per group --组的Issues

View all the issues in a group (that is, all the issues across all projects in that
group) by navigating to **Group > Issues**. This view also has the open and closed
issue tabs.

通过导航到**Group > Issues**查看组中的所有问题（即，该组中所有项目的所有问题）。 这个视图也有开放和封闭的问题标签。

![Group Issues list view](img/group_issues_list_view.png)

## GitLab Issues Functionalities

The image bellow illustrates how an issue looks like:
下面的图片展示了Issue的样子：

![Issue view](img/issues_main_view.png)

Learn more about it on the [GitLab Issues Functionalities documentation](issues_functionalities.md).

在GitLab问题功能文档上了解更多信息。

## New issue--创建issue

Read through the [documentation on creating issues](create_new_issue.md).

阅读有关创建issue的文档。

## Closing issues--关闭issues

Learn distinct ways to [close issues](closing_issues.md) in GitLab.

学习不同的方法来关闭GitLab中的issue。

## Moving issues

Read through the [documentation on moving issues](moving_issues.md).

阅读有关移动issue的文档。

## Deleting issues--关闭issues

Read through the [documentation on deleting issues](deleting_issues.md)

阅读有关删除issues的文档

## Create a merge request from an issue--从issue中创建合并请求

Learn more about it on the [GitLab Issues Functionalities documentation](issues_functionalities.md#18-new-merge-request).

在GitLab问题功能文档上了解更多信息。

## Search for an issue--搜索issue

Learn how to [find an issue](../../search/index.md) by searching for and filtering them.

了解如何通过搜索和过滤来查找issue。

## Advanced features--高级功能

### Confidential Issues--保密问题

Whenever you want to keep the discussion presented in a
issue within your team only, you can make that
[issue confidential](confidential_issues.md). Even if your project
is public, that issue will be preserved. The browser will
respond with a 404 error whenever someone who is not a project
member with at least [Reporter level](../../permissions.md#project) tries to
access that issue's URL.

无论何时只要您的团队内部只对问题进行讨论，您都可以将该问题保密。 即使你的项目是公开的，这个问题也会被保留下来。 如果某个不是具有至少Reporter级别的项目成员的人尝试访问该issue的URL，浏览器将以404错误进行响应。

Learn more about them on the [confidential issues documentation](confidential_issues.md).

在保密issue文档中了解更多信息。

### Issue templates--issue模板

Create templates for every new issue. They will be available from
the dropdown menu **Choose a template** when you create a new issue:

为每个新问题创建模板。 他们将从下拉菜单中可用创建新问题时选择一个模板：

![issue template](img/issue_template.png)

Learn more about them on the [issue templates documentation](../../project/description_templates.md#creating-issue-templates).

在问题模板文档中了解更多信息。

### Crosslinking issues--交联问题

Learn more about [crosslinking](crosslinking_issues.md) issues and merge requests.

详细了解交联问题和合并请求。

### Issue Board

The [GitLab Issue Board](https://about.gitlab.com/features/issueboard/) is a way to
enhance your workflow by organizing and prioritizing issues in GitLab.

GitLab Issue板是一种通过组织GitLab中的问题并优化问题解决优先级来增强工作流程的方法。

![Issue board](img/issue_board.png)

Find GitLab Issue Boards by navigating to your **Project's Dashboard** > **Issues** > **Board**.

通过导航到项目的**Project's Dashboard** > **Issues** > **Board**来查找GitLab Issue Boards。

Read through the documentation for [Issue Boards](../issue_board.md)
to find out more about this feature.

阅读以[Issue Boards](../issue_board.md)了解更多关于此功能。

With [GitLab Enterprise Edition Starter](https://about.gitlab.com/gitlab-ee/), you can also
create various boards per project with [Multiple Issue Boards](https://docs.gitlab.com/ee/user/project/issue_board.html#multiple-issue-boards).

使用GitLab Enterprise Edition Starter，您还可以使用多个[Multiple Issue Boards] 为每个项目创建不同的板。

### External Issue Tracker--使用外部的问题跟踪器

Alternatively to GitLab's built-in Issue Tracker, you can also use an [external
tracker](../../../integration/external-issue-tracker.md) such as Jira, Redmine,
or Bugzilla.

除了GitLab内置的问题跟踪器外，您还可以使用Jira，Redmine或Bugzilla等外部跟踪器。

### Issue's API--

Read through the [API documentation](../../../api/issues.md).
通读API文档。
