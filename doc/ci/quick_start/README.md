# Getting started with GitLab CI/CD 使用CI、CD

>**Note:** Starting from version 8.0, GitLab [Continuous Integration][ci] (CI)
is fully integrated into GitLab itself and is [enabled] by default on all
projects. 注意：从版本8.0开始，GitLab持续集成（CI）完全集成到GitLab本身，并在所有项目中默认启用。


GitLab offers a [continuous integration][ci] service. If you
[add a `.gitlab-ci.yml` file][yaml] to the root directory of your repository,
and configure your GitLab project to use a [Runner], then each commit or
push, triggers your CI [pipeline].

GitLab提供持续集成服务。 如果将.gitlab-ci.yml文件添加到存储库的根目录，并将GitLab项目配置为使用Runner，则每次提交或推送都将触发您的CI管道。

The `.gitlab-ci.yml` file tells the GitLab runner what to do. By default it runs
a pipeline with three [stages]: `build`, `test`, and `deploy`. You don't need to
use all three stages; stages with no jobs are simply ignored.

.gitlab-ci.yml文件告诉GitLab runner做什么。 默认情况下，它运行有三个阶段的管道：构建，测试和部署。 你不需要使用全部三个阶段; 没有工作的阶段被简单地忽略。

If everything runs OK (no non-zero return values), you'll get a nice green
checkmark associated with the commit. This makes it
easy to see whether a commit caused any of the tests to fail before
you even look at the code.

如果一切运行正常（没有非零返回值），你会得到一个很好的绿色复选标记与提交相关联。 在查看代码之前，可以很容易地看到提交是否导致任何测试失败。

Most projects use GitLab's CI service to run the test suite so that
developers get immediate feedback if they broke something.

大多数项目都使用GitLab的CI服务来运行测试套件，以便开发人员在出现问题时能立即获得反馈。

There's a growing trend to use continuous delivery and continuous deployment to
automatically deploy tested code to staging and production environments.

使用持续交付和持续部署将测试代码自动部署到分段和生产环境的趋势日益增长。

So in brief, the steps needed to have a working CI can be summed up to:

所以简而言之，需要有一个工作CI的步骤可以概括为：

1. Add `.gitlab-ci.yml` to the root directory of your repository将.gitlab-ci.yml添加到存储库的根目录

1. Configure a Runner 配置一个Runner

From there on, on every push to your Git repository, the Runner will
automagically start the pipeline and the pipeline will appear under the
project's **Pipelines** page.

从那里开始，在每次推送到Git仓库时，Runner将自动启动管道，管道将显示在项目的Pipelines页面下。

---

This guide assumes that you:本指南假设您：


