---
comments: false
---

# GitLab Continuous Integration (GitLab CI)

![Pipeline graph](img/cicd_pipeline_infograph.png)

The benefits of Continuous Integration are huge when automation plays an
integral part of your workflow. GitLab comes with built-in Continuous
Integration, Continuous Deployment, and Continuous Delivery support to build,
test, and deploy your application.

持续集成的好处是巨大的，当自动化扮演你的工作流程的一个组成部分。 GitLab内置持续集成，持续部署和持续交付支持来构建，测试和部署应用程序。

Here's some info we've gathered to get you started.

以下是我们收集的一些信息，以帮助您入门。

## Getting started--开始啦

The first steps towards your GitLab CI journey.

走向GitLab CI旅程的第一步。

- [Getting started with GitLab CI 快速入门指南](quick_start/README.md)（已翻译）
- [Pipelines and jobs 流水线和作业](pipelines.md)（已翻译）
- [Configure a Runner, the application that runs your jobs 配置Runner运行作业](runners/README.md)（已翻译）
- **Articles文章:**
  - [Getting started with GitLab and GitLab CI - Intro to CI CI简介](https://about.gitlab.com/2015/12/14/getting-started-with-gitlab-and-gitlab-ci/)
  - [ ] [Continuous Integration, Delivery, and Deployment with GitLab - Intro to CI/CD 使用GitLab持续集成、交付和部署](https://about.gitlab.com/2016/08/05/continuous-integration-delivery-and-deployment-with-gitlab/)（已翻译）
  - [GitLab CI: Run jobs sequentially, in parallel, or build a custom pipeline 线性运行作业、并行运行作业或构件自定义的流水线](https://about.gitlab.com/2016/07/29/the-basics-of-gitlab-ci/)
  - [Setting up GitLab Runner For Continuous Integration安装GitLab-Runner做持续集成](https://about.gitlab.com/2016/03/01/gitlab-runner-with-docker/)
  - [GitLab CI: Deployment & environments 部署和环境](https://about.gitlab.com/2016/08/26/ci-deployment-and-environments/)
- **Videos视频:**
  - [Demo (Streamed live on Jul 17, 2017): GitLab CI/CD Deep Dive](https://youtu.be/pBe4t1CD8Fc?t=195)
  - [Demo (March, 2017): how to get started using CI/CD with GitLab--GitLab CI/CD入门](https://about.gitlab.com/2017/03/13/ci-cd-demo/)
  - [Webcast (April, 2016): getting started with CI in GitLab-在GitLab中使用CI](https://about.gitlab.com/2016/04/20/webcast-recording-and-slides-introduction-to-ci-in-gitlab/)
- **Third-party videos:第三方的视频**
  - [Integration continue avec GitLab (September, 2016)](https://www.youtube.com/watch?v=URcMBXjIr24&t=13s)
  - [GitLab CI for Minecraft Plugins (July, 2016)](https://www.youtube.com/watch?v=Z4pcI9F8yf8)

## Reference guides--引用指南

Once you get familiar with the getting started guides, you'll find yourself
digging into specific reference guides.
一旦你熟悉入门指南，你会发现自己挖掘到特定的参考指南。


- [`.gitlab-ci.yml` reference](yaml/README.md) - Learn all about the ins and
  outs of `.gitlab-ci.yml` definitions--学习所有有关`.gitlab-ci.yml`的所有定义（已翻译）
- [CI Variables](variables/README.md) - Learn how to use variables defined in
  your `.gitlab-ci.yml` or secured ones defined in your project's settings--（未翻译完）学习如何在`.gitlab-ci.yml`使用变量或定义一个安装的变量
- **The permissions model权限模式** - Learn about the access levels a user can have for
  performing certain CI actions--了解普通用户执行CI的访问权限
  - [User permissions--用户权限](../user/permissions.md#gitlab-ci)
  - [Job permissions--作业权限](../user/permissions.md#job-permissions)

## Auto DevOps--自动化运维

- [Auto DevOps](../topics/autodevops/index.md)

## GitLab CI + Docker

Leverage the power of Docker to run your CI pipelines.
利用Docker的强大功能来运行您的CI管道。

- [Use Docker images with GitLab Runner--使用Docker镜像来运行Runner](docker/using_docker_images.md)
- [Use CI to build Docker images--使用CI来构建Docker镜像](docker/using_docker_build.md)
- [CI services (linked Docker containers)--CI服务（链接到Docker容器）](services/README.md)
- **Articles相关文章:**
  - [Setting up GitLab Runner For Continuous Integration--使用GitLab-Runner做持续集成](https://about.gitlab.com/2016/03/01/gitlab-runner-with-docker/)

## Advanced use--高级应用

Once you get familiar with the basics of GitLab CI, it's time to dive in and
learn how to leverage its potential even more.
一旦您熟悉了GitLab CI的基础知识，就可以深入了解如何充分利用其潜力。


- [Environments and deployments--环境和部署](environments.md) - Separate your jobs into
  environments and use them for different purposes like testing, building and
  deploying--根据环境分离作业，以进行测试、构建和部署等目的
- [Job artifacts--作业组件](../user/project/pipelines/job_artifacts.md)
- [Git submodules-Git子模块](git_submodules.md) - How to run your CI jobs when Git
  submodules are involved--当涉及Git子模块时，如何运行CI作业
- [Auto deploy自动化部署](autodeploy/index.md)
- [Use SSH keys in your build environment在构建环境使用SSH密钥](ssh_keys/README.md)
- [Trigger pipelines through the GitLab API--通过GitLab接口触发管道](triggers/README.md)
- [Trigger pipelines on a schedule--通过计划触发管道](../user/project/pipelines/schedules.md)

## Review Apps--代码检查

- [Review Apps](review_apps/index.md)
- **Articles:**
  - [Introducing Review Apps--代码检查结束](https://about.gitlab.com/2016/11/22/introducing-review-apps/)
  - [Example project that shows how to use Review Apps--代码检查的例子](https://gitlab.com/gitlab-examples/review-apps-nginx/)

## GitLab CI for GitLab Pages

See the topic on [GitLab Pages](../user/project/pages/index.md).

## Special configuration--特殊配置

You can change the default behavior of GitLab CI in your whole GitLab instance
as well as in each project.
您可以在整个GitLab实例以及每个项目中更改GitLab CI的默认行为。

- **Project specific--在项目中更改CI**
  - [Pipelines settings--管道设置](../user/project/pipelines/settings.md)
  - [Learn how to enable or disable GitLab CI--了解如何在项目中启动或禁用CI](enable_or_disable_ci.md)
- **Affecting the whole GitLab instance--全局中设置CI**
  - [Continuous Integration admin settings--CI管理设置](../user/admin_area/settings/continuous_integration.md)

## Examples--例子

>**Note:**
A collection of `.gitlab-ci.yml` files is maintained at the
[GitLab CI Yml project][gitlab-ci-templates].
If your favorite programming language or framework is missing we would love
your help by sending a merge request with a `.gitlab-ci.yml`.
注意：.gitlab-ci.yml文件集在GitLab CI Yml项目中维护。 如果你最喜欢的编程语言或框架没有这个文件，我们希望通过发送一个.gitlab-ci.yml合并请求来帮助你。


Here is an collection of tutorials and guides on setting up your CI pipeline.
以下是设置CI管道的指引和说明：
- [GitLab CI examples](examples/README.md) for the following languages and frameworks:
  - [PHP](examples/php.md)
  - [Ruby](examples/test-and-deploy-ruby-application-to-heroku.md)
  - [Python](examples/test-and-deploy-python-application-to-heroku.md)
  - [Clojure](examples/test-clojure-application.md)
  - [Scala](examples/test-scala-application.md)
  - [Phoenix](examples/test-phoenix-application.md)
  - [Run PHP Composer & NPM scripts then deploy them to a staging server--部署](examples/deployment/composer-npm-deploy.md)
  - [Analyze code quality with the Code Climate CLI--使用Code Climate分析代码质量](examples/code_climate.md)
- **Articles相关文献**
  - [How to test and deploy Laravel/PHP applications with GitLab CI/CD and Envoy--如何使用CI/CD和Envoy来测试和部署Laravel/PHP应用](../articles/laravel_with_gitlab_and_envoy/index.md)
  - [How to deploy Maven projects to Artifactory with GitLab CI/CD--如何部署一个Maven项目到构件](../articles/artifactory_and_gitlab/index.md)
  - [Automated Debian packaging--自动打包Debian包](https://about.gitlab.com/2016/10/12/automated-debian-package-build-with-gitlab-ci/)
  - [Spring boot application with GitLab CI and Kubernetes](https://about.gitlab.com/2016/12/14/continuous-delivery-of-a-spring-boot-application-with-gitlab-ci-and-kubernetes/)
  - [Setting up GitLab CI for iOS projects-对iOS项目设置CI](https://about.gitlab.com/2016/03/10/setting-up-gitlab-ci-for-ios-projects/)
  - [Setting up GitLab CI for Android projects-对Android项目进行CI](https://about.gitlab.com/2016/11/30/setting-up-gitlab-ci-for-android-projects/)
  - [Building a new GitLab Docs site with Nanoc, GitLab CI, and GitLab Pages--使用Nanoc、CI和Pages构建一个GItLab文档页面](https://about.gitlab.com/2016/12/07/building-a-new-gitlab-docs-site-with-nanoc-gitlab-ci-and-gitlab-pages/)
  - [CI/CD with GitLab in action](https://about.gitlab.com/2017/03/13/ci-cd-demo/)
  - [Building an Elixir Release into a Docker image using GitLab CI--使用GitLab CI构建一个Elixir发布到Docker镜像](https://about.gitlab.com/2016/08/11/building-an-elixir-release-into-docker-image-using-gitlab-ci-part-1/)
- **Miscellaneous其他**
  - [Using `dpl` as deployment tool--使用`dpl`作为部署工具](examples/deployment/README.md)
  - [Repositories with examples for various languages--各种语言例子的存储库](https://gitlab.com/groups/gitlab-examples)
  - [The .gitlab-ci.yml file for GitLab itself--GitLab本身的.gitlab-ci.yml文件](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/.gitlab-ci.yml)
  - [Example project that shows how to use Review Apps--如何进行代码审查的例子](https://gitlab.com/gitlab-examples/review-apps-nginx/)

## Integrations--集成

- **Articles相关文献:**
  - [Continuous Delivery with GitLab and Convox--使用GitLab和Convox进行持续交付](https://about.gitlab.com/2016/06/09/continuous-delivery-with-gitlab-and-convox/)
  - [Getting Started with GitLab and Shippable Continuous Integration--GitLab和Shippable Continuous Integration的入门指南](https://about.gitlab.com/2016/05/05/getting-started-gitlab-and-shippable/)
  - [GitLab Partners with DigitalOcean to make Continuous Integration faster, safer, and more affordable--使用DigitalOcean与GitLab合作，是CI更快、安全和更实惠](https://about.gitlab.com/2016/04/19/gitlab-partners-with-digitalocean-to-make-continuous-integration-faster-safer-and-more-affordable/)

## Why GitLab CI?为什么做GitLab CI？

- **Articles相关文献:**
  - [Why We Chose GitLab CI for our CI/CD Solution--为什么选择GitLab CI作为我们的CI/CD解决方案](https://about.gitlab.com/2016/10/17/gitlab-ci-oohlala/)
  - [Building our web-app on GitLab CI: 5 reasons why Captain Train migrated from Jenkins to GitLab CI--在GitLab CI上构建我们的Web应用程序：Captain Train从Jenkins迁移到GitLab CI的5个理由
  ](https://about.gitlab.com/2016/07/22/building-our-web-app-on-gitlab-ci/)

## Breaking changes--

- [CI variables renaming for GitLab 9.0](variables/README.md#9-0-renaming) Read about the
  deprecated CI variables and what you should use for GitLab 9.0+.为GitLab 9.0重命名CI变量。阅读有关不推荐使用的CI变量以及GitLab 9.0+应该使用哪些变量。
- [New CI job permissions model--新的作业访问模型](../user/project/new_ci_build_permissions_model.md)
  Read about what changed in GitLab 8.12 and how that affects your jobs.
  There's a new way to access your Git submodules and LFS objects in jobs.
  阅读GitLab 8.12中的变化以及这些变化对您的作业的影响。 有一种新的方式来访问作业中的Git子模块和LFS对象。
  

[gitlab-ci-templates]: https://gitlab.com/gitlab-org/gitlab-ci-yml
