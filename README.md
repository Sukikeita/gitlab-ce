# GitLab

[![Build status](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-ce/commits/master)
[![Overall test coverage](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg)](https://gitlab.com/gitlab-org/gitlab-ce/pipelines)
[![Dependency Status](https://gemnasium.com/gitlabhq/gitlabhq.svg)](https://gemnasium.com/gitlabhq/gitlabhq)
[![Code Climate](https://codeclimate.com/github/gitlabhq/gitlabhq.svg)](https://codeclimate.com/github/gitlabhq/gitlabhq)
[![Core Infrastructure Initiative Best Practices](https://bestpractices.coreinfrastructure.org/projects/42/badge)](https://bestpractices.coreinfrastructure.org/projects/42)
[![Gitter](https://badges.gitter.im/gitlabhq/gitlabhq.svg)](https://gitter.im/gitlabhq/gitlabhq?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Test coverage

- [![Ruby coverage](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg?job=coverage)](https://gitlab-org.gitlab.io/gitlab-ce/coverage-ruby) Ruby
- [![JavaScript coverage](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg?job=karma)](https://gitlab-org.gitlab.io/gitlab-ce/coverage-javascript) JavaScript

## Canonical source

The canonical source of GitLab Community Edition is [hosted on GitLab.com](https://gitlab.com/gitlab-org/gitlab-ce/).

## Open source software to collaborate on code

To see how GitLab looks please see the [features page on our website](https://about.gitlab.com/features/).

- Manage Git repositories with fine grained access controls that keep your code secure
- Perform code reviews and enhance collaboration with merge requests
- Complete continuous integration (CI) and CD pipelines to builds, test, and deploy your applications
- Each project can also have an issue tracker, issue board, and a wiki
- Used by more than 100,000 organizations, GitLab is the most popular solution to manage Git repositories on-premises
- Completely free and open source (MIT Expat license)

## Hiring

We're hiring developers, support people, and production engineers all the time, please see our [jobs page](https://about.gitlab.com/jobs/).

## Editions--Gitlab版本

There are two editions of GitLab:
Gitlab有两个版本：

- GitLab Community Edition (CE) is available freely under the MIT Expat license.
- GitLab Enterprise Edition (EE) includes [extra features](https://about.gitlab.com/products/#compare-options) that are more useful for organizations with more than 100 users. To use EE and get official support please [become a subscriber](https://about.gitlab.com/products/).

## Website--网页

On [about.gitlab.com](https://about.gitlab.com/) you can find more information about:

- [Subscriptions](https://about.gitlab.com/pricing/)
- [Consultancy](https://about.gitlab.com/consultancy/)
- [Community](https://about.gitlab.com/community/) 社区
- [Hosted GitLab.com](https://about.gitlab.com/gitlab-com/) use GitLab as a free service  使用Gitlab作为免费服务
- [GitLab Enterprise Edition](https://about.gitlab.com/features/#enterprise) with additional features aimed at larger organizations.Gitlab企业版
- [GitLab CI](https://about.gitlab.com/gitlab-ci/) a continuous integration (CI) server that is easy to integrate with GitLab. 集成Gitlab的CI服务器

## Requirements 要求

Please see the [requirements documentation](doc/install/requirements.md) for system requirements and more information about the supported operating systems.

请参阅[requirements documentation](doc/install/requirements.md)以了解有关支持的操作系统的更多信息。

## Installation 安装

The recommended way to install GitLab is with the [Omnibus packages](https://about.gitlab.com/downloads/) on our package server.
Compared to an installation from source, this is faster and less error prone.
Just select your operating system, download the respective package (Debian or RPM) and install it using the system's package manager.

推荐的安装GitLab的方法是使用我们的软件包服务器上的Omnibus软件包。 与来自源代码的安装相比，这是更快，更少出错。 只需选择您的操作系统，下载相应的软件包（Debian或RPM），然后使用系统的软件包管理器进行安装。


There are various other options to install GitLab, please refer to the [installation page on the GitLab website](https://about.gitlab.com/installation/) for more information.

安装GitLab还有其他各种选项，请参阅[installation page on the GitLab website](https://about.gitlab.com/installation/)以获取更多信息。

You can access a new installation with the login **`root`** and password **`5iveL!fe`**, after login you are required to set a unique password.

您可以使用**`root`**登录和密码**`5iveL!fe`**访问新安装的Gitlab，登录后您需要设置唯一密码。

## Contributing 贡献

GitLab is an open source project and we are very happy to accept community contributions. Please refer to [CONTRIBUTING.md](/CONTRIBUTING.md) for details.

GitLab是一个开源项目，我们很高兴接受社区贡献。 有关详细信息，请参阅[CONTRIBUTING.md](/CONTRIBUTING.md)。

## Install a development environment-搭建开发环境

To work on GitLab itself, we recommend setting up your development environment with [the GitLab Development Kit](https://gitlab.com/gitlab-org/gitlab-development-kit).
If you do not use the GitLab Development Kit you need to install and setup all the dependencies yourself, this is a lot of work and error prone.
One small thing you also have to do when installing it yourself is to copy the example development unicorn configuration file:

要使用GitLab本身，我们建议使用GitLab开发工具包设置开发环境[the GitLab Development Kit](https://gitlab.com/gitlab-org/gitlab-development-kit).。 如果你不使用GitLab开发工具包，你需要自己安装和设置所有的依赖关系，这是很多工作和容易出错。 你自己安装时还需要做一件小事，就是复制一个独特的开发unicorn配置文件：


    cp config/unicorn.rb.example.development config/unicorn.rb

Instructions on how to start GitLab and how to run the tests can be found in the [getting started section of the GitLab Development Kit](https://gitlab.com/gitlab-org/gitlab-development-kit#getting-started).

有关如何启动GitLab以及如何运行测试的说明可以在GitLab开发工具包的入门[getting started section of the GitLab Development Kit](https://gitlab.com/gitlab-org/gitlab-development-kit#getting-started)部分找到。

## Software stack--软件堆栈

GitLab is a Ruby on Rails application that runs on the following software:
GitLab是一个运行在以下软件上的Ruby on Rails的应用程序：

- Ubuntu/Debian/CentOS/RHEL/OpenSUSE
- Ruby (MRI) 2.3
- Git 2.8.4+
- Redis 2.8+
- PostgreSQL (preferred) or MySQL

For more information please see the [architecture documentation](https://docs.gitlab.com/ce/development/architecture.html).

有关更多信息，请参阅体系结构文档 [architecture documentation](https://docs.gitlab.com/ce/development/architecture.html)。

## UX design

Please adhere to the [UX Guide](doc/development/ux_guide/index.md) when creating designs and implementing code.

创建设计和实现代码时，请遵守UX指南[UX Guide](doc/development/ux_guide/index.md)。

## Third-party applications--第三方应用

There are a lot of [third-party applications integrating with GitLab](https://about.gitlab.com/applications/). These include GUI Git clients, mobile applications and API wrappers for various languages.

有很多与GitLab集成的第三方应用程序。 这些包括GUI Git客户端，移动应用程序和各种语言的API包装。

## GitLab release cycle--Gitlab发布周期

For more information about the release process see the [release documentation](https://gitlab.com/gitlab-org/release-tools/blob/master/README.md).

有关发布流程的更多信息，请参阅发布文档[release documentation](https://gitlab.com/gitlab-org/release-tools/blob/master/README.md)。

## Upgrading--更新

For upgrading information please see our [update page](https://about.gitlab.com/update/).

有关升级信息，请参阅我们的更新页面[update page](https://about.gitlab.com/update/)。

## Documentation--文档

All documentation can be found on [docs.gitlab.com/ce/](https://docs.gitlab.com/ce/).
所有文档都可以在[docs.gitlab.com/ce/](https://docs.gitlab.com/ce/)上找到。


## Getting help--获取帮助

Please see [Getting help for GitLab](https://about.gitlab.com/getting-help/) on our website for the many options to get help.

请参阅在我们的网站[Getting help for GitLab](https://about.gitlab.com/getting-help/)上获取有关GitLab的帮助，以获取帮助。

## Is it any good?-有什么好处？

[Yes](https://news.ycombinator.com/item?id=3067434)

## Is it awesome?-棒不棒？

Thanks for [asking this question](https://twitter.com/supersloth/status/489462789384056832) Joshua.
[These people](https://twitter.com/gitlab/likes) seem to like it.
谢谢你问这个问题约书亚。 这些人似乎喜欢它。

