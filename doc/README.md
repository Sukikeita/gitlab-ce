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

| [GitLab CI/CD](ci/README.md) | Other |
| :----- | :----- |
| [Quick start guide](ci/quick_start/README.md) | [API](api/README.md) |
| [Configuring `.gitlab-ci.yml`](ci/yaml/README.md) | [SSH authentication](ssh/README.md) |
| [Using Docker images](ci/docker/using_docker_images.md) | [GitLab Pages](user/project/pages/index.md) |

- [User documentation](user/index.md)
- [Administrator documentation](#administrator-documentation)
- [Technical Articles](articles/index.md)

## Getting started with GitLab --��ʼʹ��GitLab

- [GitLab Basics](gitlab-basics/README.md): Start working on your command line and on GitLab.��GitLab��ʹ��������
- [GitLab Workflow](workflow/README.md): Enhance your workflow with the best of GitLab Workflow.ʹ��GitLab������
  - See also [GitLab Workflow - an overview](https://about.gitlab.com/2016/10/25/gitlab-workflow-an-overview/).Gitlab����
- [GitLab Markdown](user/markdown.md): GitLab's advanced formatting system (GitLab Flavored Markdown).
- [GitLab Quick Actions](user/project/quick_actions.md): Textual shortcuts for common actions on issues or merge requests that are usually done by clicking buttons or dropdowns in GitLab's UI.
- [Auto DevOps](topics/autodevops/index.md)

### User account �û��˻�

- [User account](user/profile/index.md): Manage your account �����˺�
  - [Authentication](topics/authentication/index.md): Account security with two-factor authentication, setup your ssh keys and deploy keys for secure access to your projects.�˺Ű�ȫ��������֤��ʽ���������ssh��Կ�Ͳ�����Կ�԰�ȫ�ط���������Ŀ
  - [Profile settings](user/profile/index.md#profile-settings): Manage your profile settings, two factor authentication and more.���������ļ����ã�������֤����ࡣ
- [User permissions](user/permissions.md): Learn what each role in a project (external/guest/reporter/developer/master/owner) can do.ѧϰ��Ŀ�еĽ�ɫ

### Projects and groups ��Ŀ����

- [Projects](user/project/index.md):
  - [Project settings](user/project/settings/index.md) ��Ŀ����
  - [Create a project](gitlab-basics/create-project.md) ������Ŀ
  - [Fork a project](gitlab-basics/fork-project.md) ����һ����Ŀ
  - [Importing and exporting projects between instances](user/project/settings/import_export.md). ��ʵ���е���򵼳���Ŀ
  - [Project access](public_access/public_access.md): Setting up your project's visibility to public, internal, or private. ������Ŀ��������Ŀ�Ŀ����ԣ�public��internal��provate��
  - [GitLab Pages](user/project/pages/index.md): Build, test, and deploy your static website with GitLab Pages.���������ԡ��������ľ�̬ҳ��
- [Groups](user/group/index.md): Organize your projects in groups. ����ķ�ʽ������Ŀ
  - [Subgroups](user/group/subgroups/index.md) ����
- [Search through GitLab](user/search/index.md): Search for issues, merge requests, projects, groups, todos, and issues in Issue Boards. ʹ��Issue��
- [Snippets](user/snippets.md): Snippets allow you to create little bits of code. Snippet�����㴴��һЩ����
- [Wikis](user/project/wiki/index.md): Enhance your repository documentation with built-in wikis. ʹ�����õ�wikes��ǿ�洢����ĵ�����

### Repository--�洢��

Manage your [repositories](user/project/repository/index.md) from the UI (user interface):
��UI����������Ĵ洢�⣺

- [Files](user/project/repository/index.md#files) �ļ�����
  - [Create a file](user/project/repository/web_editor.md#create-a-file) ����һ���ļ�
  - [Upload a file](user/project/repository/web_editor.md#upload-a-file) �ϴ�һ���ļ�
  - [File templates](user/project/repository/web_editor.md#template-dropdowns) ��ʱ�ļ�
  - [Create a directory](user/project/repository/web_editor.md#create-a-directory) ����һ��Ŀ¼
  - [Start a merge request](user/project/repository/web_editor.md#tips) (when committing via UI) ����һ���ϲ�����
- [Branches](user/project/repository/branches/index.md) ��֧����
  - [Default branch](user/project/repository/branches/index.md#default-branch) Ĭ�Ϸ�֧
  - [Create a branch](user/project/repository/web_editor.md#create-a-new-branch) ������֧
  - [Protected branches](user/project/protected_branches.md#protected-branches) ������֧
  - [Delete merged branches](user/project/repository/branches/index.md#delete-merged-branches) ɾ���Ѻϲ��ķ�֧
- [Commits](user/project/repository/index.md#commits) �ύ
  - [Signing commits](user/project/repository/gpg_signed_commits/index.md): use GPG to sign your commits. Signing�ύ��

### Issues and Merge Requests (MRs)--Issue�ͺϲ�����

- [Discussions](user/discussions/index.md): Threads, comments, and resolvable discussions in issues, commits, and  merge requests.
- [Issues](user/project/issues/index.md)
- [Project issue Board](user/project/issue_board.md)
- [Issues and merge requests templates](user/project/description_templates.md): Create templates for submitting new issues and merge requests.
- [Labels](user/project/labels.md): Categorize your issues or merge requests based on descriptive titles.���ݱ���������issues�ͺϲ������¼
- [Merge Requests](user/project/merge_requests/index.md) �ϲ�����
  - [Work In Progress Merge Requests](user/project/merge_requests/work_in_progress_merge_requests.md)
  - [Merge Request discussion resolution](user/discussions/index.md#moving-a-single-discussion-to-a-new-issue): Resolve discussions, move discussions in a merge request to an issue, only allow merge requests to be merged if all discussions are resolved.����������⡢�����۴Ӻϲ������Ƶ�issue�У�������������ѽ������ֻ����ϲ�����
  - [Checkout merge requests locally](user/project/merge_requests/index.md#checkout-merge-requests-locally) ���ϲ�������������
  - [Cherry-pick](user/project/merge_requests/cherry_pick_changes.md)
- [Milestones](user/project/milestones/index.md): Organize issues and merge requests into a cohesive group, optionally setting a due date. ��̱�����֯issue�ͺϲ�����һ���������������У���ѡ�����ý�ֹ����
- [Todos](workflow/todos.md): A chronological list of to-dos that are waiting for your input, all in a simple dashboard.�ȴ���������İ�ʱ������Ĵ��������嵥��ȫ�����ڼ򵥵��Ǳ���С�


### Git and GitLab

- [Git](topics/git/index.md): Getting started with Git, branching strategies, Git LFS, advanced use. ��֧���ԡ�Git��LFS���߼��÷�
- [Git cheatsheet](https://gitlab.com/gitlab-com/marketing/raw/master/design/print/git-cheatsheet/print-pdf/git-cheatsheet.pdf): Download a PDF describing the most used Git operations.���س��õ�Git������PDF�ĵ�
- [GitLab Flow](workflow/gitlab_flow.md): explore the best of Git with the GitLab Flow strategy.̽��ʹ������ʵĹ���������

### Migrate and import your projects from other platforms--������ƽ̨Ǩ�ƺ͵�����Ŀ��Git

- [Importing to GitLab](user/project/import/index.md): Import your projects from GitHub, Bitbucket, GitLab.com, FogBugz and SVN into GitLab.������ƴͼ����������Ŀ��GitLab
- [Migrating from SVN](workflow/importing/migrating_from_svn.md): Convert a SVN repository to Git and GitLab.��SVN�洢��Ǩ�Ƶ�Git��GitLab

### Continuous Integration, Delivery, and Deployment--�������ɡ��������Ͳ���

- [GitLab CI](ci/README.md): Explore the features and capabilities of Continuous Integration, Continuous Delivery, and Continuous Deployment with GitLab.�˽�GitLab��CI���������������������ܺ�����
  - [Auto Deploy](ci/autodeploy/index.md): Configure GitLab CI for the deployment of your application.����CI����Ӧ��
  - [Review Apps](ci/review_apps/index.md): Preview changes to your app right from a merge request.�Ӻϲ������н��д������
- [GitLab Cycle Analytics](user/project/cycle_analytics.md): Cycle Analytics measures the time it takes to go from an [idea to production](https://about.gitlab.com/2016/08/05/continuous-integration-delivery-and-deployment-with-gitlab/#from-idea-to-production-with-gitlab) for each project you have. ������Ŀ������
- [GitLab Container Registry](user/project/container_registry.md): Learn how to use GitLab's built-in Container Registry.ѧϰ���ʹ�����õ�ע������

### Automation--�Զ���

- [API](api/README.md): Automate GitLab via a simple and powerful API. ͨ���򵥶�ǿ���API�Զ���GitLab
- [GitLab Webhooks](user/project/integrations/webhooks.md): Let GitLab notify you when new code has been pushed to your project. ��GitLab֪ͨ���������µĴ������͵�������Ŀʱ��

### Integrations--����

- [Project Services](user/project/integrations/project_services.md): Integrate a project with external services, such as CI and chat. ʹ���ⲿ������CI��chat������Ŀ
- [GitLab Integration](integration/README.md): Integrate with multiple third-party services with GitLab to allow external issue trackers and external authentication. ʹ�õ��������񼯳ɵ�GitLab����ʹ���ⲿ��issue���ٺ��ⲿ����֤����
- [Trello Power-Up](integration/trello_power_up.md): Integrate with GitLab's Trello Power-Up ����Trello Power-Up

----

## Administrator documentation--����GitLab

Learn how to administer your GitLab instance. Regular users don't
have access to GitLab administration tools and settings.
ѧϰ��ι�������GitLabʵ������ͨ�û�û��Ȩ�޷��ʹ���Ա���ߺ����á�


### Install, update, upgrade, migrate ��װ�����¡�������Ǩ��

- [Install](install/README.md): Requirements, directory structures and installation from source.��װ��Ҫ��Ŀ¼�ṹ�ʹ�Դ���а�װ
- [Mattermost](https://docs.gitlab.com/omnibus/gitlab-mattermost/): Integrate [Mattermost](https://about.mattermost.com/) with your GitLab installation.����Mattermost��GitLab�С�
- [Migrate GitLab CI to CE/EE](migrate_ci_to_ce/README.md): If you have an old GitLab installation (older than 8.0), follow this guide to migrate your existing GitLab CI data to GitLab CE/EE.�����ʹ�õ��ǽ����GitLab�汾���밴�ձ�ָ�Ͻ����е�GitLab CI����Ǩ�Ƶ�GitLab CE/EE��
- [Restart GitLab](administration/restart_gitlab.md): Learn how to restart GitLab and its components. ѧϰ�������GitLab�����
- [Update](update/README.md): Update guides to upgrade your installation. ����GitLab��

### User permissions--�û�Ȩ��

- [Access restrictions](user/admin_area/settings/visibility_and_access_controls.md#enabled-git-access-protocols): Define which Git access protocols can be used to talk to GitLab �������ƣ�ָ��ʹ������Git����Э��������GitLab��
- [Authentication/Authorization](topics/authentication/index.md#gitlab-administrators): Enforce 2FA, configure external authentication with LDAP, SAML, CAS and additional Omniauth providers. �û���֤��ִ�� 2FA�����ⲿ��LDAP��SAML��CAS��֤�Ͷ����Omniauth��Ӧ��

### Features--����

- [Container Registry](administration/container_registry.md): Configure Docker Registry with GitLab.ע������������Docker��ע����Ƶ�GitLab
- [Custom Git hooks](administration/custom_hooks.md): Custom Git hooks (on the filesystem) for when webhooks aren't enough. ��webhooks�����������ʱ���Զ���Git���ӣ����ļ�ϵͳ��
- [Git LFS configuration](workflow/lfs/lfs_administration.md): Learn how to use LFS under GitLab. ѧϰ�����GitLab��ʹ��LFS
- [GitLab Pages configuration](administration/pages/index.md): Configure GitLab Pages. ����GitLabҳ��
- [High Availability](administration/high_availability/README.md): Configure multiple servers for scaling or high availability. ���ö�̨��������չ���������
- [User cohorts](user/admin_area/user_cohorts.md): View user activity over time. ��ʱ��鿴�û����
- [Web terminals](administration/integration/terminal.md): Provide terminal access to environments from within GitLab. ��GitLab���ṩ�ն˷��ʻ�����
- GitLab CI ��������
    - [CI admin settings](user/admin_area/settings/continuous_integration.md): Define max artifacts size and expiration time.�������ɹ������ã�������󹤼���С�͵���ʱ�䡣

### Integrations--����

- [Integrations](integration/README.md): How to integrate with systems such as JIRA, Redmine, Twitter.�����������JIRA��Redmine��Twitter��ϵͳ��
- [Mattermost](user/project/integrations/mattermost.md): Set up GitLab with Mattermost.����GitLabʹ��Mattermost

### Monitoring--���

- [GitLab performance monitoring with InfluxDB](administration/monitoring/performance/introduction.md): Configure GitLab and InfluxDB for measuring performance metrics. ʹ��InfluxDBA�����GitLab�������GitLab��InfluxDB�Ժ�������ָ��
- [GitLab performance monitoring with Prometheus](administration/monitoring/prometheus/index.md): Configure GitLab and Prometheus for measuring performance metrics.ʹ��Prometheus���GitLab�������GitLab��Prometheus�Ժ�������ָ��
- [Monitoring uptime](user/admin_area/monitoring/health_check.md): Check the server status using the health check endpoint.�������ʱ�䣺ʹ������״�����˵��������״̬
- [Monitoring GitHub imports](administration/monitoring/github_imports.md) ���GitHub�ĵ���

### Performance--���ܱ���

- [Housekeeping](administration/housekeeping.md): Keep your Git repository tidy and fast. ʹ�洢��ɾ��͸�Ч
- [Operations](administration/operations.md): Keeping GitLab up and running. ����������GitLab��������
- [Polling](administration/polling.md): Configure how often the GitLab UI polls for updates.��ѯ������GitLab UI��ѯ���µ�Ƶ��
- [Request Profiling](administration/monitoring/performance/request_profiling.md): Get a detailed profile on slow requests.�����������ȡ�����������ϸ����
- [Performance Bar](administration/monitoring/performance/performance_bar.md): Get performance information for the current page.����������ȡ��ǰҳ���������Ϣ��


### Customization--����

- [Adjust your instance's timezone](workflow/timezone.md): Customize the default time zone of GitLab.�Զ���GitLab��Ĭ��ʱ��
- [Environment variables](administration/environment_variables.md): Supported environment variables that can be used to override their defaults values in order to configure GitLab.���ƻ���������֧�ֵĻ��������������ڸ�����Ĭ��ֵ��������GitLab��
- [Header logo](customization/branded_page_and_email_header.md): Change the logo on the overall page and email header.��������ҳ��͵����ʼ������ϵ�logo��
- [Issue closing pattern](administration/issue_closing_pattern.md): Customize how to close an issue from commit messages.�Զ�����δ��ύ��Ϣ�йر����⣻
- [Libravatar](customization/libravatar.md): Use Libravatar instead of Gravatar for user avatars.ʹ��Libravatar������Gravatar��Ϊ�û�ͷ��
- [Welcome message](customization/welcome_message.md): Add a custom welcome message to the sign-in page.���Զ��延ӭ��Ϣ��ӵ���¼ҳ�档

### Admin tools ������

- [Gitaly](administration/gitaly/index.md): Configuring Gitaly, GitLab's Git repository storage service.����GitLab��Git�洢��洢�����Gitaly��
- [Raketasks](raketasks/README.md): Backups, maintenance, automatic webhook setup and the importing of projects.���ݡ�ά�����Զ�����webhook�͵�����Ŀ
    - [Backup and restore](raketasks/backup_restore.md): Backup and restore your GitLab instance.���ݺͻظ�����GitLabʵ��
- [Reply by email](administration/reply_by_email.md): Allow users to comment on issues and merge requests by replying to notification emails.�����û���issues�����ۺ�ͨ���ظ�֪ͨ�ʼ�����merge����
- [Repository checks](administration/repository_checks.md): Periodic Git repository checks.���ڼ��Git�洢�⣻
- [Repository storage paths](administration/repository_storage_paths.md): Manage the paths used to store repositories.������洢���·����
- [Security](security/README.md): Learn what you can do to further secure your GitLab instance.�˽���������Щʲô����һ����������GitLabʵ��
- [System hooks](system_hooks/system_hooks.md): Notifications when users, projects and keys are changed.ϵͳ���ӽű������û�����Ŀ����Կ����ʱ�Զ�֪ͨ����

### Troubleshooting--�����ų�

- [Debugging tips](administration/troubleshooting/debug.md): Tips to debug problems when things go wrong ��������ʱ����ʾ��
- [Log system](administration/logs.md): Where to look for logs.������־��Ϣ��
- [Sidekiq Troubleshooting](administration/troubleshooting/sidekiq.md): Debug when Sidekiq appears hung and is not processing jobs.��Sidekiq�����Ҳ�������ҵʱ���е��ԡ�


## Contributor documentation--�������ĵ�

- [Development](development/README.md): All styleguides and explanations how to contribute.���е�styleguides�ͽ�����ι���
- [Legal](legal/README.md): Contributor license agreements. ���������Э��
- [Writing documentation](development/writing_documentation.md): Contributing to GitLab Docs. ����GitLab�ĵ��ı�д