- have a working GitLab instance of version 8.0+r or are using
  [GitLab.com](https://gitlab.com)有一个工作的版本8.0 + R的GitLab实例或正在使用GitLab.com
  
- have a project in GitLab that you would like to use CI for 在GitLab中有一个你想使用CI的项目


Let's break it down to pieces and work on solving the GitLab CI puzzle.

让我们把它分解成几部分，并解决GitLab CI难题。

## Creating a `.gitlab-ci.yml` file 创建一个.gitlab-ci.yml文件

Before you create `.gitlab-ci.yml` let's first explain in brief what this is
all about.

在创建.gitlab-ci.yml之前，让我们首先简单地解释一下这是怎么回事。

### What is `.gitlab-ci.yml` 什么是.gitlab-ci.yml


The `.gitlab-ci.yml` file is where you configure what CI does with your project.
It lives in the root of your repository.

.gitlab-ci.yml文件是在您的项目中配置CI使用具体功能的配置文件。 它存在于你的仓库的根目录。

On any push to your repository, GitLab will look for the `.gitlab-ci.yml`
file and start jobs on _Runners_ according to the contents of the file,
for that commit.

在任何推送到你的仓库的时候，GitLab都会查找.gitlab-ci.yml文件，并根据该文件的内容在Runners上针对该提交启动作业。

Because `.gitlab-ci.yml` is in the repository and is version controlled, old
versions still build successfully, forks can easily make use of CI, branches can
have different pipelines and jobs, and you have a single source of truth for CI.
You can read more about the reasons why we are using `.gitlab-ci.yml` [in our
blog about it][blog-ci].

由于.gitlab-ci.yml位于版本库中，受版本控制，旧版本仍然可以成功构建，复刻可以很容易地使用CI，分支可以有不同的流水线和作业，并且CI拥有唯一的真实来源。 你可以阅读更多关于我们在我们的博客中使用.gitlab-ci.yml的原因。

### Creating a simple `.gitlab-ci.yml` file--创建简单的.gitlab-ci.yml

>**Note:**
`.gitlab-ci.yml` is a [YAML](https://en.wikipedia.org/wiki/YAML) file
so you have to pay extra attention to indentation. Always use spaces, not tabs.--.gitlab-ci.yml是一个YAML文件，因此你在使用缩进的时候要注意--总是使用空格，而不是tabs。

You need to create a file named `.gitlab-ci.yml` in the root directory of your
repository. Below is an example for a Ruby on Rails project.

你需要在根目录创建一个名为.gitlab-ci.yml的文件，以下是一个Ruby on Rails项目的例子：
```yaml
before_script:
  - apt-get update -qq && apt-get install -y -qq sqlite3 libsqlite3-dev nodejs
  - ruby -v
  - which ruby
  - gem install bundler --no-ri --no-rdoc
  - bundle install --jobs $(nproc)  "${FLAGS[@]}"

rspec:
  script:
    - bundle exec  
    

rubocop:
  script:
    - bundle exec rubocop
```

This is the simplest possible configuration that will work for most Ruby
applications:

这是最适合大多数Ruby应用程序的最简单的配置：

1. Define two jobs `rspec` and `rubocop` (the names are arbitrary) with
   different commands to be executed.用不同的命令定义两个作业rspec和rubocop（名字是任意的）来执行。
1. Before every job, the commands defined by `before_script` are executed.在每个工作之前，执行由before_script定义的命令。


The `.gitlab-ci.yml` file defines sets of jobs with constraints of how and when
they should be run. The jobs are defined as top-level elements with a name (in
our case `rspec` and `rubocop`) and always have to contain the `script` keyword.
Jobs are used to create jobs, which are then picked by
[Runners](../runners/README.md) and executed within the environment of the Runner.

.gitlab-ci.yml文件定义了一系列作业，包括如何以及何时应该运行的约束。 作业被定义为具有名称的顶级元素（在我们的例子中是rspec和rubocop），并且总是必须包含script关键字。 作业被用来创建作业，然后由Runner挑选并在Runner的环境中执行。

What is important is that each job is run independently from each other.

重要的是每项工作都是相互独立的。

If you want to check whether your `.gitlab-ci.yml` file is valid, there is a
Lint tool under the page `/ci/lint` of your GitLab instance. You can also find
a "CI Lint" button to go to this page under **CI/CD ➔ Pipelines** and
**Pipelines ➔ Jobs** in your project.

如果你想检查你的.gitlab-ci.yml文件是否有效，你的GitLab实例的page/ci/lint下有一个Lint工具。 您还可以在CI/CD➔管道和管道➔项目中的作业下找到“CI Lint”按钮。

For more information and a complete `.gitlab-ci.yml` syntax, please read
[the reference documentation on .gitlab-ci.yml](../yaml/README.md).

有关更多信息和完整的.gitlab-ci.yml语法，请阅读.gitlab-ci.yml的参考文档。

### Push `.gitlab-ci.yml` to GitLab--将.gitlab-ci.yml推送到GitLab

Once you've created `.gitlab-ci.yml`, you should add it to your Git repository
and push it to GitLab.

一旦你创建了.gitlab-ci.yml，你应该把它添加到你的Git仓库，并将其推送到GitLab。

```bash
git add .gitlab-ci.yml
git commit -m "Add .gitlab-ci.yml"
git push origin master
```

Now if you go to the **Pipelines** page you will see that the pipeline is
pending.

现在，如果你进入管道页面，你会看到管道正在等待处理。

You can also go to the **Commits** page and notice the little pause icon next
to the commit SHA.

您也可以转到提交页面，注意提交SHA旁边的小暂停图标。

![New commit pending](img/new_commit.png)

Clicking on it you will be directed to the jobs page for that specific commit.

点击它，你将被定向到特定提交的作业页面。

![Single commit jobs page](img/single_commit_status_pending.png)

Notice that there are two jobs pending which are named after what we wrote in
`.gitlab-ci.yml`. The red triangle indicates that there is no Runner configured
yet for these jobs.

请注意，有两个作业挂起，以我们在.gitlab-ci.yml中编写的内容命名。 红色的三角形表示没有配置Runner用于这些作业。

The next step is to configure a Runner so that it picks the pending jobs.

下一步是配置一个Runner，以便它选择待处理（pending）的作业。

## Configuring a Runner--配置Runner

In GitLab, Runners run the jobs that you define in `.gitlab-ci.yml`. A Runner
can be a virtual machine, a VPS, a bare-metal machine, a docker container or
even a cluster of containers. GitLab and the Runners communicate through an API,
so the only requirement is that the Runner's machine has [Internet] access.

在GitLab中，Runner运行你在.gitlab-ci.yml中定义的工作。 Runner可以是虚拟机，VPS，裸机，Docker容器甚至容器箱集群。 GitLab和Runners通过API进行通信，因此唯一的要求是Runner的机器可以访问Internet。

A Runner can be specific to a certain project or serve multiple projects in
GitLab. If it serves all projects it's called a _Shared Runner_.

Runner可以是特定的项目或服务于GitLab中的多个项目。 如果它为所有项目提供服务，则称为“共享运行程序”。

Find more information about different Runners in the
[Runners](../runners/README.md) documentation.

在Runner文档中找到有关不同Runner的更多信息。

You can find whether any Runners are assigned to your project by going to
**Settings ➔ CI/CD**. Setting up a Runner is easy and straightforward. The
official Runner supported by GitLab is written in Go and its documentation
can be found at <https://docs.gitlab.com/runner/>.

您可以通过转到 **Settings ➔ CI/CD** 来查找是否有任何Runner分配到您的项目中。 建立一个Runner是简单而直接的。 GitLab支持的官方Runner使用Go编写，其文档可以在https://docs.gitlab.com/runner/上找到。

In order to have a functional Runner you need to follow two steps:

为了有一个功能Runner你需要遵循两个步骤：

1. [Install it][runner-install]--安装Runner
2. [Configure it](../runners/README.md#registering-a-specific-runner)--配置Runner

Follow the links above to set up your own Runner or use a Shared Runner as
described in the next section.

按照上面的链接设置您自己的Runner或使用Shared Runner，如下一节所述。

Once the Runner has been set up, you should see it on the Runners page of your
project, following **Settings ➔ CI/CD**.

Runner设置完成后，您应该在项目的Runner页面上看到 **Settings ➔ CI/CD** 。

![Activated runners](img/runners_activated.png)

### Shared Runners--共享Runner

If you use [GitLab.com](https://gitlab.com/) you can use the **Shared Runners**
provided by GitLab Inc.

如果您使用GitLab.com，则可以使用由GitLab Inc.提供的  **Shared Runners** 。

These are special virtual machines that run on GitLab's infrastructure and can
build any project.

这些是运行在GitLab基础架构上的特殊虚拟机，可以构建任何项目。

To enable the **Shared Runners** you have to go to your project's
**Settings ➔ CI/CD** and click **Enable shared runners**.

要启用 **Shared Runners** ，您必须转到项目的 **Settings ➔ CI/CD**，然后单击“启用共享运行程序”。

[Read more on Shared Runners](../runners/README.md). 想要了解更多，请查看链接。

## Seeing the status of your pipeline and jobs--看到你的管道和工作的状态

After configuring the Runner successfully, you should see the status of your
last commit change from _pending_ to either _running_, _success_ or _failed_.

成功配置Runner后，您应该看到最后一次提交从待处理状态变为正在运行（_pending_到_running_），成功或失败。

You can view all pipelines by going to the **Pipelines** page in your project.

您可以通过转至项目中的“管道”页面来查看所有管道。

![Commit status](img/pipelines_status.png)

Or you can view all jobs, by going to the **Pipelines ➔ Jobs** page.

或者，您可以查看所有作业，方法是前往“管道”➔“作业”页面。

![Commit status](img/builds_status.png)

By clicking on a job's status, you will be able to see the log of that job.
This is important to diagnose why a job failed or acted differently than
you expected.

通过点击一个工作的状态，你将能够看到该工作的日志。 这对于诊断工作失败或行为不同于预期的重要性很重要。

![Build log](img/build_log.png)

You are also able to view the status of any commit in the various pages in
GitLab, such as **Commits** and **Merge requests**.

你也可以在GitLab的各个页面中查看任何提交的状态，例如  **Commits** 和 **Merge requests**。

## Examples--例子

Visit the [examples README][examples] to see a list of examples using GitLab
CI with various languages.

访问示例自述文件，查看使用各种语言的GitLab CI的示例列表。

[runner-install]: https://docs.gitlab.com/runner/install/
[blog-ci]: https://about.gitlab.com/2015/05/06/why-were-replacing-gitlab-ci-jobs-with-gitlab-ci-dot-yml/
[examples]: ../examples/README.md
[ci]: https://about.gitlab.com/gitlab-ci/
[yaml]: ../yaml/README.md
[runner]: ../runners/README.md
[enabled]: ../enable_or_disable_ci.md
[stages]: ../yaml/README.md#stages
[pipeline]: ../pipelines.md
[internet]: https://about.gitlab.com/images/theinternet.png
