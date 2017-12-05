# Configuring GitLab Runners--配置GitLab Runners

In GitLab CI, Runners run the code defined in [`.gitlab-ci.yml`](../yaml/README.md).
They are isolated (virtual) machines that pick up jobs through the coordinator
API of GitLab CI.

在GitLab CI中，Runners运行在.gitlab-ci.yml中定义的代码。 他们是孤立的（虚拟）机器，通过GitLab CI的协调器API提取作业。

A Runner can be specific to a certain project or serve any project
in GitLab CI. A Runner that serves all projects is called a shared Runner.

Runner可以是特指定为某个项目，也可以指定为GitLab CI中的服务项目的服务。 为所有项目提供服务的Runner被称为共享Runner。

Ideally, the GitLab Runner should not be installed on the same machine as GitLab.
Read the [requirements documentation](../../install/requirements.md#gitlab-runner)
for more information.

理想情况下，GitLab Runner不应与GitLab安装在同一台机器上。 阅读需求文档以获取更多信息。

## Shared vs specific Runners--共享还是指定Runners？

After [installing the Runner][install], you can either register it as shared or
specific. You can only register a shared Runner if you have admin access to
the GitLab instance. The main differences between a shared and a specific Runner
are:

安装Runner之后，您可以将其注册为共享或特定的。 如果您具有对GitLab实例的管理访问权限，则只能注册共享的Runner。 共享和特定跑步者之间的主要区别是：

- **Shared Runners** are useful for jobs that have similar requirements,
  between multiple projects. Rather than having multiple Runners idling for
  many projects, you can have a single or a small number of Runners that handle
  multiple projects. This makes it easier to maintain and update them.
  Shared Runners process jobs using a [fair usage queue](#how-shared-runners-pick-jobs).
  In contrast to specific Runners that use a FIFO queue, this prevents
  cases where projects create hundreds of jobs which can lead to eating all
  available shared Runners resources.
  
  共享运行程序对于多个项目之间具有相似要求的作业很有用。 而不是让多个跑步者空转许多项目，你可以有一个或少数的处理多个项目的Runners。 这使得更容易维护和更新它们。 共享运行程序使用公平使用队列处理作业。 与使用FIFO队列的特定Runners相比，这可以防止项目创建数百个可导致吃掉所有可用的共享Runners资源的工作的情况。
  
- **Specific Runners** are useful for jobs that have special requirements or for
  projects with a specific demand. If a job has certain requirements, you can set
  up the specific Runner with this in mind, while not having to do this for all
  Runners. For example, if you want to deploy a certain project, you can setup
  a specific Runner to have the right credentials for this. The [usage of tags](#using-tags)
  may be useful in this case. Specific Runners process jobs using a [FIFO] queue.

特定跑步者对于有特殊要求的工作或有特定需求的项目是有用的。 如果一个工作有特定的要求，你可以设置一个特定的Runner，而不必为所有Runner这样做。 例如，如果你想部署一个特定的项目，你可以设置一个特定的Runner来拥有正确的证书。 在这种情况下使用标签可能是有用的。 特定运行程序使用FIFO队列处理作业。

A Runner that is specific only runs for the specified project(s). A shared Runner
can run jobs for every project that has enabled the option **Allow shared Runners**
under **Settings ➔ CI/CD**.

特定的运行程序仅针对指定的项目运行。 共享的Runner可以为每个项目启用作业，该项目已启用  **Settings ➔ CI/CD** 下的 **Allow shared Runners**。

Projects with high demand of CI activity can also benefit from using specific
Runners. By having dedicated Runners you are guaranteed that the Runner is not
being held up by another project's jobs.

CI活动需求较高的项目也可以使用特定的跑步者。 通过专门的跑步者，你可以保证跑步者不会被其他项目的工作所阻碍。

You can set up a specific Runner to be used by multiple projects. The difference
with a shared Runner is that you have to enable each project explicitly for
the Runner to be able to run its jobs.

您可以设置一个特定的Runner供多个项目使用。 与共享Runner的区别在于，您必须显示地启用每个项目才能使Runner能够运行其作业。

Specific Runners do not get shared with forked projects automatically.
A fork does copy the CI settings (jobs, allow shared, etc) of the cloned
repository.

特定的跑步者不会自动与复刻项目共享。 一个分支可以复制克隆存储库的CI设置（作业，允许共享等）。

## Registering a shared Runner--注册一个共享Runner

You can only register a shared Runner if you are an admin of the GitLab instance.

如果您是GitLab实例的管理员，则只能注册共享的Runner。

1. Grab the shared-Runner token on the `admin/runners` page--抓取`admin/runners`页面上的共享运行者令牌

    ![Shared Runners admin area](img/shared_runners_admin.png)

1. [Register the Runner][register] 注册该Runner

Shared Runners are enabled by default as of GitLab 8.2, but can be disabled
with the **Disable shared Runners** button which is present under each project's
**Settings ➔ CI/CD** page. Previous versions of GitLab defaulted shared
Runners to disabled.

在GitLab 8.2中默认启用共享运行程序，但可以使用每个项目的 **Settings ➔ CI/CD**页面下的  **Disable shared Runners** 按钮来禁用共享运行程序。 先前版本的GitLab默认禁用共享的Runners。

## Registering a specific Runner--注册一个特定的Runner

Registering a specific can be done in two ways:

注册特定Runner可以通过两种方式完成：

1. Creating a Runner with the project registration token 使用项目注册令牌创建一个Runner
1. Converting a shared Runner into a specific Runner (one-way, admin only) 将共享的运行器转换为特定的运行器（单向，仅限管理员）

### Registering a specific Runner with a project registration token--使用项目注册令牌注册特定的Runner

To create a specific Runner without having admin rights to the GitLab instance,
visit the project you want to make the Runner work for in GitLab:

要创建一个的管理权限的特定的Runner，请访问您希望在GitLab中运行Runner的项目：

1. Go to **Settings ➔ CI/CD** to obtain the token--转至  **Settings ➔ CI/CD** 获取令牌
1. [Register the Runner][register]--注册该Runner

### Making an existing shared Runner specific--使现有的共享Runner转换为特定

If you are an admin on your GitLab instance, you can turn any shared Runner into
a specific one, but not the other way around. Keep in mind that this is a one
way transition.

如果您是GitLab的管理员，则可以将任何共享的Runner转换为特定的Runner，但不能反其道而行。 请记住，这是一个单向的转换。

1. Go to the Runners in the admin area **Overview ➔ Runners** (`/admin/runners`)
   and find your Runner--转到admin区域中的 **Overview ➔ Runners** (`/admin/runners`)并找到你的Runner
   
1. Enable any projects under **Restrict projects for this Runner** to be used
   with the Runner--启用  **Restrict projects for this Runner** 下的项目以使用该Runner
   

From now on, the shared Runner will be specific to those projects.

从现在开始，共享的Runner将专门针对这些项目。

## Locking a specific Runner from being enabled for other projects--锁定某个特定的Runner避免给其他项目启动

You can configure a Runner to assign it exclusively to a project. When a
Runner is locked this way, it can no longer be enabled for other projects.
This setting can be enabled the first time you [register a Runner][register] and
can be changed afterwards under each Runner's settings.

您可以配置一个Runner将其专门分配给一个项目。 当跑步者被这样锁定时，就不能再为其他项目启用了。 这个设置可以在你第一次注册一个Runner的时候启用，后续可以在Runner的设置页面中设置。

To lock/unlock a Runner:
锁定或解锁一个Runner的步骤：

1. Visit your project's **Settings ➔ CI/CD**--访问项目的 **Settings ➔ CI/CD**
1. Find the Runner you wish to lock/unlock and make sure it's enabled--找到你希望锁定/解锁的Runner，确保它已启动
1. Click the pencil button--点击铅笔按钮
1. Check the **Lock to current projects** option--检查 **Lock to current projects** 选项
1. Click **Save changes** for the changes to take effect--点击 **Save changes** 保存变更

## Assigning a Runner to another project--分配一个Runner给其他项目

If you are Master on a project where a specific Runner is assigned to, and the
Runner is not [locked only to that project](#locking-a-specific-runner-from-being-enabled-for-other-projects),
you can enable the Runner also on any other project where you have Master permissions.

如果您是专门分配了特定Runner的项目的主人，并且Runner未锁定到该项目，则可以在任何其他具有主人权限的项目上启用Runner。

To enable/disable a Runner in your project:
启动或停用某个Runner的步骤：

1. Visit your project's **Settings ➔ CI/CD**--访问项目的 **Settings ➔ CI/CD**；
1. Find the Runner you wish to enable/disable--选择你要启动/停用的Runner；
1. Click **Enable for this project** or **Disable for this project**--点击 **Enable for this project** 或 **Disable for this project**

> **Note**:
Consider that if you don't lock your specific Runner to a specific project, any
user with Master role in you project can assign your runner to another arbitrary
project without requiring your authorization, so use it with caution.考虑到如果你没有锁定特定Runner到特定的项目，任务有主人权限的用户可以分配您的runner给其他任意项目，而不需要您授权，因此请小心使用。

## Protected Runners--受保护的Runners

>
[Introduced](https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/13194)
in GitLab 10.0. 自GitLab 10.0引入

You can protect Runners from revealing sensitive information.
Whenever a Runner is protected, the Runner picks only jobs created on
[protected branches] or [protected tags], and ignores other jobs.

您可以保护Runner不会泄露敏感信息。 每当Runner受到保护时，Runner只挑选在受保护分支或受保护标记上创建的作业，并忽略其他作业。

To protect/unprotect Runners:
保护、解除保护Runner的步骤：

1. Visit your project's **Settings ➔ CI/CD**--访问项目的  **Settings ➔ CI/CD** ；
1. Find a Runner you want to protect/unprotect and make sure it's enabled--选择要保护或解保护的Runner并确保它已启用；
1. Click the pencil button besides the Runner name--点击Runner名旁边的铅笔按钮；
1. Check the **Protected** option--检查 **Protected** 选项；
1. Click **Save changes** for the changes to take effect--点击 **Save changes** 保存修改。

![specific Runners edit icon](img/protected_runners_check_box.png)

## How shared Runners pick jobs--共享Runner是如何执行作业的？

Shared Runners abide to a process queue we call fair usage. The fair usage
algorithm tries to assign jobs to shared Runners from projects that have the
lowest number of jobs currently running on shared Runners.

共享运行程序遵守我们称之为fair usage的进程队列。 fair usage算法尝试将作业号较小的分配给共享Runner。


**Example 1**

We have following jobs in queue:
假设我们的队列有以下作业

- Job 1 for Project 1
- Job 2 for Project 1
- Job 3 for Project 1
- Job 4 for Project 2
- Job 5 for Project 2
- Job 6 for Project 3

With the fair usage algorithm jobs are assigned in following order:
作业根据fair usage算法作业将以下顺序进行分配

1. Job 1 is chosen first, because it has the lowest job number from projects with no running jobs (i.e. all projects)--Job 1第一个被选择，因为在没有运行作业的项目中，它有最小的作业号；
1. Job 4 is next, because 4 is now the lowest job number from projects with no running jobs (Project 1 has a job running)--Job 4是第二个，因为从当前没有运行作业中的项目中，它有最小的作业号；
1. Job 6 is next, because 6 is now the lowest job number from projects with no running jobs (Projects 1 and 2 have jobs running)--Job 6是第三个，因为6是当前没有作业的项目中，它有最小的作业号；
1. Job 2 is next, because, of projects with the lowest number of jobs running (each has 1), it is the lowest job number--Job 2是第四个，因为在当前有运行作业的项目中，它的作业号较小；
1. Job 5 is next, because Project 1 now has 2 jobs running, and between Projects 2 and 3, Job 5 is the lowest remaining job number--Job 5是第五个，因为Porject 1现在有2个作业在运行，而在Project 2和3中，Job 5的作业号仍然较低；
1. Lastly we choose Job 3... because it's the only job left--Job 3是最后一个，因为只剩下它了。

---

**Example 2**

We have following jobs in queue:
假设我们的队列中有以下作业：

- Job 1 for project 1
- Job 2 for project 1
- Job 3 for project 1
- Job 4 for project 2
- Job 5 for project 2
- Job 6 for project 3

With the fair usage algorithm jobs are assigned in following order:
作业将按以下顺序被Runner执行：

1. Job 1 is chosen first, because it has the lowest job number from projects with no running jobs (i.e. all projects)--第一个是Job 1，因为作业号最小
1. We finish job 1--完成job 1
1. Job 2 is next, because, having finished Job 1, all projects have 0 jobs running again, and 2 is the lowest available job number--第二是Job 2，既然完成了Job 1，所有的项目都没有作业在运行，而Job 2是当前最小的作业号；
1. Job 4 is next, because with Project 1 running a job, 4 is the lowest number from projects running no jobs (Projects 2 and 3)--Job 4是第三个，因为Project 1有正在运行作业，Job 4是当前没有作业的project（项目2和3）中作业号是最小的
1. We finish job 4--完成Job 4；
1. Job 5 is next, because having finished Job 4, Project 2 has no jobs running again--Job 5是第四个，因为Job 4已完成，项目2没有作业
1. Job 6 is next, because Project 3 is the only project left with no running jobs--Job 6是第五个，因为项目3是唯一一个没运行作业；
1. Lastly we choose Job 3... because, again, it's the only job left (who says 1 is the loneliest number?)--最后是Job 3，因为，剩下只有它了

## Using shared Runners effectively--有效使用共享Runner

If you are planning to use shared Runners, there are several things you
should keep in mind.

如果你计划使用功效Runner，以下有几个要注意的事项：

### Using tags--使用标签(tags)

You must setup a Runner to be able to run all the different types of jobs
that it may encounter on the projects it's shared over. This would be
problematic for large amounts of projects, if it wasn't for tags.

您必须设置一个Runner才能运行它共享的项目中可能遇到的所有不同类型的作业。 如果不是标签，这对于大量的项目将是有问题的。

By tagging a Runner for the types of jobs it can handle, you can make sure
shared Runners will only run the jobs they are equipped to run.

通过给Runner添加一个可处理的工作类型的标签，你可以确保共享的Runners只能运行已配备的作业。

For instance, at GitLab we have Runners tagged with "rails" if they contain
the appropriate dependencies to run Rails test suites.

例如，在GitLab中，如果运行程序包含运行Rails测试套件的相应依赖项，则会使用“rails”标记Runner。

### Preventing Runners with tags from picking jobs without tags--防止带标签的Runner在没有标签的情况下选择工作

You can configure a Runner to prevent it from picking jobs with tags when
the Runner does not have tags assigned. This setting can be enabled the first
time you [register a Runner][register] and can be changed afterwards under
each Runner's settings.

当Runner没有分配标签时，您可以配置一个Runner以防止它使用标签选择作业。 这个设置可以在你第一次注册一个Runner的时候启用，并且可以在每个Runner的设置下改变。

To make a Runner pick tagged/untagged jobs:
标签或除去标签一个作业

1. Visit your project's **Settings ➔ CI/CD**--访问项目的 **Settings ➔ CI/CD**；
1. Find the Runner you wish and make sure it's enabled--找到该Runner并确保它已启用；
1. Click the pencil button--点击编辑按钮
1. Check the **Run untagged jobs** option--检查 **Run untagged jobs** 选项；
1. Click **Save changes** for the changes to take effect--点击 **Save changes** 保存变更；

### Be careful with sensitive information--小心敏感信息泄露

With some [Runner Executors](https://docs.gitlab.com/runner/executors/README.html),
if you can run a job on the Runner, you can get access to any code it runs
and get the token of the Runner. With shared Runners, this means that anyone
that runs jobs on the Runner, can access anyone else's code that runs on the
Runner.

使用一些Runner Executors，如果你可以在Runner上运行一个作业，你可以访问它运行的任何代码并获得Runner的token。 使用共享的运行程序，这意味着任何在运行程序上运行作业的人都可以访问在运行程序上运行的其他人的代码。

In addition, because you can get access to the Runner token, it is possible
to create a clone of a Runner and submit false jobs, for example.

另外，因为可以访问Runner标记，所以可以创建Runner的克隆并提交假作业。

The above is easily avoided by restricting the usage of shared Runners
on large public GitLab instances, controlling access to your GitLab instance,
and using more secure [Runner Executors](https://docs.gitlab.com/runner/executors/README.html).

通过限制在大型公共GitLab实例上共享Runner的使用，控制对GitLab实例的访问以及使用更安全的Runner Executors，可以轻松避免上述情况。

### Forks--复刻

Whenever a project is forked, it copies the settings of the jobs that relate
to it. This means that if you have shared Runners setup for a project and
someone forks that project, the shared Runners will also serve jobs of this
project.

只要项目被fork，它就会复制与Runner相关的作业设置。 这意味着如果您已经为一个项目设置了共享Runners，并且有人fork了该项目，那么共享的Runners也将为此项目提供任务。

## Attack vectors in Runners

Mentioned briefly earlier, but the following things of Runners can be exploited.
We're always looking for contributions that can mitigate these
[Security Considerations](https://docs.gitlab.com/runner/security/).

前面简要提到，但Runner的以下事情可以被利用。 我们一直在寻找可以减轻这些安全考虑因素的贡献。

[install]: http://docs.gitlab.com/runner/install/
[fifo]: https://en.wikipedia.org/wiki/FIFO_(computing_and_electronics)
[register]: http://docs.gitlab.com/runner/register/
[protected branches]: ../../user/project/protected_branches.md
[protected tags]: ../../user/project/protected_tags.md
