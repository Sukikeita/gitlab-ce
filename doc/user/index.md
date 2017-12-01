# User documentation--用户使用文档

Welcome to GitLab! We're glad to have you here!

欢迎来到GitLab！ 我们很高兴有你在这里！

As a GitLab user you'll have access to all the features
your [subscription](https://about.gitlab.com/products/)
includes, except [GitLab administrator](../README.md#administrator-documentation)
settings, unless you have admin privileges to install, configure,
and upgrade your GitLab instance.

作为一名GitLab用户，你可以访问所有您订阅的功能，除了管理员的配置。除非您有管理员权限安装、配置和升级GitLab版本。

For GitLab.com, admin privileges are restricted to the GitLab team.

对于GitLab.com，管理员权限仅限于GitLab团队。

If you run your own GitLab instance and are looking for the administration settings,
please refer to the [administration](../README.md#administrator-documentation)
documentation.

如果您运行自己的GitLab实例并正在查找如何管理设置，请参阅管理文档。

## Overview--概述

GitLab is a fully integrated software development platform that enables you
and your team to work cohesively, faster, transparently, and effectively,
since the discussion of a new idea until taking that idea to production all
all the way through, from within the same platform.

GitLab是一个完全集成的软件开发平台，使您和您的团队能够紧密合作，更快速，更透明，更有效地开展工作，因为从一个新的想法开始讨论，直到把它实现的所有过程，都可以在平台上进行。

Please check this page for an overview on [GitLab's features](https://about.gitlab.com/features/).

请查看此页面以获取关于GitLab功能的概述。

## Use cases--用户场景

GitLab is a git-based platforms that integrates a great number of essential tools for software development and deployment, and project management:

GitLab是一个基于git的平台，它集成了许多用于软件开发和部署以及项目管理的基本工具：

- Code hosting in repositories with version control 代码托管在版本控制的仓库
- Track proposals for new implementations, bug reports, and feedback with a
fully featured [Issue Tracker](project/issues/index.md#issue-tracker) 使用全能的问题跟踪器跟踪新实现的建议、bug报告和反馈（Issues板）；
- Organize and prioritize with [Issue Boards](project/issues/index.md#issue-boards) 组织Issues板并确定问题解决的优先顺序；
- Code review in [Merge Requests](project/merge_requests/index.md) with live-preview changes per
branch with [Review Apps](../ci/review_apps/index.md)合并请求中进行代码审查，“Review Apps”的实时预览每个分支中的更改；
- Build, test and deploy with built-in [Continuous Integration](../ci/README.md) 使用内置的CI进行构建、测试、部署；
- Deploy your personal and professional static websites with [GitLab Pages](project/pages/index.md) 使用GitLab Pages部署您的个人和专业静态网站
- Integrate with Docker with [GitLab Container Registry](project/container_registry.md) 与Docker一起集成GitLab容器注册表
- Track the development lifecycle with [GitLab Cycle Analytics](project/cycle_analytics.md) 使用GitLab Cycle Analytics跟踪开发生命周期

With GitLab Enterprise Edition, you can also: 
GitLab EE版还支持以下额外功能

- Provide support with [Service Desk](https://docs.gitlab.com/ee/user/project/service_desk.html)
- Improve collaboration with
[Merge Request Approvals](https://docs.gitlab.com/ee/user/project/merge_requests/index.html#merge-request-approvals),
[Multiple Assignees for Issues](https://docs.gitlab.com/ee/user/project/issues/multiple_assignees_for_issues.html),
and [Multiple Issue Boards](https://docs.gitlab.com/ee/user/project/issue_board.html#multiple-issue-boards)
- Create formal relashionships between issues with [Related Issues](https://docs.gitlab.com/ee/user/project/issues/related_issues.html)
- Use [Burndown Charts](https://docs.gitlab.com/ee/user/project/milestones/burndown_charts.html) to track progress during a sprint or while working on a new version of their software.
- Leverage [Elasticsearch](https://docs.gitlab.com/ee/integration/elasticsearch.html) with [Advanced Global Search](https://docs.gitlab.com/ee/user/search/advanced_global_search.html) and [Advanced Syntax Search](https://docs.gitlab.com/ee/user/search/advanced_search_syntax.html) for faster, more advanced code search across your entire GitLab instance
- [Authenticate users with Kerberos](https://docs.gitlab.com/ee/integration/kerberos.html)
- [Mirror a repository](https://docs.gitlab.com/ee/workflow/repository_mirroring.html) from elsewhere on your local server.
- [Export issues as CSV](https://docs.gitlab.com/ee/user/project/issues/csv_export.html)
- View your entire CI/CD pipeline involving more than one project with [Multiple-Project Pipeline Graphs](https://docs.gitlab.com/ee/ci/multi_project_pipeline_graphs.html)
- [Lock files](https://docs.gitlab.com/ee/user/project/file_lock.html) to prevent conflicts
- View of the current health and status of each CI environment running on Kubernetes with [Deploy Boards](https://docs.gitlab.com/ee/user/project/deploy_boards.html)
- Leverage your continuous delivery method with [Canary Deployments](https://docs.gitlab.com/ee/user/project/canary_deployments.html)

You can also [integrate](project/integrations/project_services.md) GitLab with numerous third-party applications, such as Mattermost, Microsoft Teams, HipChat, Trello, Slack, Bamboo CI, JIRA, and a lot more.

您还可以将GitLab与许多第三方应用程序（如Mattermost，Microsoft Teams，HipChat，Trello，Slack，Bamboo CI，JIRA等）集成在一起。

### Articles--文章

For a complete workflow use case please check [GitLab Workflow, an Overview](https://about.gitlab.com/2016/10/25/gitlab-workflow-an-overview/#gitlab-workflow-use-case-scenario).

有关完整的工作流程用例，请查看GitLab工作流程，概述。

For more use cases please check our [Technical Articles](../articles/index.md).

如需更多使用案例，请查看我们的技术文章。

## Projects--项目

In GitLab, you can create [projects](project/index.md) for numerous reasons, such as, host
your code, use it as an issue tracker, collaborate on code, and continuously
build, test, and deploy your app with built-in GitLab CI/CD. Or, you can do
it all at once, from one single project.

在GitLab中，您可以创建项目的原因很多，例如托管代码，将其用作问题跟踪器，协作代码以及使用内置的GitLab CI/CD不断构建，测试和部署应用程序。 或者，你可以从一个单一的项目一次完成。

- [Repositories](project/repository/index.md): Host your codebase in
repositories with version control and as part of a fully integrated platform.存储库：使用版本控制将代码库托管在知识库中，并作为完全集成的平台的一部分。
- [Issues](project/issues/index.md): Explore the best of GitLab Issues' features.Is
sues板：探索GitLab问题的最佳功能。
- [Merge Requests](project/merge_requests/index.md): Collaborate on code,
reviews, live preview changes per branch, and request approvals with Merge Requests. 合并请求：在代码上进行协作，评论，每个分支的实时预览更改以及使用合并请求请求批准。
- [Milestones](project/milestones/index.md): Work on multiple issues and merge
requests towards the same target date with Milestones. 里程碑，处理多个问题并将合并请求合并到与里程碑相同的目标日期。


## GitLab CI/CD

Use built-in [GitLab CI/CD](../ci/README.md) to test, build, and deploy your applications
directly from GitLab. No third-party integrations needed.

使用内置的GitLab CI/CD来直接从GitLab测试，构建和部署应用程序。 无需第三方集成。

- [GitLab Auto Deploy](../ci/autodeploy/index.md): Deploy your application out-of-the-box with GitLab Auto Deploy.使用GitLab Auto Deploy开箱即用地部署您的应用程序。
- [Review Apps](../ci/review_apps/index.md): Live-preview the changes introduced by a merge request with Review Apps.使用“查看应用程序”实时预览合并请求引入的更改。
- [GitLab Pages](project/pages/index.md): Publish your static site directly from
GitLab with Gitlab Pages. You can build, test, and deploy any Static Site Generator with Pages.用Gitlab Pages直接从GitLab发布你的静态网站。 您可以使用Pages构建，测试和部署任何静态网站生成器。
- [GitLab Container Registry](project/container_registry.md): Build and deploy Docker
images with Container Registry.使用Container Registry构建和部署Docker镜像。

## Account--账户

There is a lot you can customize and configure
to enjoy the best of GitLab.

有很多你可以定制和配置，以享受最好的GitLab。

- [Settings](profile/index.md): Manage your user settings to change your personal info,
personal access tokens, authorized applications, etc.管理您的用户设置，以更改您的个人信息，个人访问令牌，授权应用程序等。
- [Authentication](../topics/authentication/index.md): Read through the authentication
methods available in GitLab.通读GitLab中提供的认证方法。
- [Permissions](permissions.md): Learn the different set of permissions levels for each
user type (guest, reporter, developer, master, owner).权限：了解每种用户类型（访客，记者，开发者，主人，所有者）的不同权限级别。

## Groups

With GitLab [Groups](group/index.md) you can assemble related projects together
and grant members access to several projects at once.

借助GitLab组功能，您可以将相关项目组合在一起，并允许成员同时访问多个项目。

Groups can also be nested in [subgroups](group/subgroups/index.md).

组也可以嵌套在子组中。

## Discussions 讨论

In GitLab, you can comment and mention collaborators in issues,
merge requests, code snippets, and commits.

在GitLab中，您可以在问题，合并请求，代码片段中提交评论和提到合作者的。

When performing inline reviews to implementations
to your codebase through merge requests you can
gather feedback through [resolvable discussions](discussions/index.md#resolvable-discussions).

当通过合并请求对代码库的执行内联评审时，您可以通过待解析的讨论来收集反馈。

### GitLab Flavored Markdown (GFM)

Read through the [GFM documentation](markdown.md) to learn how to apply
the best of GitLab Flavored Markdown in your discussions, comments,
issues and merge requests descriptions, and everywhere else GMF is
supported.

阅读GFM文档，了解如何在您的讨论，评论，问题和合并请求描述中应用GitLab Flavored Markdown的最佳功能，以及其他地方支持GMF。

## Todos 代办事项

Never forget to reply to your collaborators. [GitLab Todos](../workflow/todos.md)
are a tool for working faster and more effectively with your team,
by listing all user or group mentions, as well as issues and merge
requests you're assigned to.

永远不要忘记回复你的合作者。 GitLab Todos是通过列出所有用户或群组提及以及分配给您的问题和合并请求，从而更快，更有效地与您的团队合作的工具。

## Search 搜索

[Search and filter](search/index.md) through groups, projects, issues, merge requests, files, code, and more.

通过组，项目，问题，合并请求，文件，代码等进行搜索和过滤。

## Snippets

[Snippets](snippets.md) are code blocks that you want to store in GitLab, from which
you have quick access to. You can also gather feedback on them through
[discussions](#discussions).

Snippets是您想要存储在GitLab中的代码块，您可以从中快速访问。 您也可以通过讨论收集他们的反馈意见。

## Integrations

[Integrate GitLab](../integration/README.md) with your preferred tool,
such as Trello, JIRA, etc.

将GitLab与您的首选工具（如Trello，JIRA等）集成。

## Webhooks 

Configure [webhooks](project/integrations/webhooks.html) to listen for
specific events like pushes, issues or merge requests. GitLab will send a
POST request with data to the webhook URL.

配置webhooks来监听特定的事件，如推送，issue或合并请求。 GitLab将发送带有数据的POST请求到webhook URL。

## API

Automate GitLab via [API](../api/README.html).通过API文档自动化GitLab。

## Git and GitLab

Learn what is [Git](../topics/git/index.md) and its best practices.学习Git和它的最佳实践。
