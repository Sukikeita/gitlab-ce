# Issues

The GitLab Issue Tracker is an advanced and complete tool
for tracking the evolution of a new idea or the process
of solving a problem.

GitLab�����������һ���Ƚ��ĺ������Ĺ��ߣ����ڸ������뷨���ݱ��������Ĺ��̡�

It allows you, your team, and your collaborators to share
and discuss proposals before and while implementing them.

���������������ŶӺ����ĺ�������ʵʩǰ����������᰸��

GitLab Issues and the GitLab Issue Tracker are available in all
[GitLab Products](https://about.gitlab.com/products/) as
part of the [GitLab Workflow](https://about.gitlab.com/2016/10/25/gitlab-workflow-an-overview/).

��ΪGitLab�������̵�һ���֣�����GitLab��Ʒ���ṩGitLab�����GitLab�����������

## Use cases--�û�����

Issues can have endless applications. Just to exemplify, these are
some cases for which creating issues are most used:

Issues�������޾���Ӧ�á� Ϊ�˾���˵������Щ�Ǵ���������õ�һЩ�����

- Discussing the implementation of a new idea ����һ���µ��뷨��ʵ��
- Submitting feature proposals �ύ��������
- Asking questions ����
- Reporting bugs and malfunction �������͹���
- Obtaining support ���֧��
- Elaborating new code implementations �����µĴ���ʵ��


See also the blog post "[Always start a discussion with an issue](https://about.gitlab.com/2016/03/03/start-with-an-issue/)".

����������¡����Ǵӿ�ʼ����һ�����⡱��

### Keep private things private ���ָ��˵�˽����

For instance, let's assume you have a public project but want to start a discussion on something
you don't want to be public. With [Confidential Issues](#confidential-issues),
you can discuss private matters among the project members, and still keep
your project public, open to collaboration.

���磬��������һ��������Ŀ��������Ҫ��ʼ����һЩ�㲻�빫�������顣 ͨ���������⣨Confidential Issues��������������Ŀ��Ա֮������˽�����񣬲�����Ȼ����������Ŀ����ͬ�¿��š�

### Streamline collaboration ��Э��

With [Multiple Assignees for Issues](https://docs.gitlab.com/ee/user/project/issues/multiple_assignees_for_issues.html),
available in [GitLab Enterprise Edition Starter](https://about.gitlab.com/gitlab-ee/)
you can streamline collaboration and allow shared responsibilities to be clearly displayed.
All assignees are shown across your workflows and receive notifications (as they
would as single assignees), simplifying communication and ownership.

ͨ��GitLab Enterprise Edition Starter�еĶ��Assignees for Issues�������Լ�Э���������������ʾ�������Ρ� ���������˶���ʾ�����Ĺ��������У�������֪ͨ����ͬ����������һ�������Ӷ��򻯹�ͨ������Ȩ��

### Consistent collaboration һ�µ�Э��

Create [issue templates](#issue-templates) to make collaboration consistent and
containing all information you need. For example, you can create a template
for feature proposals and another one for bug reports.

��������ģ�壬ʹЭ������һ�²������������������Ϣ�� ���磬������Ϊ�������󴴽�һ��ģ�壬Ϊ���󱨸洴����һ��ģ�塣

## Issue Tracker--�������

The Issue Tracker is the collection of opened and closed issues created in a project.
It is available for all projects, from the moment the project is created.

���������������Ŀ�д������Ѵ򿪺��ѹر�����ļ��ϡ� ����Ŀ��������һ�������Ϳ�����������Ŀ��

Find the issue tracker by navigating to your **Project's homepage** > **Issues**.

ͨ������ **Project's homepage** > **Issues** �ҵ������������

### Issues per project--��Ŀ��Issues

When you access your project's issues, GitLab will present them in a list,
and you can use the tabs available to quickly filter by open and closed issues.

������������Ŀ����ʱ��GitLab����������ʾ��һ���б��У������ʹ�ÿ��õı�ǩ���ٵع��˿��źͷ�յ����⡣

![Project issues list view](img/project_issues_list_view.png)

You can also [search and filter](../../search/index.md#issues-and-merge-requests-per-project) the results more deeply with GitLab's search capacities.

��������ʹ��GitLab���������ܸ�����������͹��˽����

### Issues per group --���Issues

View all the issues in a group (that is, all the issues across all projects in that
group) by navigating to **Group > Issues**. This view also has the open and closed
issue tabs.

ͨ��������**Group > Issues**�鿴���е��������⣨����������������Ŀ���������⣩�� �����ͼҲ�п��źͷ�յ������ǩ��

![Group Issues list view](img/group_issues_list_view.png)

## GitLab Issues Functionalities

The image bellow illustrates how an issue looks like:
�����ͼƬչʾ��Issue�����ӣ�

![Issue view](img/issues_main_view.png)

Learn more about it on the [GitLab Issues Functionalities documentation](issues_functionalities.md).

��GitLab���⹦���ĵ����˽������Ϣ��

## New issue--����issue

Read through the [documentation on creating issues](create_new_issue.md).

�Ķ��йش���issue���ĵ���

## Closing issues--�ر�issues

Learn distinct ways to [close issues](closing_issues.md) in GitLab.

ѧϰ��ͬ�ķ������ر�GitLab�е�issue��

## Moving issues

Read through the [documentation on moving issues](moving_issues.md).

�Ķ��й��ƶ�issue���ĵ���

## Deleting issues--�ر�issues

Read through the [documentation on deleting issues](deleting_issues.md)

�Ķ��й�ɾ��issues���ĵ�

## Create a merge request from an issue--��issue�д����ϲ�����

Learn more about it on the [GitLab Issues Functionalities documentation](issues_functionalities.md#18-new-merge-request).

��GitLab���⹦���ĵ����˽������Ϣ��

## Search for an issue--����issue

Learn how to [find an issue](../../search/index.md) by searching for and filtering them.

�˽����ͨ�������͹���������issue��

## Advanced features--�߼�����

### Confidential Issues--��������

Whenever you want to keep the discussion presented in a
issue within your team only, you can make that
[issue confidential](confidential_issues.md). Even if your project
is public, that issue will be preserved. The browser will
respond with a 404 error whenever someone who is not a project
member with at least [Reporter level](../../permissions.md#project) tries to
access that issue's URL.

���ۺ�ʱֻҪ�����Ŷ��ڲ�ֻ������������ۣ��������Խ������Ᵽ�ܡ� ��ʹ�����Ŀ�ǹ����ģ��������Ҳ�ᱻ���������� ���ĳ�����Ǿ�������Reporter�������Ŀ��Ա���˳��Է��ʸ�issue��URL�����������404���������Ӧ��

Learn more about them on the [confidential issues documentation](confidential_issues.md).

�ڱ���issue�ĵ����˽������Ϣ��

### Issue templates--issueģ��

Create templates for every new issue. They will be available from
the dropdown menu **Choose a template** when you create a new issue:

Ϊÿ�������ⴴ��ģ�塣 ���ǽ��������˵��п��ô���������ʱѡ��һ��ģ�壺

![issue template](img/issue_template.png)

Learn more about them on the [issue templates documentation](../../project/description_templates.md#creating-issue-templates).

������ģ���ĵ����˽������Ϣ��

### Crosslinking issues--��������

Learn more about [crosslinking](crosslinking_issues.md) issues and merge requests.

��ϸ�˽⽻������ͺϲ�����

### Issue Board

The [GitLab Issue Board](https://about.gitlab.com/features/issueboard/) is a way to
enhance your workflow by organizing and prioritizing issues in GitLab.

GitLab Issue����һ��ͨ����֯GitLab�е����Ⲣ�Ż����������ȼ�����ǿ�������̵ķ�����

![Issue board](img/issue_board.png)

Find GitLab Issue Boards by navigating to your **Project's Dashboard** > **Issues** > **Board**.

ͨ����������Ŀ��**Project's Dashboard** > **Issues** > **Board**������GitLab Issue Boards��

Read through the documentation for [Issue Boards](../issue_board.md)
to find out more about this feature.

�Ķ���[Issue Boards](../issue_board.md)�˽������ڴ˹��ܡ�

With [GitLab Enterprise Edition Starter](https://about.gitlab.com/gitlab-ee/), you can also
create various boards per project with [Multiple Issue Boards](https://docs.gitlab.com/ee/user/project/issue_board.html#multiple-issue-boards).

ʹ��GitLab Enterprise Edition Starter����������ʹ�ö��[Multiple Issue Boards] Ϊÿ����Ŀ������ͬ�İ塣

### External Issue Tracker--ʹ���ⲿ�����������

Alternatively to GitLab's built-in Issue Tracker, you can also use an [external
tracker](../../../integration/external-issue-tracker.md) such as Jira, Redmine,
or Bugzilla.

����GitLab���õ�����������⣬��������ʹ��Jira��Redmine��Bugzilla���ⲿ��������

### Issue's API--

Read through the [API documentation](../../../api/issues.md).
ͨ��API�ĵ���
