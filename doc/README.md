---
toc: false
comments: false
---

# GitLab Documentation

Welcome to [GitLab](https://about.gitlab.com/), a Git-based fully featured
platform for software development!

GitLab offers the most scalable Git-based fully integrated platform for software development, with flexible products and subscription plans:

- **GitLab Community Edition (CE)** is an [opensource product](https://gitlab.com/gitlab-org/gitlab-ce/),
self-hosted, free to use. Every feature available in GitLab CE is also available on GitLab Enterprise Edition (Starter and Premium) and GitLab.com.
- **GitLab Enterprise Edition (EE)** is an [opencore product](https://gitlab.com/gitlab-org/gitlab-ee/),
self-hosted, fully featured solution of GitLab, available under distinct [subscriptions](https://about.gitlab.com/products/): **GitLab Enterprise Edition Starter (EES)** and **GitLab Enterprise Edition Premium (EEP)**.
- **GitLab.com**: SaaS GitLab solution, with [free and paid subscriptions](https://about.gitlab.com/gitlab-com/). GitLab.com is hosted by GitLab, Inc., and administrated by GitLab (users don't have access to admin settings).

> **GitLab EE** contains all features available in **GitLab CE**,
plus premium features available in each version: **Enterprise Edition Starter**
(**EES**) and **Enterprise Edition Premium** (**EEP**). Everything available in
**EES** is also available in **EEP**.

----

Shortcuts to GitLab's most visited docs:

| [GitLab CI/CD](ci/README.md)-已翻译完 | Other |
| :----- | :----- |
| [Quick start guide](ci/quick_start/README.md)快速入门指南-已翻译完 | [API](api/README.md) |
| [Configuring `.gitlab-ci.yml`](ci/yaml/README.md)配置`.gitlab-ci.yml`-已翻译完 | [SSH authentication](ssh/README.md)SSH认证 |
| [Using Docker images](ci/docker/using_docker_images.md)使用Docker镜像 | [GitLab Pages](user/project/pages/index.md)GitLab主页 |

- [User documentation](user/index.md)用户文档
- [Administrator documentation](#administrator-documentation)管理文档
- [Technical Articles](articles/index.md)技术文章

## Getting started with GitLab --开始使用GitLab

- [GitLab Basics](gitlab-basics/README.md): Start working on your command line and on GitLab.在GitLab中使用命令行
- [GitLab Workflow](workflow/README.md): Enhance your workflow with the best of GitLab Workflow.使用GitLab工作流
    - See also [GitLab Workflow - an overview](https://about.gitlab.com/2016/10/25/gitlab-workflow-an-overview/).Gitlab工作流概述
- [GitLab Markdown](user/markdown.md): GitLab's advanced formatting system (GitLab Flavored Markdown).GitLab的高级格式化系统（GitLab Flavored Markdown）。
- [GitLab Quick Actions](user/project/quick_actions.md): Textual shortcuts for common actions on issues or merge requests that are usually done by clicking buttons or dropdowns in GitLab's UI.issues和合并请求的文本快捷方式，通常通过单击按钮或下拉在GitLab的用户界面中的常见行动。
- [Auto DevOps](topics/autodevops/index.md) DevOps

### User account 用户账户

- [User account](user/profile/index.md): Manage your account 管理账号
  - [Authentication](topics/authentication/index.md): Account security with two-factor authentication, setup your ssh keys and deploy keys for secure access to your projects.认证：两种安全的认证方式，建立你的ssh密钥和部署密钥以安全地访问您的项目
  - [Profile settings](user/profile/index.md#profile-settings): Manage your profile settings, two factor authentication and more.管理配置文件设置，两种认证或更多方式。
- [User permissions](user/permissions.md): Learn what each role in a project (external/guest/reporter/developer/master/owner) can do.用户权限：学习项目中每个角色的功能

### Projects and groups 项目和组

- [Projects](user/project/index.md):
  - [Project settings](user/project/settings/index.md) 项目设置
  - [Create a project](gitlab-basics/create-project.md) 创建项目
  - [Fork a project](gitlab-basics/fork-project.md) 复刻一个项目
  - [Importing and exporting projects between instances](user/project/settings/import_export.md). 在实例中导入或导出项目
  - [Project access](public_access/public_access.md): Setting up your project's visibility to public, internal, or private. 访问项目：设置项目的可视性（public、internal、provate）
  - [GitLab Pages](user/project/pages/index.md): Build, test, and deploy your static website with GitLab Pages.构建、测试、部署您的静态页面
- [Groups](user/group/index.md): Organize your projects in groups. 以组的方式管理项目
  - [Subgroups](user/group/subgroups/index.md) 亚群
- [Search through GitLab](user/search/index.md): Search for issues, merge requests, projects, groups, todos, and issues in Issue Boards. 使用Issue板
- [Snippets](user/snippets.md): Snippets allow you to create little bits of code. Snippet允许你创建一些代码
- [Wikis](user/project/wiki/index.md): Enhance your repository documentation with built-in wikis. 使用内置的wikes加强存储库的文档管理

### Repository--存储库

Manage your [repositories](user/project/repository/index.md) from the UI (user interface):
在UI界面管理您的存储库：

- [Files](user/project/repository/index.md#files) 文件管理
  - [Create a file](user/project/repository/web_editor.md#create-a-file) 创建一个文件
  - [Upload a file](user/project/repository/web_editor.md#upload-a-file) 上传一个文件
  - [File templates](user/project/repository/web_editor.md#template-dropdowns) 临时文件
  - [Create a directory](user/project/repository/web_editor.md#create-a-directory) 创建一个目录
  - [Start a merge request](user/project/repository/web_editor.md#tips) (when committing via UI) 发起一个合并请求
- [Branches](user/project/repository/branches/index.md) 分支管理
  - [Default branch](user/project/repository/branches/index.md#default-branch) 默认分支
  - [Create a branch](user/project/repository/web_editor.md#create-a-new-branch) 创建分支
  - [Protected branches](user/project/protected_branches.md#protected-branches) 保护分支
  - [Delete merged branches](user/project/repository/branches/index.md#delete-merged-branches) 删除已合并的分支
- [Commits](user/project/repository/index.md#commits) 提交
  - [Signing commits](user/project/repository/gpg_signed_commits/index.md): use GPG to sign your commits. 签署提交

### Issues and Merge Requests (MRs)--Issue和合并请求

- [Discussions](user/discussions/index.md): Threads, comments, and resolvable discussions in issues, commits, and  merge requests.issues、提交和合并请求中的主题、评论、可解决讨论
- [Issues](user/project/issues/index.md) Issues
- [Project issue Board](user/project/issue_board.md)项目的issue板
- [Issues and merge requests templates](user/project/description_templates.md): Create templates for submitting new issues and merge requests.创建提交新问题和合并请求的模板；
- [Labels](user/project/labels.md): Categorize your issues or merge requests based on descriptive titles.根据标题描述将issues和合并请求分录
- [Merge Requests](user/project/merge_requests/index.md) 合并请求
  - [Work In Progress Merge Requests](user/project/merge_requests/work_in_progress_merge_requests.md)工作进行中发起合并请求
  - [Merge Request discussion resolution](user/discussions/index.md#moving-a-single-discussion-to-a-new-issue): Resolve discussions, move discussions in a merge request to an issue, only allow merge requests to be merged if all discussions are resolved.合并请求讨论决议：解决讨论问题、将讨论从合并请求移到issue中，如果所有讨论已解决，则只允许合并请求
  - [Checkout merge requests locally](user/project/merge_requests/index.md#checkout-merge-requests-locally) 将合并请求检出到本地
  - [Cherry-pick](user/project/merge_requests/cherry_pick_changes.md)
- [Milestones](user/project/milestones/index.md): Organize issues and merge requests into a cohesive group, optionally setting a due date. 里程碑：组织issue和合并请求到一个有凝聚力的组中，可选地设置截止日期
- [Todos](workflow/todos.md): A chronological list of to-dos that are waiting for your input, all in a simple dashboard.等待您的输入的按时间排序的待办事项清单，全部放在简单的仪表板中。


### Git and GitLab

- [Git](topics/git/index.md): Getting started with Git, branching strategies, Git LFS, advanced use. 分支策略、Git的LFS、高级用法
- [Git cheatsheet](https://gitlab.com/gitlab-com/marketing/raw/master/design/print/git-cheatsheet/print-pdf/git-cheatsheet.pdf): Download a PDF describing the most used Git operations.下载常用的Git操作的PDF文档
- [GitLab Flow](workflow/gitlab_flow.md): explore the best of Git with the GitLab Flow strategy.探索使用最合适的工作流策略

### Migrate and import your projects from other platforms--从其他平台迁移和导入项目到Git

- [Importing to GitLab](user/project/import/index.md): Import your projects from GitHub, Bitbucket, GitLab.com, FogBugz and SVN into GitLab.从其他拼图导入您的项目到GitLab
- [Migrating from SVN](workflow/importing/migrating_from_svn.md): Convert a SVN repository to Git and GitLab.从SVN存储库迁移到Git和GitLab

### Continuous Integration, Delivery, and Deployment--持续集成、交付、和部署

- [GitLab CI](ci/README.md): Explore the features and capabilities of Continuous Integration, Continuous Delivery, and Continuous Deployment with GitLab.了解GitLab的CI、持续交付、持续部署功能和性能（已翻译）
    - [Auto Deploy](ci/autodeploy/index.md): Configure GitLab CI for the deployment of your application.（已翻译）配置CI部署应用
  - [Review Apps](ci/review_apps/index.md): Preview changes to your app right from a merge request.从合并请求中进行代码审查
- [GitLab Cycle Analytics](user/project/cycle_analytics.md): Cycle Analytics measures the time it takes to go from an [idea to production](https://about.gitlab.com/2016/08/05/continuous-integration-delivery-and-deployment-with-gitlab/#from-idea-to-production-with-gitlab) for each project you have. 分析项目的周期
- [GitLab Container Registry](user/project/container_registry.md): Learn how to use GitLab's built-in Container Registry.学习如何使用内置的注册容器

### Automation--自动化

- [API](api/README.md): Automate GitLab via a simple and powerful API. 通过简单而强大的API自动化GitLab
- [GitLab Webhooks](user/project/integrations/webhooks.md): Let GitLab notify you when new code has been pushed to your project. 让GitLab通知您，当有新的代码推送到您的项目时。（已翻译）

### Integrations--集成

- [Project Services](user/project/integrations/project_services.md): Integrate a project with external services, such as CI and chat. 使用外部服务，如CI和chat集成项目
- [GitLab Integration](integration/README.md): Integrate with multiple third-party services with GitLab to allow external issue trackers and external authentication. 使用第三方服务集成到GitLab中以使用外部的issue跟踪和外部的认证服务；
- [Trello Power-Up](integration/trello_power_up.md): Integrate with GitLab's Trello Power-Up 集成Trello Power-Up

----

## Administrator documentation--管理GitLab

Learn how to administer your GitLab instance. Regular users don't
have access to GitLab administration tools and settings.
学习如何管理您的GitLab实例。普通用户没有权限访问管理员工具和设置。


### Install, update, upgrade, migrate 安装、更新、升级、迁移

- [Install](install/README.md): Requirements, directory structures and installation from source.安装：要求、目录结构和从源码中安装
- [Mattermost](https://docs.gitlab.com/omnibus/gitlab-mattermost/): Integrate [Mattermost](https://about.mattermost.com/) with your GitLab installation.集成Mattermost到GitLab中。
- [Migrate GitLab CI to CE/EE](migrate_ci_to_ce/README.md): If you have an old GitLab installation (older than 8.0), follow this guide to migrate your existing GitLab CI data to GitLab CE/EE.如果您使用的是较早的GitLab版本，请按照本指南将现有的GitLab CI数据迁移到GitLab CE/EE。
- [Restart GitLab](administration/restart_gitlab.md): Learn how to restart GitLab and its components. 学习如何重启GitLab和组件
- [Update](update/README.md): Update guides to upgrade your installation. 升级GitLab。

### User permissions--用户权限

- [Access restrictions](user/admin_area/settings/visibility_and_access_controls.md#enabled-git-access-protocols): Define which Git access protocols can be used to talk to GitLab 访问限制：指定使用哪种Git访问协议来访问GitLab。
- [Authentication/Authorization](topics/authentication/index.md#gitlab-administrators): Enforce 2FA, configure external authentication with LDAP, SAML, CAS and additional Omniauth providers. 用户认证：执行 2FA配置外部的LDAP、SAML、CAS认证和额外的Omniauth供应商

### Features--功能

- [Container Registry](administration/container_registry.md): Configure Docker Registry with GitLab.注册容器：配置Docker的注册机制到GitLab
- [Custom Git hooks](administration/custom_hooks.md): Custom Git hooks (on the filesystem) for when webhooks aren't enough. 当webhooks不能满足你的时候，自定义Git钩子（在文件系统）
- [Git LFS configuration](workflow/lfs/lfs_administration.md): Learn how to use LFS under GitLab. 学习如何在GitLab中使用LFS
- [GitLab Pages configuration](administration/pages/index.md): Configure GitLab Pages. 配置GitLab页面
- [High Availability](administration/high_availability/README.md): Configure multiple servers for scaling or high availability. 配置多台服务以扩展或提高性能
- [User cohorts](user/admin_area/user_cohorts.md): View user activity over time. 随时间查看用户活动。
- [Web terminals](administration/integration/terminal.md): Provide terminal access to environments from within GitLab. 在GitLab中提供终端访问环境。
- GitLab CI 持续集成
    - [CI admin settings](user/admin_area/settings/continuous_integration.md): Define max artifacts size and expiration time.持续集成管理设置：定义最大工件大小和到期时间。

### Integrations--集成

- [Integrations](integration/README.md): How to integrate with systems such as JIRA, Redmine, Twitter.如何整合诸如JIRA，Redmine，Twitter等系统。
- [Mattermost](user/project/integrations/mattermost.md): Set up GitLab with Mattermost.设置GitLab使用Mattermost

### Monitoring--监控

- [GitLab performance monitoring with InfluxDB](administration/monitoring/performance/introduction.md): Configure GitLab and InfluxDB for measuring performance metrics. 使用InfluxDBA来监控GitLab活动：配置GitLab和InfluxDB以衡量性能指标
- [GitLab performance monitoring with Prometheus](administration/monitoring/prometheus/index.md): Configure GitLab and Prometheus for measuring performance metrics.使用Prometheus监控GitLab活动：配置GitLab和Prometheus以衡量性能指标
- [Monitoring uptime](user/admin_area/monitoring/health_check.md): Check the server status using the health check endpoint.监控运行时间：使用运行状况检查端点检查服务器状态
- [Monitoring GitHub imports](administration/monitoring/github_imports.md) 监控GitHub的导入

### Performance--性能表现

- [Housekeeping](administration/housekeeping.md): Keep your Git repository tidy and fast. 使存储库干净和高效
- [Operations](administration/operations.md): Keeping GitLab up and running. 操作：保持GitLab正常运行
- [Polling](administration/polling.md): Configure how often the GitLab UI polls for updates.轮询：配置GitLab UI轮询更新的频率
- [Request Profiling](administration/monitoring/performance/request_profiling.md): Get a detailed profile on slow requests.请求分析：获取缓慢请求的详细资料
- [Performance Bar](administration/monitoring/performance/performance_bar.md): Get performance information for the current page.性能栏：获取当前页面的性能信息。


### Customization--定制

- [Adjust your instance's timezone](workflow/timezone.md): Customize the default time zone of GitLab.自定义GitLab的默认时区
- [Environment variables](administration/environment_variables.md): Supported environment variables that can be used to override their defaults values in order to configure GitLab.定制环境变量：支持的环境变量，可用于覆盖其默认值，以配置GitLab；
- [Header logo](customization/branded_page_and_email_header.md): Change the logo on the overall page and email header.更改整个页面和电子邮件标题上的logo；
- [Issue closing pattern](administration/issue_closing_pattern.md): Customize how to close an issue from commit messages.自定义如何从提交消息中关闭问题；
- [Libravatar](customization/libravatar.md): Use Libravatar instead of Gravatar for user avatars.使用Libravatar而不是Gravatar作为用户头像；
- [Welcome message](customization/welcome_message.md): Add a custom welcome message to the sign-in page.将自定义欢迎消息添加到登录页面。

### Admin tools 管理工具

- [Gitaly](administration/gitaly/index.md): Configuring Gitaly, GitLab's Git repository storage service.配置GitLab的Git存储库存储服务和Gitaly；
- [Raketasks](raketasks/README.md): Backups, maintenance, automatic webhook setup and the importing of projects.备份、维护、自动设置webhook和导入项目
    - [Backup and restore](raketasks/backup_restore.md): Backup and restore your GitLab instance.备份和回复您的GitLab实例
- [Reply by email](administration/reply_by_email.md): Allow users to comment on issues and merge requests by replying to notification emails.允许用户在issues中评论和通过回复通知邮件发起merge请求
- [Repository checks](administration/repository_checks.md): Periodic Git repository checks.定期检查Git存储库；
- [Repository storage paths](administration/repository_storage_paths.md): Manage the paths used to store repositories.管理保存存储库的路径；
- [Security](security/README.md): Learn what you can do to further secure your GitLab instance.了解您可以做些什么来进一步保护您的GitLab实例
- [System hooks](system_hooks/system_hooks.md): Notifications when users, projects and keys are changed.系统钩子脚本：当用户、项目和密钥更改时自动通知您。

### Troubleshooting--故障排除

- [Debugging tips](administration/troubleshooting/debug.md): Tips to debug problems when things go wrong 调试问题时的提示；
- [Log system](administration/logs.md): Where to look for logs.查找日志信息；
- [Sidekiq Troubleshooting](administration/troubleshooting/sidekiq.md): Debug when Sidekiq appears hung and is not processing jobs.当Sidekiq挂起并且不处理作业时进行调试。


## Contributor documentation--贡献者文档

- [Development](development/README.md): All styleguides and explanations how to contribute.所有的styleguides和解释如何贡献
- [Legal](legal/README.md): Contributor license agreements. 参与者许可协议
- [Writing documentation](development/writing_documentation.md): Contributing to GitLab Docs. 参与GitLab文档的编写
