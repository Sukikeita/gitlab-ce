# Introduction to pipelines and jobs--管道和jobs的介绍

> Introduced in GitLab 8.8. 自GitLab 8.8引入

## Pipelines

A pipeline is a group of [jobs][] that get executed in [stages][](batches).
All of the jobs in a stage are executed in parallel (if there are enough
concurrent [Runners]), and if they all succeed, the pipeline moves on to the
next stage. If one of the jobs fails, the next stage is not (usually)
executed. You can access the pipelines page in your project's **Pipelines** tab.

流水线（pipeline）是一组阶段（批次）执行的作业。 并行执行一个阶段中的所有作业（如果有足够的并发运行程序），并且如果它们全部成功，则管道移动到下一阶段。 如果其中一个工作失败，下一阶段不（通常）执行。 您可以访问项目的“管道”选项卡中的管道页面。

In the following image you can see that the pipeline consists of four stages
(`build`, `test`, `staging`, `production`) each one having one or more jobs.

在下面的图片中，您可以看到，管道包含四个阶段（构建，测试，预发布，生产），每个阶段都有一个或多个作业。

>**Note:**
GitLab capitalizes the stages' names when shown in the [pipeline graphs](#pipeline-graphs).

注意：GitLab在流水线图中显示的时候使用大写的名字。

![Pipelines example](img/pipelines.png)

## Types of pipelines

There are three types of pipelines that often use the single shorthand of "pipeline". People often talk about them as if each one is "the" pipeline, but really, they're just pieces of a single, comprehensive pipeline.

有三种类型的管道经常使用“管道”的单一速记。 人们经常谈论他们，好像每个人都是“管道”，但实际上，他们只是一个单一的综合管道。


![Types of Pipelines](img/types-of-pipelines.svg)


1. **CI Pipeline**: Build and test stages defined in `.gitlab-ci.yml`--在.gitlab-ci.yml中定义的构建和测试阶段
2. **Deploy Pipeline**: Deploy stage(s) defined in `.gitlab-ci.yml` The flow of deploying code to servers through various stages: e.g. development to staging to production；部署在.gitlab-ci.yml中定义的阶段通过各个阶段将代码部署到服务器的流程： development-> staging->production；
3. **Project Pipeline**: Cross-project CI dependencies [triggered via API][triggers], particularly for micro-services, but also for complicated build dependencies: e.g. api -> front-end, ce/ee -> omnibus.--通过API触发的跨项目CI依赖关系，特别是针对微服务的，还针对复杂的构建依赖关系： api -> front-end, ce/ee -> omnibus。

## Development workflows--开发流程

Pipelines accommodate several development workflows:
管道适应多种开发工作流程：


1. **Branch Flow** (e.g. different branch for dev, qa, staging, production)--分支流（例如dev，qa，分期，生产的不同分支）
2. **Trunk-based Flow** (e.g. feature branches and single master branch, possibly with tags for releases)--基于trunk的流程（例如，功能分支和单个主分支，可能带有发行标签）
3. **Fork-based Flow** (e.g. merge requests come from forks)--如：来自forks的合并请求

Example continuous delivery flow:
演示连续交付流程：


![CD Flow](img/pipelines-goal.svg)

## Jobs

Jobs can be defined in the [`.gitlab-ci.yml`][jobs-yaml] file. Not to be
confused with a `build` job or `build` stage.

作业可以在.gitlab-ci.yml文件中定义。 不要与构建job或构件stage混淆。

## Defining pipelines--定义pilelines

Pipelines are defined in `.gitlab-ci.yml` by specifying [jobs] that run in
[stages].

管道可在.gitlab-ci.yml中定义，通过在分阶段（stages）指定运行的作业（jobs）。

