# Configuration of your jobs with .gitlab-ci.yml 使用.gitlab-ci.yml配置你的作业

This document describes the usage of `.gitlab-ci.yml`, the file that is used by
GitLab Runner to manage your project's jobs.
本文档描述了.gitlab-ci.yml的使用，GitLab Runner使用该文件管理项目的作业。

If you want a quick introduction to GitLab CI, follow our
[quick start guide](../quick_start/README.md).
如果您想快速了解GitLab CI，请参阅我们的快速入门指南。

## .gitlab-ci.yml

From version 7.12, GitLab CI uses a [YAML](https://en.wikipedia.org/wiki/YAML)
file (`.gitlab-ci.yml`) for the project configuration. It is placed in the root
of your repository and contains definitions of how your project should be built.
从版本7.12开始，GitLab CI使用YAML文件（.gitlab-ci.yml）作为项目配置。 它被放置在你的仓库的根目录，并包含你的项目应该如何构建的定义。

The YAML file defines a set of jobs with constraints stating when they should
be run. The jobs are defined as top-level elements with a name and always have
to contain at least the `script` clause:
YAML文件定义了一系列约束条件的作业，说明它们应该在何时运行。 作业被定义为具有名称的顶层元素，并且始终必须至少包含`script`子句：

```yaml
job1:
  script: "execute-script-for-job1"

job2:
  script: "execute-script-for-job2"
```

The above example is the simplest possible CI configuration with two separate
jobs, where each of the jobs executes a different command.
以上示例是具有两个独立作业的最简单的CI配置，其中每个作业执行不同的命令。

Of course a command can execute code directly (`./configure;make;make install`)
or run a script (`test.sh`) in the repository.
当然，一个命令可以直接执行代码（./configure;make; make install）或者运行一个脚本（test.sh）到仓库中。

Jobs are picked up by [Runners](../runners/README.md) and executed within the
environment of the Runner. What is important, is that each job is run
independently from each other.
作业是由runner拿起并在runner的环境下执行的。 重要的是，每项工作都是相互独立的。

The YAML syntax allows for using more complex job specifications than in the
above example:
YAML语法允许使用比上例更复杂的作业规范：

```yaml
image: ruby:2.1
services:
  - postgres

before_script:
  - bundle install

after_script:
  - rm secrets

stages:
  - build
  - test
  - deploy

job1:
  stage: build
  script:
    - execute-script-for-job1
  only:
    - master
  tags:
    - docker
```

There are a few reserved `keywords` that **cannot** be used as job names:
有几个保留的关键字不能用作作业名称：


| Keyword       | Required | Description |
|---------------|----------|-------------|
| image         | no | Use docker image, covered in [Use Docker](../docker/README.md)使用Docker镜像，可查看链接中的docker使用部分 |
| services      | no | Use docker services, covered in [Use Docker](../docker/README.md)使用Docker服务，可查看链接中的docker使用部分 |
| stages        | no | Define build stages 定义构建阶段 |
| types         | no | Alias for `stages` (deprecated)`stages`的别称（已启用） |
| before_script | no | Define commands that run before each job's script 用于定义运行每个作业脚本前要执行的命令 |
| after_script  | no | Define commands that run after each job's script 用于定义运行每个作业脚本后要执行的命令 |
| variables     | no | Define build variables 定义构建变量 |
| cache         | no | Define list of files that should be cached between subsequent runs 定义应在后续运行之间进行缓存的文件列表 |

### image and services 镜像与服务

This allows to specify a custom Docker image and a list of services that can be
used for time of the job. The configuration of this feature is covered in
[a separate document](../docker/README.md).
这允许指定一个自定义的Docker镜像和一个可用于作业时间的服务列表。 该功能的配置在链接的文档中单独进行了介绍。

### before_script

`before_script` is used to define the command that should be run before all
jobs, including deploy jobs, but after the restoration of artifacts. This can
be an array or a multi-line string.
before_script用于定义在所有作业（包括部署作业）之前应该运行的命令，但是在恢复工件之后。 这可以是一个数组或一个多行字符串。

### after_script

> Introduced in GitLab 8.7 and requires Gitlab Runner v1.2 在GitLab 8.7中引入，需要Gitlab Runner v1.2

`after_script` is used to define the command that will be run after for all
jobs. This has to be an array or a multi-line string.
after_script用于定义将在所有作业之后运行的命令。 这必须是一个数组或一个多行字符串。

> **Note:**
The `before_script` and the main `script` are concatenated and run in a single context/container.
The `after_script` is run separately, so depending on the executor, changes done
outside of the working tree might not be visible, e.g. software installed in the
`before_script`.
before_script和主`script`是连接在一起的，只能在一个上下文/容器中运行。 after_script是分开运行的，所以根据执行者（executor）的不同，在工作树之外完成的改变可能是不可见的。 例如，软件安装在before_script中。

### stages 阶段

`stages` is used to define stages that can be used by jobs.
The specification of `stages` allows for having flexible multi stage pipelines.
`stages`被用来定义可以被作业使用的阶段。`stages`的规格允许具有灵活的多级管线。

The ordering of elements in `stages` defines the ordering of jobs' execution:
`stages`元素的排序定义了作业执行的顺序：

1. Jobs of the same stage are run in parallel. 同一阶段的工作是并行的。
1. Jobs of the next stage are run after the jobs from the previous stage
   complete successfully.下一阶段的工作是在上一阶段的工作顺利完成之后运行的。


Let's consider the following example, which defines 3 stages:
我们来看下面的例子，它定义了3个阶段：

```yaml
stages:
  - build
  - test
  - deploy
```

1. First, all jobs of `build` are executed in parallel. 首先，构建阶段的所有作业都是并行执行的。
1. If all jobs of `build` succeed, the `test` jobs are executed in parallel. 如果构建阶段的所有作业都成功，则测试阶段的作业将并行执行。
1. If all jobs of `test` succeed, the `deploy` jobs are executed in parallel. 如果所有测试阶段的作业都成功，则并行执行部署阶段的作业。
1. If all jobs of `deploy` succeed, the commit is marked as `passed`.如果所有部署阶段的作业成功，则该提交被标记为已通过（`passed`）。
1. If any of the previous jobs fails, the commit is marked as `failed` and no
   jobs of further stage are executed. 如果之前的任务失败，则提交被标记为失败，并且不执行进一步阶段的任务。

There are also two edge cases worth mentioning:
还有两个边缘案例值得一提：

1. If no `stages` are defined in `.gitlab-ci.yml`, then the `build`,
   `test` and `deploy` are allowed to be used as job's stage by default.如果在.gitlab-ci.yml中没有定义阶段，那么默认允许`build`,
   `test` 和 `deploy`作为作业的阶段。

2. If a job doesn't specify a `stage`, the job is assigned the `test` stage. 如果一个工作没有指定一个阶段，那么这个工作被分配到测试`test`阶段。

### types 类型（已弃用，请使用stages）

> Deprecated, and could be removed in one of the future releases. Use [stages](#stages) instead. 

Alias for [stages](#stages).

### variables 变量

> Introduced in GitLab Runner v0.5.0. 在GitLab Runner v0.5.0中引入。

GitLab CI allows you to add variables to `.gitlab-ci.yml` that are set in the
job environment. The variables are stored in the Git repository and are meant
to store non-sensitive project configuration, for example:
GitLab CI允许您将变量添加到.gitlab-ci.yml中，用于设置作业的环境变量。 这些变量存储在Git仓库中，用于存储非敏感的项目配置，例如：
设置数据库url变量：
```yaml
variables:
  DATABASE_URL: "postgres://postgres@postgres/my_database"
```

>**Note:**
Integers (as well as strings) are legal both for variable's name and value.
Floats are not legal and cannot be used.注意：整数（以及字符串）对变量的名称和值都是合法的。 浮点数是不合法的，不能使用。


These variables can be later used in all executed commands and scripts.
The YAML-defined variables are also set to all created service containers,
thus allowing to fine tune them. Variables can be also defined on a
[job level](#job-variables).
这些变量稍后可以在所有执行的命令和脚本（script）中使用。 YAML定义的变量也被设置为所有创建的服务容器，从而允许对其进行微调。 变量也可以在作业级别上定义。

Except for the user defined variables, there are also the ones set up by the
Runner itself. One example would be `CI_COMMIT_REF_NAME` which has the value of
the branch or tag name for which project is built. Apart from the variables
you can set in `.gitlab-ci.yml`, there are also the so called secret variables
which can be set in GitLab's UI.
除了用户定义的变量外，还有由Runner自己设置的变量。 一个例子是CI_COMMIT_REF_NAME，它具有为其构建项目的分支或标签名称的值。 除了可以在.gitlab-ci.yml中设置的变量之外，还可以在GitLab的用户界面中设置所谓的秘密变量。

[Learn more about variables.][variables] 关于变量的更多知识，请查看链接。

### cache -缓存

>
**Notes:**
- Introduced in GitLab Runner v0.7.0. 在GitLab Runner v0.7.0中引入。
- Prior to GitLab 9.2, caches were restored after artifacts. 在GitLab 9.2之前，缓存在工件之后被恢复。
- From GitLab 9.2, caches are restored before artifacts. 在GitLab 9.2中，缓存在工件之前被恢复。

`cache` is used to specify a list of files and directories which should be
cached between jobs. You can only use paths that are within the project
workspace.
`cache`（缓存）用于指定应在作业之间缓存的文件和目录的列表。 您只能使用项目工作区内的路径。

**By default caching is enabled and shared between pipelines and jobs,
starting from GitLab 9.0** 默认情况下，从GitLab 9.0开始，在管道和作业之间启用和共享缓存

If `cache` is defined outside the scope of jobs, it means it is set
globally and all jobs will use that definition.
如果缓存是在作业范围之外定义的，则表示它是全局设置的，所有作业将使用该定义。

Cache all files in `binaries` and `.config`:
缓存binaries/的文件和.config文件：

```yaml
rspec:
  script: test
  cache:
    paths:
    - binaries/
    - .config
```

Cache all Git untracked files:
缓存所有Git未跟踪文件：

```yaml
rspec:
  script: test
  cache:
    untracked: true
```

Cache all Git untracked files and files in `binaries`:
缓存所有Git未跟踪的文件和在binaries/中的文件：

```yaml
rspec:
  script: test
  cache:
    untracked: true
    paths:
    - binaries/
```

Locally defined cache overrides globally defined options. The following `rspec`
job will cache only `binaries/`:
本地定义的缓存将覆盖全局定义的选项。 以下rspec作业只会缓存binaries/的文件：

```yaml
cache:
  paths:
  - my/files

rspec:
  script: test
  cache:
    key: rspec
    paths:
    - binaries/
```

Note that since cache is shared between jobs, if you're using different
paths for different jobs, you should also set a different **cache:key**
otherwise cache content can be overwritten.请注意，由于缓存是在作业之间共享的，如果您为不同的作业使用不同的路径，则还应该设置不同的**cache:key**，否则可能会覆盖缓存内容。

The cache is provided on a best-effort basis, so don't expect that the cache
will be always present. For implementation details, please check GitLab Runner.
缓存是尽力而为的，所以不要指望缓存会一直存在。 有关实现细节，请检查GitLab Runner。

#### cache:key

> Introduced in GitLab Runner v1.0.0.在GitLab Runner v1.0.0中引入。

The `key` directive allows you to define the affinity of caching
between jobs, allowing to have a single cache for all jobs,
cache per-job, cache per-branch or any other way you deem proper.
key指令允许您定义作业之间的缓存关系，允许为所有作业提供单个缓存、单个作业缓存，单个分支缓存或任何其他您认为合适的方式。


This allows you to fine tune caching, allowing you to cache data between
different jobs or even different branches.
这使您可以微调缓存，允许您在不同的作业甚至不同的分支之间缓存数据。

The `cache:key` variable can use any of the [predefined variables](../variables/README.md).
cache：key变量可以使用任何预定义的变量。

The default key is **default** across the project, therefore everything is
shared between each pipelines and jobs by default, starting from GitLab 9.0.
默认的key是整个项目的**default**，因此默认情况下，每个管道和作业之间的所有内容都是共享的，从GitLab 9.0开始。

>**Note:** The `cache:key` variable cannot contain the `/` character. 注意：cache：key变量不能包含/字符。


---

**Example configurations** 例子

To enable per-job caching: 为每个作业启动cache

```yaml
cache:
  key: "$CI_JOB_NAME"
  untracked: true
```

To enable per-branch caching: 启动每个分支缓存：

```yaml
cache:
  key: "$CI_COMMIT_REF_NAME"
  untracked: true
```

To enable per-job and per-branch caching: 启动作业缓存和分支缓存：

```yaml
cache:
  key: "$CI_JOB_NAME-$CI_COMMIT_REF_NAME"
  untracked: true
```

To enable per-branch and per-stage caching: 弃用分支缓存和阶段缓存

```yaml
cache:
  key: "$CI_JOB_STAGE-$CI_COMMIT_REF_NAME"
  untracked: true
```

If you use **Windows Batch** to run your shell scripts you need to replace
`$` with `%`:
如果你使用Windows Batch来运行你的shell脚本，你需要用％替换$：

```yaml
cache:
  key: "%CI_JOB_STAGE%-%CI_COMMIT_REF_NAME%"
  untracked: true
```

If you use **Windows PowerShell** to run your shell scripts you need to replace
`$` with `$env:`:
如果您使用Windows PowerShell运行您的shell脚本，则需要使用`$env:`替换$:

```yaml
cache:
  key: "$env:CI_JOB_STAGE-$env:CI_COMMIT_REF_NAME"
  untracked: true
```

### cache:policy

> Introduced in GitLab 9.4.在GitLab 9.4中引入。

The default behaviour of a caching job is to download the files at the start of
execution, and to re-upload them at the end. This allows any changes made by the
job to be persisted for future runs, and is known as the `pull-push` cache
policy.
作业缓存的默认行为是在开始执行时下载文件，并在最后重新上传文件。 这使得作业所做的任何更改都可以保留以供将来运行，并称为`pull-push`缓存策略。


If you know the job doesn't alter the cached files, you can skip the upload step
by setting `policy: pull` in the job specification. Typically, this would be
twinned with an ordinary cache job at an earlier stage to ensure the cache
is updated from time to time:

如果您知道作业不会更改缓存的文件，则可以通过在作业规范设置`policy: pull`来跳过上载步骤。 通常情况下，这将与较早阶段的普通缓存作业相结合，以确保缓存不时更新：

```yaml
stages:
  - setup
  - test

prepare:
  stage: setup
  cache:
    key: gems
    paths:
      - vendor/bundle
  script:
    - bundle install --deployment

rspec:
  stage: test
  cache:
    key: gems
    paths:
      - vendor/bundle
    policy: pull
  script:
    - bundle exec rspec ...
```

This helps to speed up job execution and reduce load on the cache server,
especially when you have a large number of cache-using jobs executing in
parallel.
这有助于加快作业执行并减少缓存服务器上的负载，特别是当您有大量并行执行的缓存使用作业时。

Additionally, if you have a job that unconditionally recreates the cache without
reference to its previous contents, you can use `policy: push` in that job to
skip the download step.
另外，如果您的作业无条件地重新创建缓存而不参考其以前的内容，则可以使用policy：push作为跳过下载步骤。

## Jobs 作业

`.gitlab-ci.yml` allows you to specify an unlimited number of jobs. Each job
must have a unique name, which is not one of the keywords mentioned above.
A job is defined by a list of parameters that define the job behavior.

.gitlab-ci.yml允许您指定无限数量的作业。 每个工作必须有一个独特的名字，这不是上面提到的关键字之一。 作业由定义作业行为的参数列表定义。

```yaml
job_name:
  script:
    - rake spec
    - coverage
  stage: test
  only:
    - master
  except:
    - develop
  tags:
    - ruby
    - postgres
  allow_failure: true
```

| Keyword       | Required | Description |
|---------------|----------|-------------|
| script        | yes      | Defines a shell script which is executed by Runner |
| image         | no       | Use docker image, covered in [Using Docker Images](../docker/using_docker_images.md#define-image-and-services-from-gitlab-ciyml) |
| services      | no       | Use docker services, covered in [Using Docker Images](../docker/using_docker_images.md#define-image-and-services-from-gitlab-ciyml) |
| stage         | no       | Defines a job stage (default: `test`) |
| type          | no       | Alias for `stage` |
| variables     | no       | Define job variables on a job level |
| only          | no       | Defines a list of git refs for which job is created |
| except        | no       | Defines a list of git refs for which job is not created |
| tags          | no       | Defines a list of tags which are used to select Runner |
| allow_failure | no       | Allow job to fail. Failed job doesn't contribute to commit status |
| when          | no       | Define when to run job. Can be `on_success`, `on_failure`, `always` or `manual` |
| dependencies  | no       | Define other jobs that a job depends on so that you can pass artifacts between them|
| artifacts     | no       | Define list of [job artifacts](../../user/project/pipelines/job_artifacts.md) |
| cache         | no       | Define list of files that should be cached between subsequent runs |
| before_script | no       | Override a set of commands that are executed before job |
| after_script  | no       | Override a set of commands that are executed after job |
| environment   | no       | Defines a name of environment to which deployment is done by this job |
| coverage      | no       | Define code coverage settings for a given job |
| retry         | no       | Define how many times a job can be auto-retried in case of a failure |

### script

`script` is a shell script which is executed by the Runner. For example:
`script`是一个由Runner执行的shell脚本。 例如：

```yaml
job:
  script: "bundle exec rspec"
```

This parameter can also contain several commands using an array:
这个参数也可以包含几个使用数组的命令：

```yaml
job:
  script:
    - uname -a
    - bundle exec rspec
```

Sometimes, `script` commands will need to be wrapped in single or double quotes.
For example, commands that contain a colon (`:`) need to be wrapped in quotes so
that the YAML parser knows to interpret the whole thing as a string rather than
a "key: value" pair. Be careful when using special characters:
`:`, `{`, `}`, `[`, `]`, `,`, `&`, `*`, `#`, `?`, `|`, `-`, `<`, `>`, `=`, `!`, `%`, `@`, `` ` ``.

### stage

`stage` allows to group jobs into different stages. Jobs of the same `stage`
are executed in `parallel`. For more info about the use of `stage` please check
[stages](#stages).

### only and except (simplified)

`only` and `except` are two parameters that set a job policy to limit when
jobs are created:

1. `only` defines the names of branches and tags for which the job will run.
2. `except` defines the names of branches and tags for which the job will
    **not** run.

There are a few rules that apply to the usage of job policy:

* `only` and `except` are inclusive. If both `only` and `except` are defined
   in a job specification, the ref is filtered by `only` and `except`.
* `only` and `except` allow the use of regular expressions.
* `only` and `except` allow to specify a repository path to filter jobs for
   forks.

In addition, `only` and `except` allow the use of special keywords:

| **Value** |  **Description**  |
| --------- |  ---------------- |
| `branches`  | When a branch is pushed.  |
| `tags`      | When a tag is pushed.  |
| `api`       | When pipeline has been triggered by a second pipelines API (not triggers API).  |
| `external`  | When using CI services other than GitLab. |
| `pipelines` | For multi-project triggers, created using the API with `CI_JOB_TOKEN`. |
| `pushes`    | Pipeline is triggered by a `git push` by the user. |
| `schedules` | For [scheduled pipelines][schedules]. |
| `triggers`  | For pipelines created using a trigger token. |
| `web`       | For pipelines created using **Run pipeline** button in GitLab UI (under your project's **Pipelines**). |

In the example below, `job` will run only for refs that start with `issue-`,
whereas all branches will be skipped:

```yaml
job:
  # use regexp
  only:
    - /^issue-.*$/
  # use special keyword
  except:
    - branches
```

In this example, `job` will run only for refs that are tagged, or if a build is
explicitly requested via an API trigger or a [Pipeline Schedule][schedules]:

```yaml
job:
  # use special keywords
  only:
    - tags
    - triggers
    - schedules
```

The repository path can be used to have jobs executed only for the parent
repository and not forks:

```yaml
job:
  only:
    - branches@gitlab-org/gitlab-ce
  except:
    - master@gitlab-org/gitlab-ce
```

The above example will run `job` for all branches on `gitlab-org/gitlab-ce`,
except master.

### only and except (complex)

> Introduced in GitLab 10.0

> This an _alpha_ feature, and it it subject to change at any time without
  prior notice!

Since GitLab 10.0 it is possible to define a more elaborate only/except job
policy configuration.

GitLab now supports both, simple and complex strategies, so it is possible to
use an array and a hash configuration scheme.

Two keys are now available: `refs` and `kubernetes`. Refs strategy equals to
simplified only/except configuration, whereas kubernetes strategy accepts only
`active` keyword.

See the example below. Job is going to be created only when pipeline has been
scheduled or runs for a `master` branch, and only if kubernetes service is
active in the project.

```yaml
job:
  only:
    refs:
      - master
      - schedules
    kubernetes: active
```

### Job variables

It is possible to define job variables using a `variables` keyword on a job
level. It works basically the same way as its [global-level equivalent](#variables),
but allows you to define job-specific variables.

When the `variables` keyword is used on a job level, it overrides the global YAML
job variables and predefined ones. To turn off global defined variables
in your job, define an empty hash:

```yaml
job_name:
  variables: {}
```

Job variables priority is defined in the [variables documentation][variables].

### tags

`tags` is used to select specific Runners from the list of all Runners that are
allowed to run this project.

During the registration of a Runner, you can specify the Runner's tags, for
example `ruby`, `postgres`, `development`.

`tags` allow you to run jobs with Runners that have the specified tags
assigned to them:

```yaml
job:
  tags:
    - ruby
    - postgres
```

The specification above, will make sure that `job` is built by a Runner that
has both `ruby` AND `postgres` tags defined.

### allow_failure

`allow_failure` is used when you want to allow a job to fail without impacting
the rest of the CI suite. Failed jobs don't contribute to the commit status.

When enabled and the job fails, the pipeline will be successful/green for all
intents and purposes, but a "CI build passed with warnings" message  will be
displayed on the merge request or commit or job page. This is to be used by
jobs that are allowed to fail, but where failure indicates some other (manual)
steps should be taken elsewhere.

In the example below, `job1` and `job2` will run in parallel, but if `job1`
fails, it will not stop the next stage from running, since it's marked with
`allow_failure: true`:

```yaml
job1:
  stage: test
  script:
  - execute_script_that_will_fail
  allow_failure: true

job2:
  stage: test
  script:
  - execute_script_that_will_succeed

job3:
  stage: deploy
  script:
  - deploy_to_staging
```

### when

`when` is used to implement jobs that are run in case of failure or despite the
failure.

`when` can be set to one of the following values:

1. `on_success` - execute job only when all jobs from prior stages
    succeed. This is the default.
1. `on_failure` - execute job only when at least one job from prior stages
    fails.
1. `always` - execute job regardless of the status of jobs from prior stages.
1. `manual` - execute job manually (added in GitLab 8.10). Read about
    [manual actions](#manual-actions) below.

For example:

```yaml
stages:
- build
- cleanup_build
- test
- deploy
- cleanup

build_job:
  stage: build
  script:
  - make build

cleanup_build_job:
  stage: cleanup_build
  script:
  - cleanup build when failed
  when: on_failure

test_job:
  stage: test
  script:
  - make test

deploy_job:
  stage: deploy
  script:
  - make deploy
  when: manual

cleanup_job:
  stage: cleanup
  script:
  - cleanup after jobs
  when: always
```

The above script will:

1. Execute `cleanup_build_job` only when `build_job` fails.
2. Always execute `cleanup_job` as the last step in pipeline regardless of
   success or failure.
3. Allow you to manually execute `deploy_job` from GitLab's UI.

#### Manual actions

> Introduced in GitLab 8.10.
> Blocking manual actions were introduced in GitLab 9.0
> Protected actions were introduced in GitLab 9.2

Manual actions are a special type of job that are not executed automatically;
they need to be explicitly started by a user. Manual actions can be started
from pipeline, build, environment, and deployment views.

An example usage of manual actions is deployment to production.

Read more at the [environments documentation][env-manual].

Manual actions can be either optional or blocking. Blocking manual action will
block execution of the pipeline at stage this action is defined in. It is
possible to resume execution of the pipeline when someone executes a blocking
manual actions by clicking a _play_ button.

When pipeline is blocked it will not be merged if Merge When Pipeline Succeeds
is set. Blocked pipelines also do have a special status, called _manual_.

Manual actions are non-blocking by default. If you want to make manual action
blocking, it is necessary to add `allow_failure: false` to the job's definition
in `.gitlab-ci.yml`.

Optional manual actions have `allow_failure: true` set by default.

**Statuses of optional actions do not contribute to overall pipeline status.**

**Manual actions are considered to be write actions, so permissions for
protected branches are used when user wants to trigger an action. In other
words, in order to trigger a manual action assigned to a branch that the
pipeline is running for, user needs to have ability to merge to this branch.**

### environment

>
**Notes:**
- Introduced in GitLab 8.9.
- You can read more about environments and find more examples in the
  [documentation about environments][environment].

`environment` is used to define that a job deploys to a specific environment.
If `environment` is specified and no environment under that name exists, a new
one will be created automatically.

In its simplest form, the `environment` keyword can be defined like:

```yaml
deploy to production:
  stage: deploy
  script: git push production HEAD:master
  environment:
    name: production
```

In the above example, the `deploy to production` job will be marked as doing a
deployment to the `production` environment.

#### environment:name

>
**Notes:**
- Introduced in GitLab 8.11.
- Before GitLab 8.11, the name of an environment could be defined as a string like
  `environment: production`. The recommended way now is to define it under the
  `name` keyword.
- The `name` parameter can use any of the defined CI variables,
  including predefined, secure variables and `.gitlab-ci.yml` [`variables`](#variables).
  You however cannot use variables defined under `script`.

The `environment` name can contain:

- letters
- digits
- spaces
- `-`
- `_`
- `/`
- `$`
- `{`
- `}`

Common names are `qa`, `staging`, and `production`, but you can use whatever
name works with your workflow.

Instead of defining the name of the environment right after the `environment`
keyword, it is also possible to define it as a separate value. For that, use
the `name` keyword under `environment`:

```yaml
deploy to production:
  stage: deploy
  script: git push production HEAD:master
  environment:
    name: production
```

#### environment:url

>
**Notes:**
- Introduced in GitLab 8.11.
- Before GitLab 8.11, the URL could be added only in GitLab's UI. The
  recommended way now is to define it in `.gitlab-ci.yml`.
- The `url` parameter can use any of the defined CI variables,
  including predefined, secure variables and `.gitlab-ci.yml` [`variables`](#variables).
  You however cannot use variables defined under `script`.

This is an optional value that when set, it exposes buttons in various places
in GitLab which when clicked take you to the defined URL.

In the example below, if the job finishes successfully, it will create buttons
in the merge requests and in the environments/deployments pages which will point
to `https://prod.example.com`.

```yaml
deploy to production:
  stage: deploy
  script: git push production HEAD:master
  environment:
    name: production
    url: https://prod.example.com
```

#### environment:on_stop

>
**Notes:**
- [Introduced][ce-6669] in GitLab 8.13.
- Starting with GitLab 8.14, when you have an environment that has a stop action
  defined, GitLab will automatically trigger a stop action when the associated
  branch is deleted.

Closing (stoping) environments can be achieved with the `on_stop` keyword defined under
`environment`. It declares a different job that runs in order to close
the environment.

Read the `environment:action` section for an example.

#### environment:action

> [Introduced][ce-6669] in GitLab 8.13.

The `action` keyword is to be used in conjunction with `on_stop` and is defined
in the job that is called to close the environment.

Take for instance:

```yaml
review_app:
  stage: deploy
  script: make deploy-app
  environment:
    name: review
    on_stop: stop_review_app

stop_review_app:
  stage: deploy
  script: make delete-app
  when: manual
  environment:
    name: review
    action: stop
```

In the above example we set up the `review_app` job to deploy to the `review`
environment, and we also defined a new `stop_review_app` job under `on_stop`.
Once the `review_app` job is successfully finished, it will trigger the
`stop_review_app` job based on what is defined under `when`. In this case we
set it up to `manual` so it will need a [manual action](#manual-actions) via
GitLab's web interface in order to run.

The `stop_review_app` job is **required** to have the following keywords defined:

- `when` - [reference](#when)
- `environment:name`
- `environment:action`
- `stage` should be the same as the `review_app` in order for the environment
  to stop automatically when the branch is deleted

#### dynamic environments

>
**Notes:**
- [Introduced][ce-6323] in GitLab 8.12 and GitLab Runner 1.6.
- The `$CI_ENVIRONMENT_SLUG` was [introduced][ce-7983] in GitLab 8.15.
- The `name` and `url` parameters can use any of the defined CI variables,
  including predefined, secure variables and `.gitlab-ci.yml` [`variables`](#variables).
  You however cannot use variables defined under `script`.

For example:

```yaml
deploy as review app:
  stage: deploy
  script: make deploy
  environment:
    name: review/$CI_COMMIT_REF_NAME
    url: https://$CI_ENVIRONMENT_SLUG.example.com/
```

The `deploy as review app` job will be marked as deployment to dynamically
create the `review/$CI_COMMIT_REF_NAME` environment, where `$CI_COMMIT_REF_NAME`
is an [environment variable][variables] set by the Runner. The
`$CI_ENVIRONMENT_SLUG` variable is based on the environment name, but suitable
for inclusion in URLs. In this case, if the `deploy as review app` job was run
in a branch named `pow`, this environment would be accessible with an URL like
`https://review-pow.example.com/`.

This of course implies that the underlying server which hosts the application
is properly configured.

The common use case is to create dynamic environments for branches and use them
as Review Apps. You can see a simple example using Review Apps at
<https://gitlab.com/gitlab-examples/review-apps-nginx/>.

### artifacts

>
**Notes:**
- Introduced in GitLab Runner v0.7.0 for non-Windows platforms.
- Windows support was added in GitLab Runner v.1.0.0.
- Prior to GitLab 9.2, caches were restored after artifacts.
- From GitLab 9.2, caches are restored before artifacts.
- Currently not all executors are supported.
- Job artifacts are only collected for successful jobs by default.

`artifacts` is used to specify a list of files and directories which should be
attached to the job after success. You can only use paths that are within the
project workspace. To pass artifacts between different jobs, see [dependencies](#dependencies).
Below are some examples.

Send all files in `binaries` and `.config`:

```yaml
artifacts:
  paths:
  - binaries/
  - .config
```

Send all Git untracked files:

```yaml
artifacts:
  untracked: true
```

Send all Git untracked files and files in `binaries`:

```yaml
artifacts:
  untracked: true
  paths:
  - binaries/
```

To disable artifact passing, define the job with empty [dependencies](#dependencies):

```yaml
job:
  stage: build
  script: make build
  dependencies: []
```

You may want to create artifacts only for tagged releases to avoid filling the
build server storage with temporary build artifacts.

Create artifacts only for tags (`default-job` will not create artifacts):

```yaml
default-job:
  script:
    - mvn test -U
  except:
    - tags

release-job:
  script:
    - mvn package -U
  artifacts:
    paths:
    - target/*.war
  only:
    - tags
```

The artifacts will be sent to GitLab after the job finishes successfully and will
be available for download in the GitLab UI.

#### artifacts:name

> Introduced in GitLab 8.6 and GitLab Runner v1.1.0.

The `name` directive allows you to define the name of the created artifacts
archive. That way, you can have a unique name for every archive which could be
useful when you'd like to download the archive from GitLab. The `artifacts:name`
variable can make use of any of the [predefined variables](../variables/README.md).
The default name is `artifacts`, which becomes `artifacts.zip` when downloaded.

---

**Example configurations**

To create an archive with a name of the current job:

```yaml
job:
  artifacts:
    name: "$CI_JOB_NAME"
```

To create an archive with a name of the current branch or tag including only
the files that are untracked by Git:

```yaml
job:
   artifacts:
     name: "$CI_COMMIT_REF_NAME"
     untracked: true
```

To create an archive with a name of the current job and the current branch or
tag including only the files that are untracked by Git:

```yaml
job:
  artifacts:
    name: "${CI_JOB_NAME}_${CI_COMMIT_REF_NAME}"
    untracked: true
```

To create an archive with a name of the current [stage](#stages) and branch name:

```yaml
job:
  artifacts:
    name: "${CI_JOB_STAGE}_${CI_COMMIT_REF_NAME}"
    untracked: true
```

---

If you use **Windows Batch** to run your shell scripts you need to replace
`$` with `%`:

```yaml
job:
  artifacts:
    name: "%CI_JOB_STAGE%_%CI_COMMIT_REF_NAME%"
    untracked: true
```

If you use **Windows PowerShell** to run your shell scripts you need to replace
`$` with `$env:`:

```yaml
job:
  artifacts:
    name: "$env:CI_JOB_STAGE_$env:CI_COMMIT_REF_NAME"
    untracked: true
```

#### artifacts:when

> Introduced in GitLab 8.9 and GitLab Runner v1.3.0.

`artifacts:when` is used to upload artifacts on job failure or despite the
failure.

`artifacts:when` can be set to one of the following values:

1. `on_success` - upload artifacts only when the job succeeds. This is the default.
1. `on_failure` - upload artifacts only when the job fails.
1. `always` - upload artifacts regardless of the job status.

---

**Example configurations**

To upload artifacts only when job fails.

```yaml
job:
  artifacts:
    when: on_failure
```

#### artifacts:expire_in

> Introduced in GitLab 8.9 and GitLab Runner v1.3.0.

`artifacts:expire_in` is used to delete uploaded artifacts after the specified
time. By default, artifacts are stored on GitLab forever. `expire_in` allows you
to specify how long artifacts should live before they expire, counting from the
time they are uploaded and stored on GitLab.

You can use the **Keep** button on the job page to override expiration and
keep artifacts forever.

After expiry, artifacts are actually deleted hourly by default (via a cron job),
but they are not accessible after expiry.

The value of `expire_in` is an elapsed time. Examples of parseable values:

- '3 mins 4 sec'
- '2 hrs 20 min'
- '2h20min'
- '6 mos 1 day'
- '47 yrs 6 mos and 4d'
- '3 weeks and 2 days'

---

**Example configurations**

To expire artifacts 1 week after being uploaded:

```yaml
job:
  artifacts:
    expire_in: 1 week
```

### dependencies

> Introduced in GitLab 8.6 and GitLab Runner v1.1.1.

This feature should be used in conjunction with [`artifacts`](#artifacts) and
allows you to define the artifacts to pass between different jobs.

Note that `artifacts` from all previous [stages](#stages) are passed by default.

To use this feature, define `dependencies` in context of the job and pass
a list of all previous jobs from which the artifacts should be downloaded.
You can only define jobs from stages that are executed before the current one.
An error will be shown if you define jobs from the current stage or next ones.
Defining an empty array will skip downloading any artifacts for that job.
The status of the previous job is not considered when using `dependencies`, so
if it failed or it is a manual job that was not run, no error occurs.

---

In the following example, we define two jobs with artifacts, `build:osx` and
`build:linux`. When the `test:osx` is executed, the artifacts from `build:osx`
will be downloaded and extracted in the context of the build. The same happens
for `test:linux` and artifacts from `build:linux`.

The job `deploy` will download artifacts from all previous jobs because of
the [stage](#stages) precedence:

```yaml
build:osx:
  stage: build
  script: make build:osx
  artifacts:
    paths:
    - binaries/

build:linux:
  stage: build
  script: make build:linux
  artifacts:
    paths:
    - binaries/

test:osx:
  stage: test
  script: make test:osx
  dependencies:
  - build:osx

test:linux:
  stage: test
  script: make test:linux
  dependencies:
  - build:linux

deploy:
  stage: deploy
  script: make deploy
```

### before_script and after_script

It's possible to overwrite the globally defined `before_script` and `after_script`:

```yaml
before_script:
- global before script

job:
  before_script:
  - execute this instead of global before script
  script:
  - my command
  after_script:
  - execute this after my script
```

### coverage

**Notes:**
- [Introduced][ce-7447] in GitLab 8.17.

`coverage` allows you to configure how code coverage will be extracted from the
job output.

Regular expressions are the only valid kind of value expected here. So, using
surrounding `/` is mandatory in order to consistently and explicitly represent
a regular expression string. You must escape special characters if you want to
match them literally.

A simple example:

```yaml
job1:
  script: rspec
  coverage: '/Code coverage: \d+\.\d+/'
```

### retry

**Notes:**
- [Introduced][ce-3442] in GitLab 9.5.

`retry` allows you to configure how many times a job is going to be retried in
case of a failure.

When a job fails, and has `retry` configured it is going to be processed again
up to the amount of times specified by the `retry` keyword.

If `retry` is set to 2, and a job succeeds in a second run (first retry), it won't be retried
again. `retry` value has to be a positive integer, equal or larger than 0, but
lower or equal to 2 (two retries maximum, three runs in total).

A simple example:

```yaml
test:
  script: rspec
  retry: 2
```

## Git Strategy

> Introduced in GitLab 8.9 as an experimental feature.  May change or be removed
  completely in future releases. `GIT_STRATEGY=none` requires GitLab Runner
  v1.7+.

You can set the `GIT_STRATEGY` used for getting recent application code, either
in the global [`variables`](#variables) section or the [`variables`](#job-variables)
section for individual jobs. If left unspecified, the default from project
settings will be used.

There are three possible values: `clone`, `fetch`, and `none`.

`clone` is the slowest option. It clones the repository from scratch for every
job, ensuring that the project workspace is always pristine.

```yaml
variables:
  GIT_STRATEGY: clone
```

`fetch` is faster as it re-uses the project workspace (falling back to `clone`
if it doesn't exist). `git clean` is used to undo any changes made by the last
job, and `git fetch` is used to retrieve commits made since the last job ran.

```yaml
variables:
  GIT_STRATEGY: fetch
```

`none` also re-uses the project workspace, but skips all Git operations
(including GitLab Runner's pre-clone script, if present). It is mostly useful
for jobs that operate exclusively on artifacts (e.g., `deploy`). Git repository
data may be present, but it is certain to be out of date, so you should only
rely on files brought into the project workspace from cache or artifacts.

```yaml
variables:
  GIT_STRATEGY: none
```

## Git Checkout

> Introduced in GitLab Runner 9.3

The `GIT_CHECKOUT` variable can be used when the `GIT_STRATEGY` is set to either
`clone` or `fetch` to specify whether a `git checkout` should be run. If not
specified, it defaults to true. Like `GIT_STRATEGY`, it can be set in either the
global [`variables`](#variables) section or the [`variables`](#job-variables)
section for individual jobs.

If set to `false`, the Runner will:

- when doing `fetch` - update the repository and leave working copy on
  the current revision,
- when doing `clone` - clone the repository and leave working copy on the
  default branch.

Having this setting set to `true` will mean that for both `clone` and `fetch`
strategies the Runner will checkout the working copy to a revision related
to the CI pipeline:

```yaml
variables:
  GIT_STRATEGY: clone
  GIT_CHECKOUT: false
script:
  - git checkout master
  - git merge $CI_BUILD_REF_NAME
```

## Git Submodule Strategy

> Requires GitLab Runner v1.10+.

The `GIT_SUBMODULE_STRATEGY` variable is used to control if / how Git
submodules are included when fetching the code before a build. Like
`GIT_STRATEGY`, it can be set in either the global [`variables`](#variables)
section or the [`variables`](#job-variables) section for individual jobs.

There are three possible values: `none`, `normal`, and `recursive`:

- `none` means that submodules will not be included when fetching the project
  code. This is the default, which matches the pre-v1.10 behavior.

- `normal` means that only the top-level submodules will be included. It is
  equivalent to:

    ```
    git submodule sync
    git submodule update --init
    ```

- `recursive` means that all submodules (including submodules of submodules)
  will be included. It is equivalent to:

    ```
    git submodule sync --recursive
    git submodule update --init --recursive
    ```

Note that for this feature to work correctly, the submodules must be configured
(in `.gitmodules`) with either:

- the HTTP(S) URL of a publicly-accessible repository, or
- a relative path to another repository on the same GitLab server. See the
  [Git submodules](../git_submodules.md) documentation.


## Job stages attempts

> Introduced in GitLab, it requires GitLab Runner v1.9+.

You can set the number for attempts the running job will try to execute each
of the following stages:

| Variable                        | Description |
|-------------------------------- |-------------|
| **GET_SOURCES_ATTEMPTS**        | Number of attempts to fetch sources running a job |
| **ARTIFACT_DOWNLOAD_ATTEMPTS**  | Number of attempts to download artifacts running a job |
| **RESTORE_CACHE_ATTEMPTS**      | Number of attempts to restore the cache running a job |

The default is one single attempt.

Example:

```yaml
variables:
  GET_SOURCES_ATTEMPTS: 3
```

You can set them in the global [`variables`](#variables) section or the
[`variables`](#job-variables) section for individual jobs.

## Shallow cloning

> Introduced in GitLab 8.9 as an experimental feature. May change in future
releases or be removed completely.

You can specify the depth of fetching and cloning using `GIT_DEPTH`. This allows
shallow cloning of the repository which can significantly speed up cloning for
repositories with a large number of commits or old, large binaries. The value is
passed to `git fetch` and `git clone`.

>**Note:**
If you use a depth of 1 and have a queue of jobs or retry
jobs, jobs may fail.

Since Git fetching and cloning is based on a ref, such as a branch name, Runners
can't clone a specific commit SHA. If there are multiple jobs in the queue, or
you are retrying an old job, the commit to be tested needs to be within the
Git history that is cloned. Setting too small a value for `GIT_DEPTH` can make
it impossible to run these old commits. You will see `unresolved reference` in
job logs. You should then reconsider changing `GIT_DEPTH` to a higher value.

Jobs that rely on `git describe` may not work correctly when `GIT_DEPTH` is
set since only part of the Git history is present.

To fetch or clone only the last 3 commits:

```yaml
variables:
  GIT_DEPTH: "3"
```

## Hidden keys (jobs)

> Introduced in GitLab 8.6 and GitLab Runner v1.1.1.

If you want to temporarily 'disable' a job, rather than commenting out all the
lines where the job is defined:

```
#hidden_job:
#  script:
#    - run test
```

you can instead start its name with a dot (`.`) and it will not be processed by
GitLab CI. In the following example, `.hidden_job` will be ignored:

```yaml
.hidden_job:
  script:
    - run test
```

Use this feature to ignore jobs, or use the
[special YAML features](#special-yaml-features) and transform the hidden keys
into templates.

## Special YAML features

It's possible to use special YAML features like anchors (`&`), aliases (`*`)
and map merging (`<<`), which will allow you to greatly reduce the complexity
of `.gitlab-ci.yml`.

Read more about the various [YAML features](https://learnxinyminutes.com/docs/yaml/).

### Anchors

> Introduced in GitLab 8.6 and GitLab Runner v1.1.1.

YAML has a handy feature called 'anchors', which lets you easily duplicate
content across your document. Anchors can be used to duplicate/inherit
properties, and is a perfect example to be used with [hidden keys](#hidden-keys-jobs)
to provide templates for your jobs.

The following example uses anchors and map merging. It will create two jobs,
`test1` and `test2`, that will inherit the parameters of `.job_template`, each
having their own custom `script` defined:

```yaml
.job_template: &job_definition  # Hidden key that defines an anchor named 'job_definition'
  image: ruby:2.1
  services:
    - postgres
    - redis

test1:
  <<: *job_definition           # Merge the contents of the 'job_definition' alias
  script:
    - test1 project

test2:
  <<: *job_definition           # Merge the contents of the 'job_definition' alias
  script:
    - test2 project
```

`&` sets up the name of the anchor (`job_definition`), `<<` means "merge the
given hash into the current one", and `*` includes the named anchor
(`job_definition` again). The expanded version looks like this:

```yaml
.job_template:
  image: ruby:2.1
  services:
    - postgres
    - redis

test1:
  image: ruby:2.1
  services:
    - postgres
    - redis
  script:
    - test1 project

test2:
  image: ruby:2.1
  services:
    - postgres
    - redis
  script:
    - test2 project
```

Let's see another one example. This time we will use anchors to define two sets
of services. This will create two jobs, `test:postgres` and `test:mysql`, that
will share the `script` directive defined in `.job_template`, and the `services`
directive defined in `.postgres_services` and `.mysql_services` respectively:

```yaml
.job_template: &job_definition
  script:
    - test project

.postgres_services:
  services: &postgres_definition
    - postgres
    - ruby

.mysql_services:
  services: &mysql_definition
    - mysql
    - ruby

test:postgres:
  <<: *job_definition
  services: *postgres_definition

test:mysql:
  <<: *job_definition
  services: *mysql_definition
```

The expanded version looks like this:

```yaml
.job_template:
  script:
    - test project

.postgres_services:
  services:
    - postgres
    - ruby

.mysql_services:
  services:
    - mysql
    - ruby

test:postgres:
  script:
    - test project
  services:
    - postgres
    - ruby

test:mysql:
  script:
    - test project
  services:
    - mysql
    - ruby
```

You can see that the hidden keys are conveniently used as templates.

## Triggers

Triggers can be used to force a rebuild of a specific branch, tag or commit,
with an API call.

[Read more in the triggers documentation.](../triggers/README.md)

### pages

`pages` is a special job that is used to upload static content to GitLab that
can be used to serve your website. It has a special syntax, so the two
requirements below must be met:

1. Any static content must be placed under a `public/` directory
1. `artifacts` with a path to the `public/` directory must be defined

The example below simply moves all files from the root of the project to the
`public/` directory. The `.public` workaround is so `cp` doesn't also copy
`public/` to itself in an infinite loop:

```
pages:
  stage: deploy
  script:
  - mkdir .public
  - cp -r * .public
  - mv .public public
  artifacts:
    paths:
    - public
  only:
  - master
```

Read more on [GitLab Pages user documentation](../../user/project/pages/index.md).

## Validate the .gitlab-ci.yml

Each instance of GitLab CI has an embedded debug tool called Lint.
You can find the link under `/ci/lint` of your gitlab instance.

## Using reserved keywords

If you get validation error when using specific values (e.g., `true` or `false`),
try to quote them, or change them to a different form (e.g., `/bin/true`).

## Skipping jobs

If your commit message contains `[ci skip]` or `[skip ci]`, using any
capitalization, the commit will be created but the jobs will be skipped.

## Examples

Visit the [examples README][examples] to see a list of examples using GitLab
CI with various languages.

[env-manual]: ../environments.md#manually-deploying-to-environments
[examples]: ../examples/README.md
[ce-6323]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/6323
[environment]: ../environments.md
[ce-6669]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/6669
[variables]: ../variables/README.md
[ce-7983]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/7983
[ce-7447]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/7447
[ce-3442]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/3442
[schedules]: ../../user/project/pipelines/schedules.md
