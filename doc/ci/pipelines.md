# Introduction to pipelines and jobs--�ܵ���jobs�Ľ���

> Introduced in GitLab 8.8. ��GitLab 8.8����

## Pipelines

A pipeline is a group of [jobs][] that get executed in [stages][](batches).
All of the jobs in a stage are executed in parallel (if there are enough
concurrent [Runners]), and if they all succeed, the pipeline moves on to the
next stage. If one of the jobs fails, the next stage is not (usually)
executed. You can access the pipelines page in your project's **Pipelines** tab.

��ˮ�ߣ�pipeline����һ��׶Σ����Σ�ִ�е���ҵ�� ����ִ��һ���׶��е�������ҵ��������㹻�Ĳ������г��򣩣������������ȫ���ɹ�����ܵ��ƶ�����һ�׶Ρ� �������һ������ʧ�ܣ���һ�׶β���ͨ����ִ�С� �����Է�����Ŀ�ġ��ܵ���ѡ��еĹܵ�ҳ�档

In the following image you can see that the pipeline consists of four stages
(`build`, `test`, `staging`, `production`) each one having one or more jobs.

�������ͼƬ�У������Կ������ܵ������ĸ��׶Σ����������ԣ�Ԥ��������������ÿ���׶ζ���һ��������ҵ��

>**Note:**
GitLab capitalizes the stages' names when shown in the [pipeline graphs](#pipeline-graphs).

ע�⣺GitLab����ˮ��ͼ����ʾ��ʱ��ʹ�ô�д�����֡�

![Pipelines example](img/pipelines.png)

## Types of pipelines

There are three types of pipelines that often use the single shorthand of "pipeline". People often talk about them as if each one is "the" pipeline, but really, they're just pieces of a single, comprehensive pipeline.

���������͵Ĺܵ�����ʹ�á��ܵ����ĵ�һ�ټǡ� ���Ǿ���̸�����ǣ�����ÿ���˶��ǡ��ܵ�������ʵ���ϣ�����ֻ��һ����һ���ۺϹܵ���


![Types of Pipelines](img/types-of-pipelines.svg)


1. **CI Pipeline**: Build and test stages defined in `.gitlab-ci.yml`--��.gitlab-ci.yml�ж���Ĺ����Ͳ��Խ׶�
2. **Deploy Pipeline**: Deploy stage(s) defined in `.gitlab-ci.yml` The flow of deploying code to servers through various stages: e.g. development to staging to production��������.gitlab-ci.yml�ж���Ľ׶�ͨ�������׶ν����벿�𵽷����������̣� development-> staging->production��
3. **Project Pipeline**: Cross-project CI dependencies [triggered via API][triggers], particularly for micro-services, but also for complicated build dependencies: e.g. api -> front-end, ce/ee -> omnibus.--ͨ��API�����Ŀ���ĿCI������ϵ���ر������΢����ģ�����Ը��ӵĹ���������ϵ�� api -> front-end, ce/ee -> omnibus��

## Development workflows--��������

Pipelines accommodate several development workflows:
�ܵ���Ӧ���ֿ����������̣�


1. **Branch Flow** (e.g. different branch for dev, qa, staging, production)--��֧��������dev��qa�����ڣ������Ĳ�ͬ��֧��
2. **Trunk-based Flow** (e.g. feature branches and single master branch, possibly with tags for releases)--����trunk�����̣����磬���ܷ�֧�͵�������֧�����ܴ��з��б�ǩ��
3. **Fork-based Flow** (e.g. merge requests come from forks)--�磺����forks�ĺϲ�����

Example continuous delivery flow:
��ʾ�����������̣�


![CD Flow](img/pipelines-goal.svg)

## Jobs

Jobs can be defined in the [`.gitlab-ci.yml`][jobs-yaml] file. Not to be
confused with a `build` job or `build` stage.