See the reference [documentation for jobs](yaml/README.md#jobs).

有关作业，请参阅参考文档。

## Seeing pipeline status--查看pipeline状态

You can find the current and historical pipeline runs under your project's
**Pipelines** tab. Clicking on a pipeline will show the jobs that were run for
that pipeline.

您可以在项目的“管道”选项卡下找到当前和历史管道运行记录。 点击管道将显示为该管道运行的作业。

![Pipelines index page](img/pipelines_index.png)

## Seeing job status--查看job的状态

When you visit a single pipeline you can see the related jobs for that pipeline.
Clicking on an individual job will show you its job trace, and allow you to
cancel the job, retry it, or erase the job trace.

当您访问单个管道时，您可以看到该管道的相关作业。 点击单个作业会显示其作业跟踪，并允许您取消作业，重试作业或清除作业跟踪。

![Pipelines example](img/pipelines.png)

## Pipeline graphs--Pipeline图

> [Introduced][ce-5742] in GitLab 8.11.
子GtiLab 8.11引入

Pipelines can be complex structures with many sequential and parallel jobs.
To make it a little easier to see what is going on, you can view a graph
of a single pipeline and its status.

流水线可以是复杂的结构，具有许多线性和并行的工作。 为了使它更容易看到发生了什么，您可以查看单个管道的图形及其状态。

A pipeline graph can be shown in two different ways depending on what page you
are on.

管道图可以用两种不同的方式显示，具体取决于你在哪个页面上。

---

The regular pipeline graph that shows the names of the jobs of each stage can
be found when you are on a [single pipeline page](#seeing-pipeline-status).

常规管道图可以在单个管道页面上找到，显示每个阶段作业名称。


![Pipelines example](img/pipelines.png)

Then, there is the pipeline mini graph which takes less space and can give you a
quick glance if all jobs pass or something failed. The pipeline mini graph can
be found when you visit:

然后，有管道迷你图，占用更少的空间，如果所有的工作都通过或失败，可以快速浏览一下。 管道迷你图可以在您访问时找到：

- the pipelines index page--pileilines索引页面
- a single commit page--单个提交页面
- a merge request page--合并请求页面

That way, you can see all related jobs for a single commit and the net result
of each stage of your pipeline. This allows you to quickly see what failed and
fix it. Stages in pipeline mini graphs are collapsible. Hover your mouse over
them and click to expand their jobs.

这样，您就可以看到单个提交的所有相关的作业以及pipeline每个阶段的最终结果。 这使您可以快速查看失败并修复它。 管道迷你图的阶段是可折叠的。 将鼠标悬停在上面，然后单击以展开其作业。


| **Mini graph** | **Mini graph expanded** |
| :------------: | :---------------------: |
| ![Pipelines mini graph](img/pipelines_mini_graph_simple.png) | ![Pipelines mini graph extended](img/pipelines_mini_graph.png) |

### Grouping similar jobs in the pipeline graph 在管道图中分组类似的作业

> [Introduced][ce-6242] in GitLab 8.12.

If you have many similar jobs, your pipeline graph becomes very long and hard
to read. For that reason, similar jobs can automatically be grouped together.
If the job names are formatted in certain ways, they will be collapsed into
a single group in regular pipeline graphs (not the mini graphs).
You'll know when a pipeline has grouped jobs if you don't see the retry or
cancel button inside them. Hovering over them will show the number of grouped
jobs. Click to expand them.

如果你有很多类似的工作，你的管道图变得很长，很难阅读。 出于这个原因，类似的工作可以自动分组在一起。 如果作业名称是以某种格式命名的，则它们将在常规管线图（而不是迷你图）中折叠为一个组。 如果您没有在其中看到重试或取消按钮，则会知道管道何时将作业分组。 将鼠标悬停在上面会显示分组作业的数量。 点击展开它们。

![Grouped pipelines](img/pipelines_grouped.png)

The basic requirements is that there are two numbers separated with one of
the following (you can even use them interchangeably):

基本的要求是有两个数字用下面的一个分开（你甚至可以互换使用）：

- a space空格
- a backslash (`/`)斜杠
- a colon (`:`)冒号

>**Note:**
More specifically, [it uses][regexp] this regular expression: `\d+[\s:\/\\]+\d+\s*`.

注意：更具体地说，它使用这个正则表达式：`\d+[\s:\/\\]+\d+\s*`。

The jobs will be ordered by comparing those two numbers from left to right. You
usually want the first to be the index and the second the total.

工作将通过从左到右比较这两个数字进行排序。 你通常希望第一个是索引，第二个是总数。

For example, the following jobs will be grouped under a job named `test`:
例如，以下作业将被分组在名为test的作业下：

- `test 0 3` => `test`
- `test 1 3` => `test`
- `test 2 3` => `test`

The following jobs will be grouped under a job named `test ruby`:
以下作业将被分组在一个名为test ruby的作业下：

- `test 1:2 ruby` => `test ruby`
- `test 2:2 ruby` => `test ruby`

The following jobs will be grouped under a job named `test ruby` as well:
以下作业也将被分组在一个名为test ruby的作业下：

- `1/3 test ruby` => `test ruby`
- `2/3 test ruby` => `test ruby`
- `3/3 test ruby` => `test ruby`

### Manual actions from the pipeline graph--管道图的手工操作

> [Introduced][ce-7931] in GitLab 8.15.

[Manual actions][manual] allow you to require manual interaction before moving
forward with a particular job in CI. Your entire pipeline can run automatically,
but the actual [deploy to production][env-manual] will require a click.

手动操作允许您在继续使用CI中的特定作业之前要求手动交互。 您的整个管道可以自动运行，但实际部署到生产将需要点击。

You can do this straight from the pipeline graph. Just click on the play button
to execute that particular job. For example, in the image below, the `production`
stage has a job with a manual action.

你可以直接从管道图中做到这一点。 只需点击play按钮执行该特定的工作。 例如，在下图中，生产阶段有一个工作是手动操作。

![Pipelines example](img/pipelines.png)

### Ordering of jobs in pipeline graphs

**Regular pipeline graph** 常规管道图

In the single pipeline page, jobs are sorted by name.
在该单个管道页面，工作是以名字排序的。

**Mini pipeline graph** 迷你管道图

> [Introduced][ce-9760] in GitLab 9.0. GitLab 9.0引入的

In the pipeline mini graphs, the jobs are sorted first by severity and then
by name. The order of severity is:
在改迷你管道图中，工作首先以中严重性排序，次序是名字。严重性的顺序如下

- failed
- warning
- pending
- running
- manual
- canceled
- success
- skipped
- created

![Pipeline mini graph sorting](img/pipelines_mini_graph_sorting.png)

## How the pipeline duration is calculated--如何计算管道持续时间

Total running time for a given pipeline would exclude retries and pending
(queue) time. We could reduce this problem down to finding the union of
periods.

给定管道的总运行时间将排除重试和待处理（队列）时间。 我们可以把这个问题缩小到寻找时期的联合。

So each job would be represented as a `Period`, which consists of
`Period#first` as when the job started and `Period#last` as when the
job was finished. A simple example here would be:

因此，每项工作都将被表示为一个周期，其中包括`Period#first`作为作业的开始，`Period#last`作为作业的完成。 一个简单的例子是：

* A (1, 3)
* B (2, 4)
* C (6, 7)

Here A begins from 1, and ends to 3. B begins from 2, and ends to 4.
C begins from 6, and ends to 7. Visually it could be viewed as:

这里A从1开始，结束到3. B从2开始，结束到4. C从6开始，结束到7.视觉上它可以被看作：

```
0  1  2  3  4  5  6  7
   AAAAAAA
      BBBBBBB
                  CCCC
```

The union of A, B, and C would be (1, 4) and (6, 7), therefore the
total running time should be:

A，B和C的联合将是（1,4）和（6,7），因此总的运行时间应该是：

```
(4 - 1) + (7 - 6) => 4
```

## Badges

Pipeline status and test coverage report badges are available. You can find their
respective link in the [Pipelines settings] page.

管道状态和测试范围报告徽章是可用的。 您可以在管道设置页面找到它们各自的链接。

## Security on protected branches--保护分支机构的安全

A strict security model is enforced when pipelines are executed on
[protected branches](../user/project/protected_branches.md).

在受保护的分支上执行管道时，将执行严格的安全模型。

The following actions are allowed on protected branches only if the user is
[allowed to merge or push](../user/project/protected_branches.md#using-the-allowed-to-merge-and-allowed-to-push-settings)
on that specific branch:

只有在允许用户合并或推送特定分支时，才允许在受保护的分支上执行以下操作：

- run **manual pipelines** (using Web UI or Pipelines API) 运行手工操作（使用Web UI或管道API）
- run **scheduled pipelines** 运行管道计划
- run pipelines using **triggers** 通过触发运行管道
- trigger **manual actions** on existing pipelines 在已存在的管道中触发手工操作
- **retry/cancel** existing jobs (using Web UI or Pipelines API) 重启或取消已存在作业

**Secret variables** marked as **protected** are accessible only to jobs that
run on protected branches, avoiding untrusted users to get unintended access to
sensitive information like deployment credentials and tokens.

标记为受保护的秘密变量仅能受保护分支上运行的作业访问，避免不受信任的用户无意中访问敏感信息，如部署凭证和令牌。

**Runners** marked as **protected** can run jobs only on protected
branches, avoiding untrusted code to be executed on the protected runner and
preserving deployment keys and other credentials from being unintentionally
accessed. In order to ensure that jobs intended to be executed on protected
runners will not use regular runners, they must be tagged accordingly.

标记为受保护的Runners只能在受保护的分支上运行作业，避免不受信任的代码在受保护的运行程序上执行，并保留部署密钥和其他凭据不被意外访问。 为了确保打算在受保护的runners上执行的工作不会使用常规runners，必须对其进行标记。

[jobs]: #jobs
[jobs-yaml]: yaml/README.md#jobs
[manual]: yaml/README.md#manual
[env-manual]: environments.md#manually-deploying-to-environments
[stages]: yaml/README.md#stages
[runners]: runners/README.html
[pipelines settings]: ../user/project/pipelines/settings.md
[triggers]: triggers/README.md
[ce-5742]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/5742
[ce-6242]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/6242
[ce-7931]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/7931
[ce-9760]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/9760
[regexp]: https://gitlab.com/gitlab-org/gitlab-ce/blob/2f3dc314f42dbd79813e6251792853bc231e69dd/app/models/commit_status.rb#L99
