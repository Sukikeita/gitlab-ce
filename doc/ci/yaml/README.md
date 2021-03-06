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
   `test` and `deploy` are allowed to be used as job's stage by default.
   
   如果在.gitlab-ci.yml中没有定义阶段，那么默认允许`build`,
   `test` 和 `deploy`作为作业的阶段。

2. If a job doesn't specify a `stage`, the job is assigned the `test` stage. 

如果一个工作没有指定一个阶段，那么这个工作被分配到测试`test`阶段。

### types 类型（已弃用，请使用stages）

> Deprecated, and could be removed in one of the future releases. Use [stages](#stages) instead. 

Alias for [stages](#stages).

### variables 变量

> Introduced in GitLab Runner v0.5.0. 在GitLab Runner v0.5.0中引入。

GitLab CI allows you to add variables to `.gitlab-ci.yml` that are set in the
job environment. The variables are stored in the Git repository and are meant
to store non-sensitive project configuration, for example:

GitLab CI允许您将变量添加到.gitlab-ci.yml中，用于设置作业的环境变量。 这些变量存储在Git仓库中，`·········，例如：
设置数据库url变量：
```yaml
variables:
  DATABASE_URL: "postgres://postgres@postgres/my_database"
```

>**Note:**
Integers (as well as strings) are legal both for variable's name and value.
Floats are not legal and cannot be used.

注意：整数（以及字符串）对变量的名称和值都是合法的。 浮点数是不合法的，不能使用。


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
starting from GitLab 9.0** 
默认情况下，从GitLab 9.0开始，在管道和作业之间启用和共享缓存

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
otherwise cache content can be overwritten.

请注意，由于缓存是在作业之间共享的，如果您为不同的作业使用不同的路径，则还应该设置不同的**cache:key**，否则可能会覆盖缓存内容。

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

To enable per-branch and per-stage caching: 启用分支缓存和阶段缓存

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
| script        | yes      | Defines a shell script which is executed by Runner定义要执行的shell脚本 |
| image         | no       | Use docker image, covered in [Using Docker Images](../docker/using_docker_images.md#define-image-and-services-from-gitlab-ciyml)使用的docker镜像，在链接中有介绍 |
| services      | no       | Use docker services, covered in [Using Docker Images](../docker/using_docker_images.md#define-image-and-services-from-gitlab-ciyml)要使用的docker服务，链接中有介绍 |
| stage         | no       | Defines a job stage (default: `test`)定义作业的阶段，默认为test |
| type          | no       | Alias for `stage`stage的别称 |
| variables     | no       | Define job variables on a job level 在作业级别中定义作业变量 |
| only          | no       | Defines a list of git refs for which job is created 定义git的引用（ref）列表，指定在作业中创建 |
| except        | no       | Defines a list of git refs for which job is not created 定义git的引用（ref），指定在作业中不创建 |
| tags          | no       | Defines a list of tags which are used to select Runner 定义tag列表，用于选择Runner |
| allow_failure | no       | Allow job to fail. Failed job doesn't contribute to commit status 允许作业以失败状态结束，失败的作业不会影响提交的状态 |
| when          | no       | Define when to run job. Can be `on_success`, `on_failure`, `always` or `manual` 定义允许作业的条件。可取的值有：`on_success`, `on_failure`, `always`或`manual` |
| dependencies  | no       | Define other jobs that a job depends on so that you can pass artifacts between them 定义另一个要依赖的作业以在作业间传送构件 |
| artifacts     | no       | Define list of [job artifacts](../../user/project/pipelines/job_artifacts.md)定义作业构件列表 |
| cache         | no       | Define list of files that should be cached between subsequent runs 定义要在子序列之间要缓存的文件列表 |
| before_script | no       | Override a set of commands that are executed before job 作业执行前的命令集 |
| after_script  | no       | Override a set of commands that are executed after job 作业执行后的命令集 |
| environment   | no       | Defines a name of environment to which deployment is done by this job 定义环境名，用于本作业的部署任务 |
| coverage      | no       | Define code coverage settings for a given job 定义给定作业的代码覆盖率 |
| retry         | no       | Define how many times a job can be auto-retried in case of a failure 定义作业失败后自动重启的次数 |

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
有时，`script`命令将需要用单引号或双引号包装。 例如，包含冒号（:)的命令需要用引号括起来，以便YAML解析器知道将整个事件解释为字符串而不是“key：value”对。 使用特以下殊字符时要小心：：，{，}，[，]，,,＆，*，＃，？，|， - ，<，>，=，！，％，@，`

### stage

`stage` allows to group jobs into different stages. Jobs of the same `stage`
are executed in `parallel`. For more info about the use of `stage` please check
[stages](#stages).
阶段允许将工作分成不同的阶段。 同一阶段的工作是并行执行的。 有关`stage`使用的更多信息，请查看stages部分。

### only and except (simplified)只有和（简化）

`only` and `except` are two parameters that set a job policy to limit when
jobs are created:
`only` 和 `except`是用于在作业创建时设置作业策略限制的两个参数。

1. `only` defines the names of branches and tags for which the job will run.`only`定义触发作业的分支和标签的名称。
2. `except` defines the names of branches and tags for which the job will
    **not** run.`except`定义了不触发作业的分支名和标签名。

There are a few rules that apply to the usage of job policy:
使用作业侧策略有以下规则：

* `only` and `except` are inclusive. If both `only` and `except` are defined
   in a job specification, the ref is filtered by `only` and `except`.`only` 和 `except`是广泛的。 如果仅在作业规范中定义了`only` 和 `except`，则ref由 `only` 和 `except`进行过滤。

* `only` and `except` allow the use of regular expressions.
`only` 和 `except`允许使用正则表达式
* `only` and `except` allow to specify a repository path to filter jobs for
   forks.
   `only` 和 `except`允许指定一个存储库路径以过滤要复刻的作业。

In addition, `only` and `except` allow the use of special keywords:
除此之外，`only` 和 `except`允许使用一下特殊关键词：

| **Value** |  **Description**  |
| --------- |  ---------------- |
| `branches`  | When a branch is pushed.当推送分支时可触发作业  |
| `tags`      | When a tag is pushed.当推送tag（基线）时可触发  |
| `api`       | When pipeline has been triggered by a second pipelines API (not triggers API). 当pipeline由另一个pipelines API触发时 |
| `external`  | When using CI services other than GitLab.当使用GitLab以外的CI服务时可触发 |
| `pipelines` | For multi-project triggers, created using the API with `CI_JOB_TOKEN`.对于多项目触发器使用`CI_JOB_TOKEN创建？？ |
| `pushes`    | Pipeline is triggered by a `git push` by the user.用户通过`git push`触发Pileline |
| `schedules` | For [scheduled pipelines][schedules].对于计划管道可触发作业 |
| `triggers`  | For pipelines created using a trigger token.对于使用触发器token创建的Pipelines |
| `web`       | For pipelines created using **Run pipeline** button in GitLab UI (under your project's **Pipelines**).对于使用**Run pipeline**（在GitLab UI）按钮创建的Pipelines |

In the example below, `job` will run only for refs that start with `
-`,
whereas all branches will be skipped:

在下面的例子中，job只会为以issue-开头的ref运行，而对所有分支将跳过：

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

在这个例子中，作业将只为已标记的ref，或者通过API触发器显式请求构建或Pipeline Schedule情况下触发：

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

存储库路径可用于仅为父存储库执行作业，而不是分叉（forks）：

```yaml
job:
  only:
    - branches@gitlab-org/gitlab-ce
  except:
    - master@gitlab-org/gitlab-ce
```

The above example will run `job` for all branches on `gitlab-org/gitlab-ce`,
except master.

上面的例子中，gitlab-org/gitlab-ce上除master之外的所有分支可运行（触发）作业。

### only and except (complex) 进阶的only and except

> Introduced in GitLab 10.0 在GitLab 10.0中引入

> This an _alpha_ feature, and it it subject to change at any time without
  prior notice!这是一个alpha功能，它随时可能更改，恕不另行通知！

Since GitLab 10.0 it is possible to define a more elaborate only/except job
policy configuration.

自GitLab 10.0，读者可以定义一个更详细的only/except作业策略配置。

GitLab now supports both, simple and complex strategies, so it is possible to
use an array and a hash configuration scheme.

GitLab现在支持简单和复杂的策略，所以可以使用数组和哈希配置方案。

Two keys are now available: `refs` and `kubernetes`. Refs strategy equals to
simplified only/except configuration, whereas kubernetes strategy accepts only
`active` keyword.

现在有两个键：refs和kubernetes。 Refs战略等于仅简化only/except配置，而kubernetes策略只接受`active`关键字。

See the example below. Job is going to be created only when pipeline has been
scheduled or runs for a `master` branch, and only if kubernetes service is
active in the project.

看下面的例子。 只有在计划管道或为主分支运行时才会创建作业，并且只有在项目中激活了kubernetes服务时才会创建作业。

```yaml
job:
  only:
    refs:
      - master
      - schedules
    kubernetes: active
```

### Job variables 作业变量

It is possible to define job variables using a `variables` keyword on a job
level. It works basically the same way as its [global-level equivalent](#variables),
but allows you to define job-specific variables.

可以使用作业级别的变量关键字来定义作业变量。 它的工作方式基本上与其全局级别相同，但允许您定义特定于作业的变量。

When the `variables` keyword is used on a job level, it overrides the global YAML
job variables and predefined ones. To turn off global defined variables
in your job, define an empty hash:

当在作业级别上使用`variables`关键字时，它将覆盖全局YAML作业变量和预定义变量。 要关闭作业中的全局定义变量，请定义一个空的散列：

```yaml
job_name:
  variables: {}
```

Job variables priority is defined in the [variables documentation][variables].

作业变量优先级在变量文档中定义。

### tags

`tags` is used to select specific Runners from the list of all Runners that are
allowed to run this project.

标签用于从允许运行此项目的所有runner列表中选择特定的runner。

During the registration of a Runner, you can specify the Runner's tags, for
example `ruby`, `postgres`, `development`.

在注册Runner的过程中，你可以指定Runner的标签，例如ruby，postgres，development。

`tags` allow you to run jobs with Runners that have the specified tags
assigned to them:

标签允许您使用分配有指定标签的runner运行作业：

```yaml
job:
  tags:
    - ruby
    - postgres
```

The specification above, will make sure that `job` is built by a Runner that
has both `ruby` AND `postgres` tags defined.

上面的规范将确保作业由一个Runner构建，该Runner同时定义了ruby和postgres标签。

### allow_failure 允许失败

`allow_failure` is used when you want to allow a job to fail without impacting
the rest of the CI suite. Failed jobs don't contribute to the commit status.

allow_failure用于允许一个作业失败而不影响CI套件其余部分。 失败的作业不参与提交状态。

When enabled and the job fails, the pipeline will be successful/green for all
intents and purposes, but a "CI build passed with warnings" message  will be
displayed on the merge request or commit or job page. This is to be used by
jobs that are allowed to fail, but where failure indicates some other (manual)
steps should be taken elsewhere.

当启用allow_failure并且作业失败时，该pipeline的状态将无条件是successful/green，但merge request或提交或作业页面将显示“CI构建通过但带警告”的信息。这就是允许作业失败，而失败的地方将显示需执行其他的步骤（手工）。

In the example below, `job1` and `job2` will run in parallel, but if `job1`
fails, it will not stop the next stage from running, since it's marked with
`allow_failure: true`:

在以下的例子当中，`job1`和`job2`将并行运行，但如果`job1`失败，它将不会影响下一阶段的运行，因为它将标记为：`allow_failure: true`：

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

when用于作业失败或尽管失败的后续处理。
`when` can be set to one of the following values:

when可设置为以下列出的值：

1. `on_success` - execute job only when all jobs from prior stages
    succeed. This is the default.--仅当前一阶段所有作业都成功时才执行此作业
1. `on_failure` - execute job only when at least one job from prior stages
    fails.--仅当前一阶段只是一个作业失败时才执行作业
1. `always` - execute job regardless of the status of jobs from prior stages.--不管前一阶段作业的状态是什么，都执行作业
1. `manual` - execute job manually (added in GitLab 8.10). Read about
    [manual actions](#manual-actions) below.--手工执行作业。（自8.10新增）可阅读下面的手工执行部分。

For example 打个比方:

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
以上脚本将：

1. Execute `cleanup_build_job` only when `build_job` fails.只有当build_job失败时才执行cleanup_build_job；
2. Always execute `cleanup_job` as the last step in pipeline regardless of
   success or failure.不管pipeline失败与否，总是执行 cleanup_job作业；
3. Allow you to manually execute `deploy_job` from GitLab's UI.允许你在GitLab的UI页面手工执行deploy_job。

#### Manual actions 手工执行

> Introduced in GitLab 8.10. 自Gitlab 8.10引入手工执行功能
> Blocking manual actions were introduced in GitLab 9.0 自GitLab 9.0引入锁定手工执行功能
> Protected actions were introduced in GitLab 9.2 子GitLab 9.2引入包含操作（protected actions）

Manual actions are a special type of job that are not executed automatically;
they need to be explicitly started by a user. Manual actions can be started
from pipeline, build, environment, and deployment views.

手工执行是针对不自动执行的作业；这些作业需要通过用户显式启动。手工执行可从pipeline、构建、环境和部署视图启动。

An example usage of manual actions is deployment to production.

一个手工执行作业的例子就是部署到生产环境。

Read more at the [environments documentation][env-manual].

详情可在环境文档中可读。

Manual actions can be either optional or blocking. Blocking manual action will
block execution of the pipeline at stage this action is defined in. It is
possible to resume execution of the pipeline when someone executes a blocking
manual actions by clicking a _play_ button.

手工执行是可选项，也可以锁定。锁定手工操作将锁定pipeline中定义了锁住的阶段的执行。当某人通过点击_play_执行了一个锁定手工操作，可恢复该pipeline的执行。

When pipeline is blocked it will not be merged if Merge When Pipeline Succeeds
is set. Blocked pipelines also do have a special status, called _manual_.

当pipeline被锁定，尽管Pipeline设置为成功，该Merge不会被合并。被锁定的pipeline确实还有个特殊的状态，叫_manual_。

Manual actions are non-blocking by default. If you want to make manual action
blocking, it is necessary to add `allow_failure: false` to the job's definition
in `.gitlab-ci.yml`.

手工操作默认是非锁定的。如果你想是手工操作被锁定，那必须在`.gitlab-ci.yml`定义该作业时添加`allow_failure: false`的设置。

Optional manual actions have `allow_failure: true` set by default.
可选的手工操作默认是`allow_failure: true`。

**Statuses of optional actions do not contribute to overall pipeline status.可选操作的状态不会影响pileline的整体状态**

**Manual actions are considered to be write actions, so permissions for
protected branches are used when user wants to trigger an action. In other
words, in order to trigger a manual action assigned to a branch that the
pipeline is running for, user needs to have ability to merge to this branch.

手工操作被任务是写操作，因此当用户想触发一个操作时，请善用保护分支的访问权限。换句话说，为了触发一个pipeline正在服务的分支的手工操作，用户需要有该分支的合并权限。？？**

### environment 环境

>
**Notes:**
- Introduced in GitLab 8.9. 自GitLab 8.9引入环境的说法
- You can read more about environments and find more examples in the
  [documentation about environments][environment]. 读者可在链接中获取关于环境及其用法的例子。

`environment` is used to define that a job deploys to a specific environment.
If `environment` is specified and no environment under that name exists, a new
one will be created automatically.

`environment`用户定义一个部署到指定环境的作业。如果`environment`已被指定，并且没有同名的环境，将自动创建一个新的环境。

In its simplest form, the `environment` keyword can be defined like:

`environment`关键词可以下面简化的格式进行定义：

```yaml
deploy to production:
  stage: deploy
  script: git push production HEAD:master
  environment:
    name: production
```

In the above example, the `deploy to production` job will be marked as doing a
deployment to the `production` environment.

在上面的例子中，`deploy to production`作业将被标记为整治部署到`production`环境

#### environment:name --环境名

>
**Notes:**
- Introduced in GitLab 8.11.--自GitLab 8.11引入
- Before GitLab 8.11, the name of an environment could be defined as a string like
  `environment: production`. The recommended way now is to define it under the
  `name` keyword.GitLab 8.11之前，环境名可以定义成 `environment: production'这样的字符串。但现在比较推荐读者将其定义到`name`关键词下。
- The `name` parameter can use any of the defined CI variables,
  including predefined, secure variables and `.gitlab-ci.yml` [`variables`](#variables).
  You however cannot use variables defined under `script`. 
  
  `name`参数可使用任何一定义的CI变量，包括预定义的、安全变量和`.gitlab-ci.yml`的变量。然而的是，你不能使用定义在`script`下的变量。

The `environment` name can contain:
`environment`的名称可包括：

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

一般`environment`会定义为`qa`, `staging`, 和 `production`，但你可使用任何的名称。

Instead of defining the name of the environment right after the `environment`
keyword, it is also possible to define it as a separate value. For that, use
the `name` keyword under `environment`:

与其在`environment`关键字隔壁定义该环境名，还可以将其定义为一个分开的值。对此在那个在`environment`下使用`name`关键词。

```yaml
deploy to production:
  stage: deploy
  script: git push production HEAD:master
  environment:
    name: production
```

#### environment:url 环境链接

>
**Notes:**
- Introduced in GitLab 8.11.-自GitLab 8.11引入
- Before GitLab 8.11, the URL could be added only in GitLab's UI. The
  recommended way now is to define it in `.gitlab-ci.yml`.在GitLab 8.11之前，URL可在UI界面中添加。而现在推荐读者在`.gitlab-ci.yml`文件中定义。
- The `url` parameter can use any of the defined CI variables,
  including predefined, secure variables and `.gitlab-ci.yml` [`variables`](#variables).
  You however cannot use variables defined under `script`.
  
  'url'参数可以使用已定义的CI变量的任何值，包括预定义、安全变量和`.gitlab-ci.yml`中定义的变量。然而，你不能再url中使用在`script`下定义的变量。

This is an optional value that when set, it exposes buttons in various places
in GitLab which when clicked take you to the defined URL.

这是可选设置项，GitLab中有多个按钮可连接到设置url。

In the example below, if the job finishes successfully, it will create buttons
in the merge requests and in the environments/deployments pages which will point
to `https://prod.example.com`.

在以下的例子中，如果该作业成功执行，将在merge request和environments/deployments页面中创建按钮，该按钮可指向`https://prod.example.com`。

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
- [Introduced][ce-6669] in GitLab 8.13.自GitLab 8.13引入on_stop
- Starting with GitLab 8.14, when you have an environment that has a stop action
  defined, GitLab will automatically trigger a stop action when the associated
  branch is deleted.
  
  自GitLab 8.14开始，当你有一个环境并且定义了stop操作，GitLab将自动触发一个stop操作，当关联的分支被删除时。

Closing (stoping) environments can be achieved with the `on_stop` keyword defined under
`environment`. It declares a different job that runs in order to close
the environment.

关闭（停止）环境可以通过`environment`设置`on_stop`关键词实现。这声明了一个为了关闭该环境的作业。

Read the `environment:action` section for an example.

阅读`environment:action`部分作为例子。

#### environment:action

> [Introduced][ce-6669] in GitLab 8.13.自GitLab 8.13引入action。

The `action` keyword is to be used in conjunction with `on_stop` and is defined
in the job that is called to close the environment.

`action`关键词用于与`on_stop`一起使用，并且在该作业中定义，以调用关闭环境。

Take for instance:
举个例子：

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

在上面的例子中，我们建立了`review_app`作业以部署到名为`review`的环境中，并且我们还可以在`on_stop`下定义一个`stop_review_app`的作业。一旦`review_app`作业运行成功，这将触发`stop_review_app`作业，该作业基于`when`中定义的内容。在这个例子中，我们设置`when`为'manual'，因此为了运行stop_review_app作业，我们需要通过GitLab页面手工启动。

The `stop_review_app` job is **required** to have the following keywords defined:
stop_review_app作业必须定义以下关键词：

- `when` - [reference](#when) 条件
- `environment:name` 环境名
- `environment:action` 动作
- `stage` should be the same as the `review_app` in order for the environment
  to stop automatically when the branch is deleted --stage应该与`review_app`的一致，这是为了当分支被删除时，将自动停止该环境。

#### dynamic environments 动态环境

>
**Notes:**
- [Introduced][ce-6323] in GitLab 8.12 and GitLab Runner 1.6.GitLab 8.12和GitLab Runner 1.6引入
- The `$CI_ENVIRONMENT_SLUG` was [introduced][ce-7983] in GitLab 8.15.GitLab 8.15中引入`$CI_ENVIRONMENT_SLUG`
- The `name` and `url` parameters can use any of the defined CI variables,
  including predefined, secure variables and `.gitlab-ci.yml` [`variables`](#variables).
  You however cannot use variables defined under `script`.
  
  `name`和`url`参数可用任何已定义的CI变量，包括预定义、安全变量和`.gitlab-ci.yml`中的变量。但你不能使用`script`中定义的变量。

For example:
举个例子：


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

`deploy as review app`作业将标记为部署到动态、创建`review/$CI_COMMIT_REF_NAME`环境，其中`$CI_COMMIT_REF_NAME`是Runner设置的环境变量。`$CI_ENVIRONMENT_SLUG`变量是基于环境名，但包含在URL中。在这种情况，如果`deploy as review app`作业在`pow`分支，此环境可通过`https://review-pow.example.com/`类似的url中访问。

This of course implies that the underlying server which hosts the application
is properly configured.

这当然意味着托管应用程序的底层服务器已正确配置。


The common use case is to create dynamic environments for branches and use them
as Review Apps. You can see a simple example using Review Apps at
<https://gitlab.com/gitlab-examples/review-apps-nginx/>.

一般的用法是为分支创建动态环境，并使用作为Review Apps使用。你可以在链接中查看如何使用Review App的简单例子。

### artifacts

>
**Notes:**
- Introduced in GitLab Runner v0.7.0 for non-Windows platforms. 自Runner v0.7.0引入artifacts，针对非Windows平台
- Windows support was added in GitLab Runner v.1.0.0. Windows的支持在GitLab Runner v.1.0.0新增
- Prior to GitLab 9.2, caches were restored after artifacts. GitLab 9.2前的版本，cache将在artifact后恢复
- From GitLab 9.2, caches are restored before artifacts.从GitLab 9.2，cache将在artifact是前恢复
- Currently not all executors are supported. 目前不支持所有的executor
- Job artifacts are only collected for successful jobs by default. 作业artifact默认只收集成功的作业

`artifacts` is used to specify a list of files and directories which should be
attached to the job after success. You can only use paths that are within the
project workspace. To pass artifacts between different jobs, see [dependencies](#dependencies).

artifacts用于指定了要附加到作业（成功后）的文件和目录列表。你可以只使用在项目工作空间里的路径。为了通过不同作业之间的作业，请看dependicies部分。

Below are some examples.

以下是一些例子.

Send all files in `binaries` and `.config`:

发送所有`binaries`的文件 和 `.config`文件：

```yaml
artifacts:
  paths:
  - binaries/
  - .config
```

Send all Git untracked files:

发送所有Git未跟踪的文件：

```yaml
artifacts:
  untracked: true
```

Send all Git untracked files and files in `binaries`:

发送所有Git未追踪的文件和`binaries`目录下的文件：

```yaml
artifacts:
  untracked: true
  paths:
  - binaries/
```

To disable artifact passing, define the job with empty [dependencies](#dependencies):

为了禁用artifact passing，请在该作业定义空的dependencies。

```yaml
job:
  stage: build
  script: make build
  dependencies: []
```

You may want to create artifacts only for tagged releases to avoid filling the
build server storage with temporary build artifacts.

你可能希望值为已标记的releases创建artifact，以避免临时的构建artifact塞满构建服务器存储。

Create artifacts only for tags (`default-job` will not create artifacts):

只为tags创建artifact（`default-job`将不创建artifact）：

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

该artifact将在作业成功后被发送到GitLab，并且可在GitLab UI中可供下载。

#### artifacts:name 指定归档名

> Introduced in GitLab 8.6 and GitLab Runner v1.1.0.自GitLab 8.6 和GitLab Runner v1.1.0中引入。

The `name` directive allows you to define the name of the created artifacts
archive. That way, you can have a unique name for every archive which could be
useful when you'd like to download the archive from GitLab. The `artifacts:name`
variable can make use of any of the [predefined variables](../variables/README.md).
The default name is `artifacts`, which becomes `artifacts.zip` when downloaded.

`name`显示允许你定义要创建的artifact归档名。这样，每个档案都可以有一个唯一的名字，当你想要从GitLab下载档案的时候，这个名字是很有用的。`artifacts:name`参数可使用预定义变量中的任何值。默认的归档名为`artifacts`，下载的报名为`artifacts.zip`。

---

**Example configurations 配置例子**

To create an archive with a name of the current job:
为了创建以当前作业命名的归档：

```yaml
job:
  artifacts:
    name: "$CI_JOB_NAME"
```

To create an archive with a name of the current branch or tag including only
the files that are untracked by Git:

为了创建一个以当前分支或tag命名的归档包，只包括Git未追踪的文件：

```yaml
job:
   artifacts:
     name: "$CI_COMMIT_REF_NAME"
     untracked: true
```

To create an archive with a name of the current job and the current branch or
tag including only the files that are untracked by Git:

为了创建以当前作业和当前分支或tag命名的归档包，该包只包括Git未追踪的文件：

```yaml
job:
  artifacts:
    name: "${CI_JOB_NAME}_${CI_COMMIT_REF_NAME}"
    untracked: true
```

To create an archive with a name of the current [stage](#stages) and branch name:

为了创建以当前stage和分支名命名的归档包：

```yaml
job:
  artifacts:
    name: "${CI_JOB_STAGE}_${CI_COMMIT_REF_NAME}"
    untracked: true
```

---

If you use **Windows Batch** to run your shell scripts you need to replace
`$` with `%`:

如果你使用的是**Windows Batch** 运行你的Shell脚本，你需要将`$`替换为`%：

```yaml
job:
  artifacts:
    name: "%CI_JOB_STAGE%_%CI_COMMIT_REF_NAME%"
    untracked: true
```

If you use **Windows PowerShell** to run your shell scripts you need to replace
`$` with `$env:`:

如果你使用**Windows PowerShell**运行您的Shell脚本，你需要将`$`替换为`$env:`

```yaml
job:
  artifacts:
    name: "$env:CI_JOB_STAGE_$env:CI_COMMIT_REF_NAME"
    untracked: true
```

#### artifacts:when 指定归档的条件

> Introduced in GitLab 8.9 and GitLab Runner v1.3.0.自GitLab 8.和GitLab Runner v1.3.0引入

`artifacts:when` is used to upload artifacts on job failure or despite the
failure.
`artifacts:when`用于在作业失败或不管是否失败时上次归档包。

`artifacts:when` can be set to one of the following values:
`artifacts:when`可设置为以下的可用值：

1. `on_success` - upload artifacts only when the job succeeds. This is the default. 当作业成功时上传归档包，这是默认值。
1. `on_failure` - upload artifacts only when the job fails. 当作业失败时上传归档包
1. `always` - upload artifacts regardless of the job status. 不管作业的状态，上传归档包

---

**Example configurations 配置的例子**

To upload artifacts only when job fails.

当作业失败时，上传归档包：

```yaml
job:
  artifacts:
    when: on_failure
```

#### artifacts:expire_in 指定归档的有效期

> Introduced in GitLab 8.9 and GitLab Runner v1.3.0. 自GitLab 8.9和GitLab Runner v1.3.0引入

`artifacts:expire_in` is used to delete uploaded artifacts after the specified
time. By default, artifacts are stored on GitLab forever. `expire_in` allows you
to specify how long artifacts should live before they expire, counting from the
time they are uploaded and stored on GitLab.

`artifacts:expire_in`用于在指定的时间删除归档版。默认情况下，归档包将永久保存在GitLab服务器。

You can use the **Keep** button on the job page to override expiration and
keep artifacts forever.

你可以使用作业页面的**Keep**按钮覆盖有效期值，使该归档包永久保存。

After expiry, artifacts are actually deleted hourly by default (via a cron job),
but they are not accessible after expiry.

在有效期后，默认地归档包将被删除（通过一个cron作业），但在有效期后不可访问。

The value of `expire_in` is an elapsed time. Examples of parseable values:

expire_in的值是经过的（elapsed）时间。 可解析值的示例：

- '3 mins 4 sec'
- '2 hrs 20 min'
- '2h20min'
- '6 mos 1 day'
- '47 yrs 6 mos and 4d'
- '3 weeks and 2 days'

---

**Example configurations配置例子**

To expire artifacts 1 week after being uploaded:

指定归档的有限期为在上传后的一周：

```yaml
job:
  artifacts:
    expire_in: 1 week
```

### dependencies 依赖

> Introduced in GitLab 8.6 and GitLab Runner v1.1.1.自GitLab 8.6和GitLab Runner v1.1.1引入

This feature should be used in conjunction with [`artifacts`](#artifacts) and
allows you to define the artifacts to pass between different jobs.

此功能应与artifact一起使用，并允许你定义该归档以在不同的作业进行传送。

Note that `artifacts` from all previous [stages](#stages) are passed by default.
注意，前一stages的归档默认是被传送的。

To use this feature, define `dependencies` in context of the job and pass
a list of all previous jobs from which the artifacts should be downloaded.
You can only define jobs from stages that are executed before the current one.
An error will be shown if you define jobs from the current stage or next ones.
Defining an empty array will skip downloading any artifacts for that job.
The status of the previous job is not considered when using `dependencies`, so
if it failed or it is a manual job that was not run, no error occurs.

为了使用此功能，可在该作业中定义`dependencies`，并传送前作业哪些归档需要被下载的列表。你可以只定义在当前stages以前执行的作业。如果你定义的作业时当前的或以后的阶段，那么将会报错。定义一个空的数组该作业将跳过任何归档的下载。当使用`dependencies`时，将不考虑前一作业的状态，因为如果作业失败或者手工作业没有运行，将不报任何错误。

---

In the following example, we define two jobs with artifacts, `build:osx` and
`build:linux`. When the `test:osx` is executed, the artifacts from `build:osx`
will be downloaded and extracted in the context of the build. The same happens
for `test:linux` and artifacts from `build:linux`.

在以下的例子中，我们定义了两个归档的作业，`build:osx`和`build:linux`。当执行`test:osx`时，`build:osx`的归档包将被下载，并且在该构建的上下文中被提取。同样地，也会在`test:linux`中发送，并且`build:linux`的归档。

The job `deploy` will download artifacts from all previous jobs because of
the [stage](#stages) precedence:

`deploy`作业将从前面的作业中下载归档包，由于阶段的优先

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

### before_script and after_script 前脚本和后脚本

It's possible to overwrite the globally defined `before_script` and `after_script`:

可以通过定义`before_script`和`after_script`覆盖全局的

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

### coverage 覆盖率

**Notes:**
- [Introduced][ce-7447] in GitLab 8.17.在GitLab 8.17中引入

`coverage` allows you to configure how code coverage will be extracted from the
job output.

`coverage`允许你配置代码覆盖率是如何从作业输出中提取。

Regular expressions are the only valid kind of value expected here. So, using
surrounding `/` is mandatory in order to consistently and explicitly represent
a regular expression string. You must escape special characters if you want to
match them literally.

正则表达式是这里唯一有效的值类型。 所以，使用周围的`/`是必须的，以便一致和明确地表示一个正则表达式字符串。 如果你想从字面上匹配，你必须转义特殊字符。


A simple example:
举个简单的例子：

```yaml
job1:
  script: rspec
  coverage: '/Code coverage: \d+\.\d+/'
```

### retry 重启

**Notes:**
- [Introduced][ce-3442] in GitLab 9.5.在GitLab 9.5中引入

`retry` allows you to configure how many times a job is going to be retried in
case of a failure.

`retry` 允许你配置作业被重新启动的次数，当作业失败时。

When a job fails, and has `retry` configured it is going to be processed again
up to the amount of times specified by the `retry` keyword.

当一个作业失败，并且设置了`retry` 的次数，这将从新跑这个作业，直到`retry` 次数满。

If `retry` is set to 2, and a job succeeds in a second run (first retry), it won't be retried
again. `retry` value has to be a positive integer, equal or larger than 0, but
lower or equal to 2 (two retries maximum, three runs in total).

如果`retry` 设置为2，并且作业在第二次重跑后成功（第一次是重启），此作业将不在重跑。`retry` 的值必须是一个正整数，大于或等于0，但小于等于2（重启次数的最大值为2，总共将允许3次）。

A simple example:
举个简单例子：

```yaml
test:
  script: rspec
  retry: 2
```

## Git Strategy Git策略

> Introduced in GitLab 8.9 as an experimental feature.  May change or be removed
  completely in future releases. `GIT_STRATEGY=none` requires GitLab Runner
  v1.7+.
  
  自GitLab 8.9作为外部功能引入。可能会在未来的版本中变更或完全移除。`GIT_STRATEGY=none`要求 GitLab Runner
  v1.7+的版本。

You can set the `GIT_STRATEGY` used for getting recent application code, either
in the global [`variables`](#variables) section or the [`variables`](#job-variables)
section for individual jobs. If left unspecified, the default from project
settings will be used.

你可以设置`GIT_STRATEGY`用于获取最新的应用代码，要么在全局变量或作业变量设置。如果未指定具体的值，默认使用项目的设置。

There are three possible values: `clone`, `fetch`, and `none`.

`GIT_STRATEGY` 有三个可用的值：`clone`, `fetch`, and `none`。

`clone` is the slowest option. It clones the repository from scratch for every
job, ensuring that the project workspace is always pristine.

clone是最慢的选项，它从头开始为每个作业克隆存储库，确保项目工作空间始终是原始的。

```yaml
variables:
  GIT_STRATEGY: clone
```

`fetch` is faster as it re-uses the project workspace (falling back to `clone`
if it doesn't exist). `git clean` is used to undo any changes made by the last
job, and `git fetch` is used to retrieve commits made since the last job ran.

fetch是最快的，因为它复用了该项目工作空间（如果本地无工作空间，将退到clone）。git clean 用于撤销最新作业所做的变更，而git fetch用于获取自上一次作业运行之后做的提交。

```yaml
variables:
  GIT_STRATEGY: fetch
```

`none` also re-uses the project workspace, but skips all Git operations
(including GitLab Runner's pre-clone script, if present). It is mostly useful
for jobs that operate exclusively on artifacts (e.g., `deploy`). Git repository
data may be present, but it is certain to be out of date, so you should only
rely on files brought into the project workspace from cache or artifacts.

none还可可复用该项目的工作空间，但跳过所有Git操作（包括GitLab Runner's的预克隆脚本，如果该脚本存在）。这对于专门用于工件的作业（例如`deploy`）最为有用。Git存储库数据可能存在，但肯定的是这些数据是过时的，所以您应该只依赖从缓存或工件带入项目工作区的文件。


```yaml
variables:
  GIT_STRATEGY: none
```

## Git Checkout Git的检出

> Introduced in GitLab Runner 9.3.在GitLab Runner 9.3引入此命令。

The `GIT_CHECKOUT` variable can be used when the `GIT_STRATEGY` is set to either
`clone` or `fetch` to specify whether a `git checkout` should be run. If not
specified, it defaults to true. Like `GIT_STRATEGY`, it can be set in either the
global [`variables`](#variables) section or the [`variables`](#job-variables)
section for individual jobs.

`GIT_CHECKOUT`变量可在`GIT_STRATEGY`设置为clone或fectch以指定`GIT_CHECKOUT`是否允许。如果尚未指定，默认为true。与GIT_STRATEGY类似，单个作业的此变量可在全局变量或作业变量中设置。

If set to `false`, the Runner will:

如果此变量设置为false，Runner将：

- when doing `fetch` - update the repository and leave working copy on
  the current revision, 当fetch时，更新存储库并让工作副本保持当前的版本（revision）；
- when doing `clone` - clone the repository and leave working copy on the
  default branch.当clone时，克隆存储库并保持工作副本更新到默认分支状态。

Having this setting set to `true` will mean that for both `clone` and `fetch`
strategies the Runner will checkout the working copy to a revision related
to the CI pipeline:

将此变量设置为true将意味着，对于clone和fetch策略，Runner将工作副本checkout到CI pipeline相关的版本：

```yaml
variables:
  GIT_STRATEGY: clone
  GIT_CHECKOUT: false
script:
  - git checkout master
  - git merge $CI_BUILD_REF_NAME
```

## Git Submodule Strategy Git子模块策略

> Requires GitLab Runner v1.10+.要求GitLab Runner v1.10+的版本

The `GIT_SUBMODULE_STRATEGY` variable is used to control if / how Git
submodules are included when fetching the code before a build. Like
`GIT_STRATEGY`, it can be set in either the global [`variables`](#variables)
section or the [`variables`](#job-variables) section for individual jobs.

`GIT_SUBMODULE_STRATEGY`变量用于控制在构建之前获取代码时是否包含Git子模块。 像GIT_STRATEGY一样，它可以在全局变量部分或个别作业的变量部分中设置。


There are three possible values: `none`, `normal`, and `recursive`:
`GIT_SUBMODULE_STRATEGY`可使用：`none`, `normal`和 `recursive`

- `none` means that submodules will not be included when fetching the project
  code. This is the default, which matches the pre-v1.10 behavior.
  
  none意味着fetch时不包括子模块。none是此变量的默认值，与1.10以前的版本保持一致。

- `normal` means that only the top-level submodules will be included. It is
  equivalent to:
  
  normal意味着只包含顶级子模块？？这等同于：

    ```
    git submodule sync
    git submodule update --init
    ```

- `recursive` means that all submodules (including submodules of submodules)
  will be included. It is equivalent to:
  
  recursive意味着fetch时包括所有子模块，这等同于：

    ```
    git submodule sync --recursive
    git submodule update --init --recursive
    ```

Note that for this feature to work correctly, the submodules must be configured
(in `.gitmodules`) with either:

注意的是为了让此功能正确运行，该子模块必须配置成以下任意之一：

- the HTTP(S) URL of a publicly-accessible repository, or
- a relative path to another repository on the same GitLab server. See the
  [Git submodules](../git_submodules.md) documentation.
  
  HTTP（s）url是可公共访问的地址或者是同一GitLab服务器的另一存储库的相对路径。请查看Git子模块文档。


## Job stages attempts 作业阶段的attempts？

> Introduced in GitLab, it requires GitLab Runner v1.9+.

要求GitLab Runner v1.9+版本。

You can set the number for attempts the running job will try to execute each
of the following stages:

你可以设置这是attempts的值，正在运行的作业将尝试执行每一个以下的阶段：

| Variable                        | Description |
|-------------------------------- |-------------|
| **GET_SOURCES_ATTEMPTS**        | Number of attempts to fetch sources running a job 运行作业时尝试fetch源码的次数 |
| **ARTIFACT_DOWNLOAD_ATTEMPTS**  | Number of attempts to download artifacts running a job 运行作业时尝试下载构件的次数 |
| **RESTORE_CACHE_ATTEMPTS**      | Number of attempts to restore the cache running a job 运行作业时恢复缓存（cache）的次数 |

The default is one single attempt.

默认次数为1次。

Example:
举个例子：

```yaml
variables:
  GET_SOURCES_ATTEMPTS: 3
```

You can set them in the global [`variables`](#variables) section or the
[`variables`](#job-variables) section for individual jobs.

你可以在全局变量或作业级别变量中中设置此值。

## Shallow cloning 克隆影子

> Introduced in GitLab 8.9 as an experimental feature. May change in future
releases or be removed completely.

在GitLab 8.9中作业外部功能引入。未来的版本中可能会被修改或完全移除。

You can specify the depth of fetching and cloning using `GIT_DEPTH`. This allows
shallow cloning of the repository which can significantly speed up cloning for
repositories with a large number of commits or old, large binaries. The value is
passed to `git fetch` and `git clone`.

你可以指定fetch和clone的深度，通过设置`GIT_DEPTH`。这允许对存储库进行浅层克隆，可以大大加快克隆大量提交的存储库或旧的大型二进制文件的速度。`GIT_DEPTH`的值将传给`git fetch`和`git clone`命令。

>**Note:**
If you use a depth of 1 and have a queue of jobs or retry
jobs, jobs may fail.

如果你使用的深度为1，并且有作业列表或作业重启，作业将失败。

Since Git fetching and cloning is based on a ref, such as a branch name, Runners
can't clone a specific commit SHA. If there are multiple jobs in the queue, or
you are retrying an old job, the commit to be tested needs to be within the
Git history that is cloned. Setting too small a value for `GIT_DEPTH` can make
it impossible to run these old commits. You will see `unresolved reference` in
job logs. You should then reconsider changing `GIT_DEPTH` to a higher value.

由于Git的fetch和clone是基于ref的，例如分支名，因此，Runners不能克隆某个特定的commit。如果有多个不同的作业在等待，或者你在重启一个旧的作业，要验证的提交（commit）需要在Git克隆的历史记录中。将 `GIT_DEPTH`设置为较小的值将不能运行旧的commit？？你将在作业日志中看到`unresolved reference`。鉴于此，编者建议大家将`GIT_DEPTH`设置一个较高的值。

Jobs that rely on `git describe` may not work correctly when `GIT_DEPTH` is
set since only part of the Git history is present.

那些依赖`git describe`的作业可能不能正确地工作，当设置了`GIT_DEPTH`，由于只存在Git的部分历史记录。

To fetch or clone only the last 3 commits:

只fetch或clone最新的3个commit：

```yaml
variables:
  GIT_DEPTH: "3"
```

## Hidden keys (jobs) （作业）的隐藏key

> Introduced in GitLab 8.6 and GitLab Runner v1.1.1.

自GitLab 8.6 and GitLab Runner v1.1.1引入

If you want to temporarily 'disable' a job, rather than commenting out all the
lines where the job is defined:

如果你想临时“禁用”一项作业，而不是注释掉定义作业的所有行：


```
#hidden_job:
#  script:
#    - run test
```

you can instead start its name with a dot (`.`) and it will not be processed by
GitLab CI. In the following example, `.hidden_job` will be ignored:

你可在希望禁用的部分加上(`.`)，这样GitLab CI就不会处理该部分。在下面的例子中，`.hidden_job`将被CI忽略：

```yaml
.hidden_job:
  script:
    - run test
```

Use this feature to ignore jobs, or use the
[special YAML features](#special-yaml-features) and transform the hidden keys
into templates.

可使用此功能来忽略作业，或者使用连接中的方法将隐藏key转换为临时内容。

## Special YAML features--YAML的特殊用法

It's possible to use special YAML features like anchors (`&`), aliases (`*`)
and map merging (`<<`), which will allow you to greatly reduce the complexity
of `.gitlab-ci.yml`.


适当地使用YAML的anchors (`&`), aliases (`*`)和map merging (`<<`)等可大大地减少`.gitlab-ci.yml`的复杂性。

Read more about the various [YAML features](https://learnxinyminutes.com/docs/yaml/).

可在链接中阅读更多的内容。

### Anchors 

> Introduced in GitLab 8.6 and GitLab Runner v1.1.1.

YAML has a handy feature called 'anchors', which lets you easily duplicate
content across your document. Anchors can be used to duplicate/inherit
properties, and is a perfect example to be used with [hidden keys](#hidden-keys-jobs)
to provide templates for your jobs.

YAML有一个方便的功能叫：anchors，可以在文档中使用重复的内容。anchors可用于重复/继承属性，链接中有一个优秀的例子供你参考。

The following example uses anchors and map merging. It will create two jobs,
`test1` and `test2`, that will inherit the parameters of `.job_template`, each
having their own custom `script` defined:

以下例子使用anchor和map merging。该例子创建了两个作业：`test1`和`test2`，这两个作业继承了`.job_template`的参数，每个作业有他们各自的script：

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

&设置了该anchor名为job_definition，《《意味着合并给定的hash到当前作业。而`*`再次将anchor名（job_definition）包含进来。扩展版长这样：

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

我们在看一个例子。这次我们将使用anchors来定义两个服务集。对此，我们创建了2个作业`test:postgres`和`test:mysql`，这些作业均共享`.job_template`中定义的`script`，而各自定义services的内容：

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
展开后的例子如下：

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

您可以看到隐藏的键可以方便地用作模板。

## Triggers 触发器

Triggers can be used to force a rebuild of a specific branch, tag or commit,
with an API call.

触发此可用于特定分支、tag、提交的强制重构，通过API调用。

[Read more in the triggers documentation.](../triggers/README.md)

阅读链接中的更多内容。

### pages 主页

`pages` is a special job that is used to upload static content to GitLab that
can be used to serve your website. It has a special syntax, so the two
requirements below must be met:

pages是一个特殊的作业，用于上载静态内容到GitLab以加载你的网页。它有特定的语法，因此必须按照以下两个必填项。

1. Any static content must be placed under a `public/` directory  任何静态内容均需要放在public/目录下；
1. `artifacts` with a path to the `public/` directory must be defined 必须在artifacts中指定pblic目录；

The example below simply moves all files from the root of the project to the
`public/` directory. The `.public` workaround is so `cp` doesn't also copy
`public/` to itself in an infinite loop:

以下例子只简单地移动根目录下的所有文件到项目的public目录。使用.public的原因是这样cp不会复制public/自己在一个无限循环：

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

可在链接中阅读关于Pages的更多内容。

## Validate the .gitlab-ci.yml 使.gitlab-ci.yml生效

Each instance of GitLab CI has an embedded debug tool called Lint.
You can find the link under `/ci/lint` of your gitlab instance.

每个GitLab CI实例都有一个叫Lint的调试工具。你可以在gitlab实例的`/ci/lint`目录下找到该链接。

## Using reserved keywords 使用保留的关键词

If you get validation error when using specific values (e.g., `true` or `false`),
try to quote them, or change them to a different form (e.g., `/bin/true`).

如果你在使用某个特定值时收到验证错误。（如，true或false），请尝试将这些值加上引号，或将其改为另一种格式（如：`/bin/true`）。

## Skipping jobs 跳过作业

If your commit message contains `[ci skip]` or `[skip ci]`, using any
capitalization, the commit will be created but the jobs will be skipped.

如果你的提交日志包含`[ci skip]` or `[skip ci]`字眼，不区分大小写，该commit将被创建但跳过ci作业。

## Examples 举个例子

Visit the [examples README][examples] to see a list of examples using GitLab
CI with various languages.

访问链接中的例子以查看一系列如何在不同语言中使用GitLab CI。

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