��ҵ������.gitlab-ci.yml�ļ��ж��塣 ��Ҫ�빹��job�򹹼�stage������

## Defining pipelines--����pilelines

Pipelines are defined in `.gitlab-ci.yml` by specifying [jobs] that run in
[stages].

�ܵ�����.gitlab-ci.yml�ж��壬ͨ���ڷֽ׶Σ�stages��ָ�����е���ҵ��jobs����

See the reference [documentation for jobs](yaml/README.md#jobs).

�й���ҵ������Ĳο��ĵ���

## Seeing pipeline status--�鿴pipeline״̬

You can find the current and historical pipeline runs under your project's
**Pipelines** tab. Clicking on a pipeline will show the jobs that were run for
that pipeline.

����������Ŀ�ġ��ܵ���ѡ����ҵ���ǰ����ʷ�ܵ����м�¼�� ����ܵ�����ʾΪ�ùܵ����е���ҵ��

![Pipelines index page](img/pipelines_index.png)

## Seeing job status--�鿴job��״̬

When you visit a single pipeline you can see the related jobs for that pipeline.
Clicking on an individual job will show you its job trace, and allow you to
cancel the job, retry it, or erase the job trace.

�������ʵ����ܵ�ʱ�������Կ����ùܵ��������ҵ�� ���������ҵ����ʾ����ҵ���٣���������ȡ����ҵ��������ҵ�������ҵ���١�

![Pipelines example](img/pipelines.png)

## Pipeline graphs--Pipelineͼ

> [Introduced][ce-5742] in GitLab 8.11.
��GtiLab 8.11����

Pipelines can be complex structures with many sequential and parallel jobs.
To make it a little easier to see what is going on, you can view a graph
of a single pipeline and its status.

��ˮ�߿����Ǹ��ӵĽṹ������������ԺͲ��еĹ����� Ϊ��ʹ�������׿���������ʲô�������Բ鿴�����ܵ���ͼ�μ���״̬��

A pipeline graph can be shown in two different ways depending on what page you
are on.

�ܵ�ͼ���������ֲ�ͬ�ķ�ʽ��ʾ������ȡ���������ĸ�ҳ���ϡ�

---

The regular pipeline graph that shows the names of the jobs of each stage can
be found when you are on a [single pipeline page](#seeing-pipeline-status).

����ܵ�ͼ�����ڵ����ܵ�ҳ�����ҵ�����ʾÿ���׶���ҵ���ơ�


![Pipelines example](img/pipelines.png)

Then, there is the pipeline mini graph which takes less space and can give you a
quick glance if all jobs pass or something failed. The pipeline mini graph can
be found when you visit:

Ȼ���йܵ�����ͼ��ռ�ø��ٵĿռ䣬������еĹ�����ͨ����ʧ�ܣ����Կ������һ�¡� �ܵ�����ͼ������������ʱ�ҵ���

- the pipelines index page--pileilines����ҳ��
- a single commit page--�����ύҳ��
- a merge request page--�ϲ�����ҳ��

That way, you can see all related jobs for a single commit and the net result
of each stage of your pipeline. This allows you to quickly see what failed and
fix it. Stages in pipeline mini graphs are collapsible. Hover your mouse over
them and click to expand their jobs.

���������Ϳ��Կ��������ύ��������ص���ҵ�Լ�pipelineÿ���׶ε����ս���� ��ʹ�����Կ��ٲ鿴ʧ�ܲ��޸����� �ܵ�����ͼ�Ľ׶��ǿ��۵��ġ� �������ͣ�����棬Ȼ�󵥻���չ������ҵ��


| **Mini graph** | **Mini graph expanded** |
| :------------: | :---------------------: |
| ![Pipelines mini graph](img/pipelines_mini_graph_simple.png) | ![Pipelines mini graph extended](img/pipelines_mini_graph.png) |

### Grouping similar jobs in the pipeline graph �ڹܵ�ͼ�з������Ƶ���ҵ

> [Introduced][ce-6242] in GitLab 8.12.

If you have many similar jobs, your pipeline graph becomes very long and hard
to read. For that reason, similar jobs can automatically be grouped together.
If the job names are formatted in certain ways, they will be collapsed into
a single group in regular pipeline graphs (not the mini graphs).
You'll know when a pipeline has grouped jobs if you don't see the retry or
cancel button inside them. Hovering over them will show the number of grouped
jobs. Click to expand them.

������кܶ����ƵĹ�������Ĺܵ�ͼ��úܳ��������Ķ��� �������ԭ�����ƵĹ��������Զ�������һ�� �����ҵ��������ĳ�ָ�ʽ�����ģ������ǽ��ڳ������ͼ������������ͼ�����۵�Ϊһ���顣 �����û�������п������Ի�ȡ����ť�����֪���ܵ���ʱ����ҵ���顣 �������ͣ���������ʾ������ҵ�������� ���չ�����ǡ�

![Grouped pipelines](img/pipelines_grouped.png)

The basic requirements is that there are two numbers separated with one of
the following (you can even use them interchangeably):

������Ҫ���������������������һ���ֿ������������Ի���ʹ�ã���

- a space�ո�
- a backslash (`/`)б��
- a colon (`:`)ð��

>**Note:**
More specifically, [it uses][regexp] this regular expression: `\d+[\s:\/\\]+\d+\s*`.

ע�⣺�������˵����ʹ�����������ʽ��`\d+[\s:\/\\]+\d+\s*`��

The jobs will be ordered by comparing those two numbers from left to right. You
usually want the first to be the index and the second the total.

������ͨ�������ұȽ����������ֽ������� ��ͨ��ϣ����һ�����������ڶ�����������

For example, the following jobs will be grouped under a job named `test`:
���磬������ҵ������������Ϊtest����ҵ�£�

- `test 0 3` => `test`
- `test 1 3` => `test`
- `test 2 3` => `test`

The following jobs will be grouped under a job named `test ruby`:
������ҵ����������һ����Ϊtest ruby����ҵ�£�

- `test 1:2 ruby` => `test ruby`
- `test 2:2 ruby` => `test ruby`

The following jobs will be grouped under a job named `test ruby` as well:
������ҵҲ����������һ����Ϊtest ruby����ҵ�£�

- `1/3 test ruby` => `test ruby`
- `2/3 test ruby` => `test ruby`
- `3/3 test ruby` => `test ruby`

### Manual actions from the pipeline graph--�ܵ�ͼ���ֹ�����

> [Introduced][ce-7931] in GitLab 8.15.

[Manual actions][manual] allow you to require manual interaction before moving
forward with a particular job in CI. Your entire pipeline can run automatically,
but the actual [deploy to production][env-manual] will require a click.

�ֶ������������ڼ���ʹ��CI�е��ض���ҵ֮ǰҪ���ֶ������� ���������ܵ������Զ����У���ʵ�ʲ�����������Ҫ�����

You can do this straight from the pipeline graph. Just click on the play button
to execute that particular job. For example, in the image below, the `production`
stage has a job with a manual action.

�����ֱ�Ӵӹܵ�ͼ��������һ�㡣 ֻ����play��ťִ�и��ض��Ĺ����� ���磬����ͼ�У������׶���һ���������ֶ�������

![Pipelines example](img/pipelines.png)

### Ordering of jobs in pipeline graphs

**Regular pipeline graph** ����ܵ�ͼ

In the single pipeline page, jobs are sorted by name.
�ڸõ����ܵ�ҳ�棬����������������ġ�

**Mini pipeline graph** ����ܵ�ͼ

> [Introduced][ce-9760] in GitLab 9.0. GitLab 9.0�����

In the pipeline mini graphs, the jobs are sorted first by severity and then
by name. The order of severity is:
�ڸ�����ܵ�ͼ�У����������������������򣬴��������֡������Ե�˳������

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

## How the pipeline duration is calculated--��μ���ܵ�����ʱ��

Total running time for a given pipeline would exclude retries and pending
(queue) time. We could reduce this problem down to finding the union of
periods.

�����ܵ���������ʱ�佫�ų����Ժʹ��������У�ʱ�䡣 ���ǿ��԰����������С��Ѱ��ʱ�ڵ����ϡ�

So each job would be represented as a `Period`, which consists of
`Period#first` as when the job started and `Period#last` as when the
job was finished. A simple example here would be:

��ˣ�ÿ�����������ʾΪһ�����ڣ����а���`Period#first`��Ϊ��ҵ�Ŀ�ʼ��`Period#last`��Ϊ��ҵ����ɡ� һ���򵥵������ǣ�

* A (1, 3)
* B (2, 4)
* C (6, 7)

Here A begins from 1, and ends to 3. B begins from 2, and ends to 4.
C begins from 6, and ends to 7. Visually it could be viewed as:

����A��1��ʼ��������3. B��2��ʼ��������4. C��6��ʼ��������7.�Ӿ��������Ա�������

```
0  1  2  3  4  5  6  7
   AAAAAAA
      BBBBBBB
                  CCCC
```

The union of A, B, and C would be (1, 4) and (6, 7), therefore the
total running time should be:

A��B��C�����Ͻ��ǣ�1,4���ͣ�6,7��������ܵ�����ʱ��Ӧ���ǣ�

```
(4 - 1) + (7 - 6) => 4
```

## Badges

Pipeline status and test coverage report badges are available. You can find their
respective link in the [Pipelines settings] page.

�ܵ�״̬�Ͳ��Է�Χ��������ǿ��õġ� �������ڹܵ�����ҳ���ҵ����Ǹ��Ե����ӡ�

## Security on protected branches--������֧�����İ�ȫ

A strict security model is enforced when pipelines are executed on
[protected branches](../user/project/protected_branches.md).

���ܱ����ķ�֧��ִ�йܵ�ʱ����ִ���ϸ�İ�ȫģ�͡�

The following actions are allowed on protected branches only if the user is
[allowed to merge or push](../user/project/protected_branches.md#using-the-allowed-to-merge-and-allowed-to-push-settings)
on that specific branch:

ֻ���������û��ϲ��������ض���֧ʱ�����������ܱ����ķ�֧��ִ�����²�����

- run **manual pipelines** (using Web UI or Pipelines API) �����ֹ�������ʹ��Web UI��ܵ�API��
- run **scheduled pipelines** ���йܵ��ƻ�
- run pipelines using **triggers** ͨ���������йܵ�
- trigger **manual actions** on existing pipelines ���Ѵ��ڵĹܵ��д����ֹ�����
- **retry/cancel** existing jobs (using Web UI or Pipelines API) ������ȡ���Ѵ�����ҵ

**Secret variables** marked as **protected** are accessible only to jobs that
run on protected branches, avoiding untrusted users to get unintended access to
sensitive information like deployment credentials and tokens.

���Ϊ�ܱ��������ܱ��������ܱ�����֧�����е���ҵ���ʣ����ⲻ�����ε��û������з���������Ϣ���粿��ƾ֤�����ơ�

**Runners** marked as **protected** can run jobs only on protected
branches, avoiding untrusted code to be executed on the protected runner and
preserving deployment keys and other credentials from being unintentionally
accessed. In order to ensure that jobs intended to be executed on protected
runners will not use regular runners, they must be tagged accordingly.

���Ϊ�ܱ�����Runnersֻ�����ܱ����ķ�֧��������ҵ�����ⲻ�����εĴ������ܱ��������г�����ִ�У�������������Կ������ƾ�ݲ���������ʡ� Ϊ��ȷ���������ܱ�����runners��ִ�еĹ�������ʹ�ó���runners�����������б�ǡ�

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
