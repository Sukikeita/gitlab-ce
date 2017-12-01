# User documentation--�û�ʹ���ĵ�

Welcome to GitLab! We're glad to have you here!

��ӭ����GitLab�� ���Ǻܸ������������

As a GitLab user you'll have access to all the features
your [subscription](https://about.gitlab.com/products/)
includes, except [GitLab administrator](../README.md#administrator-documentation)
settings, unless you have admin privileges to install, configure,
and upgrade your GitLab instance.

��Ϊһ��GitLab�û�������Է������������ĵĹ��ܣ����˹���Ա�����á��������й���ԱȨ�ް�װ�����ú�����GitLab�汾��

For GitLab.com, admin privileges are restricted to the GitLab team.

����GitLab.com������ԱȨ�޽�����GitLab�Ŷӡ�

If you run your own GitLab instance and are looking for the administration settings,
please refer to the [administration](../README.md#administrator-documentation)
documentation.

����������Լ���GitLabʵ�������ڲ�����ι������ã�����Ĺ����ĵ���

## Overview--����

GitLab is a fully integrated software development platform that enables you
and your team to work cohesively, faster, transparently, and effectively,
since the discussion of a new idea until taking that idea to production all
all the way through, from within the same platform.

GitLab��һ����ȫ���ɵ��������ƽ̨��ʹ���������Ŷ��ܹ����ܺ����������٣���͸��������Ч�ؿ�չ��������Ϊ��һ���µ��뷨��ʼ���ۣ�ֱ������ʵ�ֵ����й��̣���������ƽ̨�Ͻ��С�

Please check this page for an overview on [GitLab's features](https://about.gitlab.com/features/).

��鿴��ҳ���Ի�ȡ����GitLab���ܵĸ�����

## Use cases--�û�����

GitLab is a git-based platforms that integrates a great number of essential tools for software development and deployment, and project management:

GitLab��һ������git��ƽ̨�������������������������Ͳ����Լ���Ŀ����Ļ������ߣ�

- Code hosting in repositories with version control �����й��ڰ汾���ƵĲֿ�
- Track proposals for new implementations, bug reports, and feedback with a
fully featured [Issue Tracker](project/issues/index.md#issue-tracker) ʹ��ȫ�ܵ����������������ʵ�ֵĽ��顢bug����ͷ�����Issues�壩��
- Organize and prioritize with [Issue Boards](project/issues/index.md#issue-boards) ��֯Issues�岢ȷ��������������˳��
- Code review in [Merge Requests](project/merge_requests/index.md) with live-preview changes per
branch with [Review Apps](../ci/review_apps/index.md)�ϲ������н��д�����飬��Review Apps����ʵʱԤ��ÿ����֧�еĸ��ģ�
- Build, test and deploy with built-in [Continuous Integration](../ci/README.md) ʹ�����õ�CI���й��������ԡ�����
- Deploy your personal and professional static websites with [GitLab Pages](project/pages/index.md) ʹ��GitLab Pages�������ĸ��˺�רҵ��̬��վ
- Integrate with Docker with [GitLab Container Registry](project/container_registry.md) ��Dockerһ�𼯳�GitLab����ע���
- Track the development lifecycle with [GitLab Cycle Analytics](project/cycle_analytics.md) ʹ��GitLab Cycle Analytics���ٿ�����������

With GitLab Enterprise Edition, you can also: 
GitLab EE�滹֧�����¶��⹦��

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

�������Խ�GitLab����������Ӧ�ó�����Mattermost��Microsoft Teams��HipChat��Trello��Slack��Bamboo CI��JIRA�ȣ�������һ��

### Articles--����

For a complete workflow use case please check [GitLab Workflow, an Overview](https://about.gitlab.com/2016/10/25/gitlab-workflow-an-overview/#gitlab-workflow-use-case-scenario).

�й������Ĺ���������������鿴GitLab�������̣�������

For more use cases please check our [Technical Articles](../articles/index.md).

�������ʹ�ð�������鿴���ǵļ������¡�

## Projects--��Ŀ

In GitLab, you can create [projects](project/index.md) for numerous reasons, such as, host
your code, use it as an issue tracker, collaborate on code, and continuously
build, test, and deploy your app with built-in GitLab CI/CD. Or, you can do
it all at once, from one single project.

��GitLab�У������Դ�����Ŀ��ԭ��ܶ࣬�����йܴ��룬�������������������Э�������Լ�ʹ�����õ�GitLab CI/CD���Ϲ��������ԺͲ���Ӧ�ó��� ���ߣ�����Դ�һ����һ����Ŀһ����ɡ�

- [Repositories](project/repository/index.md): Host your codebase in
repositories with version control and as part of a fully integrated platform.�洢�⣺ʹ�ð汾���ƽ�������й���֪ʶ���У�����Ϊ��ȫ���ɵ�ƽ̨��һ���֡�
- [Issues](project/issues/index.md): Explore the best of GitLab Issues' features.Is
sues�壺̽��GitLab�������ѹ��ܡ�
- [Merge Requests](project/merge_requests/index.md): Collaborate on code,
reviews, live preview changes per branch, and request approvals with Merge Requests. �ϲ������ڴ����Ͻ���Э�������ۣ�ÿ����֧��ʵʱԤ�������Լ�ʹ�úϲ�����������׼��
- [Milestones](project/milestones/index.md): Work on multiple issues and merge
requests towards the same target date with Milestones. ��̱������������Ⲣ���ϲ�����ϲ�������̱���ͬ��Ŀ�����ڡ�


## GitLab CI/CD

Use built-in [GitLab CI/CD](../ci/README.md) to test, build, and deploy your applications
directly from GitLab. No third-party integrations needed.

ʹ�����õ�GitLab CI/CD��ֱ�Ӵ�GitLab���ԣ������Ͳ���Ӧ�ó��� ������������ɡ�

- [GitLab Auto Deploy](../ci/autodeploy/index.md): Deploy your application out-of-the-box with GitLab Auto Deploy.ʹ��GitLab Auto Deploy���伴�õز�������Ӧ�ó���
- [Review Apps](../ci/review_apps/index.md): Live-preview the changes introduced by a merge request with Review Apps.ʹ�á��鿴Ӧ�ó���ʵʱԤ���ϲ���������ĸ��ġ�
- [GitLab Pages](project/pages/index.md): Publish your static site directly from
GitLab with Gitlab Pages. You can build, test, and deploy any Static Site Generator with Pages.��Gitlab Pagesֱ�Ӵ�GitLab������ľ�̬��վ�� ������ʹ��Pages���������ԺͲ����κξ�̬��վ��������
- [GitLab Container Registry](project/container_registry.md): Build and deploy Docker
images with Container Registry.ʹ��Container Registry�����Ͳ���Docker����

## Account--�˻�

There is a lot you can customize and configure
to enjoy the best of GitLab.

�кܶ�����Զ��ƺ����ã���������õ�GitLab��

- [Settings](profile/index.md): Manage your user settings to change your personal info,
personal access tokens, authorized applications, etc.���������û����ã��Ը������ĸ�����Ϣ�����˷������ƣ���ȨӦ�ó���ȡ�
- [Authentication](../topics/authentication/index.md): Read through the authentication
methods available in GitLab.ͨ��GitLab���ṩ����֤������
- [Permissions](permissions.md): Learn the different set of permissions levels for each
user type (guest, reporter, developer, master, owner).Ȩ�ޣ��˽�ÿ���û����ͣ��ÿͣ����ߣ������ߣ����ˣ������ߣ��Ĳ�ͬȨ�޼���

## Groups

With GitLab [Groups](group/index.md) you can assemble related projects together
and grant members access to several projects at once.

����GitLab�鹦�ܣ������Խ������Ŀ�����һ�𣬲������Աͬʱ���ʶ����Ŀ��

Groups can also be nested in [subgroups](group/subgroups/index.md).

��Ҳ����Ƕ���������С�

## Discussions ����

In GitLab, you can comment and mention collaborators in issues,
merge requests, code snippets, and commits.

��GitLab�У������������⣬�ϲ����󣬴���Ƭ�����ύ���ۺ��ᵽ�����ߵġ�

When performing inline reviews to implementations
to your codebase through merge requests you can
gather feedback through [resolvable discussions](discussions/index.md#resolvable-discussions).

��ͨ���ϲ�����Դ�����ִ����������ʱ��������ͨ�����������������ռ�������

### GitLab Flavored Markdown (GFM)

Read through the [GFM documentation](markdown.md) to learn how to apply
the best of GitLab Flavored Markdown in your discussions, comments,
issues and merge requests descriptions, and everywhere else GMF is
supported.

�Ķ�GFM�ĵ����˽�������������ۣ����ۣ�����ͺϲ�����������Ӧ��GitLab Flavored Markdown����ѹ��ܣ��Լ������ط�֧��GMF��

## Todos ��������

Never forget to reply to your collaborators. [GitLab Todos](../workflow/todos.md)
are a tool for working faster and more effectively with your team,
by listing all user or group mentions, as well as issues and merge
requests you're assigned to.

��Զ��Ҫ���ǻظ���ĺ����ߡ� GitLab Todos��ͨ���г������û���Ⱥ���ἰ�Լ��������������ͺϲ����󣬴Ӷ����죬����Ч���������ŶӺ����Ĺ��ߡ�

## Search ����

[Search and filter](search/index.md) through groups, projects, issues, merge requests, files, code, and more.

ͨ���飬��Ŀ�����⣬�ϲ������ļ�������Ƚ��������͹��ˡ�

## Snippets

[Snippets](snippets.md) are code blocks that you want to store in GitLab, from which
you have quick access to. You can also gather feedback on them through
[discussions](#discussions).

Snippets������Ҫ�洢��GitLab�еĴ���飬�����Դ��п��ٷ��ʡ� ��Ҳ����ͨ�������ռ����ǵķ��������

## Integrations

[Integrate GitLab](../integration/README.md) with your preferred tool,
such as Trello, JIRA, etc.

��GitLab��������ѡ���ߣ���Trello��JIRA�ȣ����ɡ�

## Webhooks 

Configure [webhooks](project/integrations/webhooks.html) to listen for
specific events like pushes, issues or merge requests. GitLab will send a
POST request with data to the webhook URL.

����webhooks�������ض����¼��������ͣ�issue��ϲ����� GitLab�����ʹ������ݵ�POST����webhook URL��

## API

Automate GitLab via [API](../api/README.html).ͨ��API�ĵ��Զ���GitLab��

## Git and GitLab

Learn what is [Git](../topics/git/index.md) and its best practices.ѧϰGit���������ʵ����
