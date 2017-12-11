# Auto Deploy--自动化部署

> [Introduced][mr-8135] in GitLab 8.15.
> Auto deploy is an experimental feature and is **not recommended for Production use** at this time.在GitLab 8.15中引入。 自动部署是一项实验性功能，目前不推荐用于生产。

> As of GitLab 9.1, access to the container registry is only available while the
Pipeline is running. Restarting a pod, scaling a service, or other actions which
require on-going access **will fail**. On-going secure access is planned for a
subsequent release.
从GitLab 9.1开始，只有在管道（Pipeline）运行时才能访问容器注册表。 重新启动pod，缩放服务或其他需要持续访问的操作将会失败。 计划在后续版本中持续进行安全访问。


> As of GitLab 10.0, Auto Deploy templates are **deprecated** and the
functionality has been included in [Auto
DevOps](../../topics/autodevops/index.md).
从GitLab 10.0开始，Auto Deploy模板已被弃用，并且该功能已包含在Auto DevOps中。


Auto deploy is an easy way to configure GitLab CI for the deployment of your
application. GitLab Community maintains a list of `.gitlab-ci.yml`
templates for various infrastructure providers and deployment scripts
powering them. These scripts are responsible for packaging your application,
setting up the infrastructure and spinning up necessary services (for
example a database).

自动部署是配置GitLab CI以部署应用程序的简单方法。 GitLab社区为各种基础架构提供商和部署脚本提供.gitlab-ci.yml模板列表。 这些脚本负责打包应用程序，设置基础架构并启动必要的服务（例如数据库）。

## How it works--工作原理

The Autodeploy templates are based on the [kubernetes-deploy][kube-deploy]
project which is used to simplify the deployment process to Kubernetes by
providing intelligent `build`, `deploy`, and `destroy` commands which you can
use in your `.gitlab-ci.yml` as is. It uses [Herokuish](https://github.com/gliderlabs/herokuish),
which uses [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks)
to do some of the work, plus some of GitLab's own tools to package it all up. For
your convenience, a [Docker image][kube-image] is also provided.

Autodeploy模板基于kubernetes-deploy项目，通过提供智能`build`, `deploy`,和 `destroy`命令，这些命令可以在.gitlab-ci.yml中使用，从而简化对Kubernetes的部署过程。 它使用Herokuish，而Herokuish使用Heroku buildpack来完成一些工作，再加上一些GitLab自己的工具来打包。 为了您的方便，还提供了一个Docker镜像。

You can use the [Kubernetes project service](../../user/project/integrations/kubernetes.md)
to store credentials to your infrastructure provider and they will be available
during the deployment.

您可以使用Kubernetes项目服务将凭证（credentials）存储到您的基础架构提供商，并在部署期间可用。


## Quick start--快速入门

We made a [simple guide](quick_start_guide.md) to using Auto Deploy with GitLab.com.
我们整理了一份markdown文档教你如何在GitLab使用自动化部署。（quick_start_guide.md）

## Supported templates--支持的模板

The list of supported auto deploy templates is available in the
[gitlab-ci-yml project][auto-deploy-templates].

受支持的自动部署模板列表在gitlab-ci-yml项目中可用。

## Configuration--配置

>**Note:**
In order to understand why the following steps are required, read the
[how it works](#how-it-works) section.

注意：为了理解为什么需要执行以下步骤，请阅读工作原理部分。

To configure Autodeploy, you will need to:

为了配置自动化部署，你将需要：

1. Enable a deployment [project service][project-services] to store your
   credentials. For example, if you want to deploy to OpenShift you have to
   enable [Kubernetes service][kubernetes-service].启用部署项目服务来存储您的凭证。 例如，如果您要部署到OpenShift，则必须启用Kubernetes服务。
   
1. Configure GitLab Runner to use the
   [Docker or Kubernetes executor](https://docs.gitlab.com/runner/executors/) with
   [privileged mode enabled][docker-in-docker].--将GitLab Runner启用了privileged模式的Docker或Kubernetes执行程序。
   
1. Navigate to the "Project" tab and click "Set up auto deploy" button.--导航到“项目”选项卡，然后单击“设置自动部署”按钮。
   ![Auto deploy button](img/auto_deploy_button.png)
1. Select a template.--选择一个模板
  ![Dropdown with auto deploy templates](img/auto_deploy_dropdown.png)
1. Commit your changes and create a merge request.--提交变更并创建一个merge请求
1. Test your deployment configuration using a [Review App][review-app] that was
   created automatically for you.--使用为您自动创建的Review App测试您的部署配置。


## Private project support--私人项目的支持

> Experimental support [introduced][mr-2] in GitLab 9.1.

When a project has been marked as private, GitLab's [Container Registry][container-registry] requires authentication when downloading containers. Auto deploy will automatically provide the required authentication information to Kubernetes, allowing temporary access to the registry. Authentication credentials will be valid while the pipeline is running, allowing for a successful initial deployment.

当一个项目被标记为私有时，GitLab的Container Registry在下载容器时需要验证。 自动部署将自动向Kubernetes提供所需的身份验证信息，允许临时访问注册表。 身份验证凭据将在管道运行时有效，从而可以成功进行初始部署。

After the pipeline completes, Kubernetes will no longer be able to access the container registry. Restarting a pod, scaling a service, or other actions which require on-going access to the registry will fail. On-going secure access is planned for a subsequent release.

pipeline完成后，Kubernetes将不再能够访问容器注册表。 重新启动pod、扩展服务苟泽其他需要持续访问注册表的操作将失败。 计划在后续版本中持续进行安全访问。

## PostgreSQL database support--PostgreSQL数据库支持

> Experimental support [introduced][mr-8] in GitLab 9.1.--在GitLab 9.1中引入了实验支持。

In order to support applications that require a database, [PostgreSQL][postgresql] is provisioned by default. Credentials to access the database are preconfigured, but can be customized by setting the associated [variables](#postgresql-variables). These credentials can be used for defining a `DATABASE_URL` of the format: `postgres://user:password@postgres-host:postgres-port/postgres-database`. It is important to note that the database itself is temporary, and contents will be not be saved.

为了支持需要数据库的应用程序，PostgreSQL默认被调配。 访问数据库的凭证是预配置的，但可以通过设置相关的变量进行定制。 这些凭据可用于定义格式为`DATABASE_URL`: `postgres://user:password@postgres-host:postgres-port/postgres-database`。 请注意，数据库本身是暂时的，内容将不会被保存。

PostgreSQL provisioning can be disabled by setting the variable `DISABLE_POSTGRES` to `"yes"`.

可以通过将变量DISABLE_POSTGRES设置为“yes”来禁用PostgreSQL配置。

The following PostgreSQL variables are supported:

支持以下PostgreSQL变量：

1. `DISABLE_POSTGRES: "yes"`: disable automatic deployment of PostgreSQL--禁用PostgreSQL的自动化部署；
1. `POSTGRES_USER: "my-user"`: use custom username for PostgreSQL--使用PostgreSQL自定义用户名；
1. `POSTGRES_PASSWORD: "password"`: use custom password for PostgreSQL--使用PostgreSQL自定义密码；
1. `POSTGRES_DB: "my database"`: use custom database name for PostgreSQL--使用PostgreSQL自定义数据库名；

## Auto Monitoring--自动化监控

> Introduced in [GitLab 9.5](https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/13438).自GitLab 9.5引入

Apps auto-deployed using one the [Kubernetes templates](#supported-templates) can also be automatically monitored for:

使用一个Kubernetes模板自动部署的应用程序也可以被自动监控：

* Response Metrics: latency, throughput, error rate--响应度量标准：延迟，吞吐量，错误率
* System Metrics: CPU utilization, memory utilization--系统度量标准：CPU利用率，内存利用率

Metrics are gathered from [nginx-ingress](../../user/project/integrations/prometheus_library/nginx_ingress.md) and [Kubernetes](../../user/project/integrations/prometheus_library/kubernetes.md).

指标来自nginx-ingress和Kubernetes。

To view the metrics, open the [Monitoring dashboard for a deployed environment](../environments.md#monitoring-environments).

要查看度量标准，请打开Monitoring dashboard for a deployed environment仪表板。

![Auto Metrics](img/auto_monitoring.png)

### Configuring Auto Monitoring--配置自动化监控

If GitLab has been deployed using the [omnibus-gitlab](../../install/kubernetes/gitlab_omnibus.md) Helm chart, no configuration is required.

如果GitLab已经使用omnibus-gitlab Helm图表进行部署，则不需要进行配置。

If you have installed GitLab using a different method:

如果您使用其他方法安装了GitLab，请执行以下操作：

1. [Deploy Prometheus](../../user/project/integrations/prometheus.md#configuring-your-own-prometheus-server-within-kubernetes) into your Kubernetes cluster--将Prometheus部署到您的Kubernetes集群中；
1. If you would like response metrics, ensure you are running at least version 0.9.0 of NGINX Ingress and [enable Prometheus metrics](https://github.com/kubernetes/ingress/blob/master/examples/customization/custom-vts-metrics/nginx/nginx-vts-metrics-conf.yaml).--如果您需要响应指标，请确保您至少运行NGINX Ingress 0.9.0版，并启用Prometheus指标。
1. Finally, [annotate](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) the NGINX Ingress deployment to be scraped by Prometheus using `prometheus.io/scrape: "true"` and `prometheus.io/port: "10254"`.--最后，使用Prometheus抓取NGINX Ingress部署：`prometheus.io/scrape: "true"` 和 `prometheus.io/port: "10254"`。


[mr-8135]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/8135
[mr-2]: https://gitlab.com/gitlab-examples/kubernetes-deploy/merge_requests/2
[mr-8]: https://gitlab.com/gitlab-examples/kubernetes-deploy/merge_requests/8
[project-settings]: https://docs.gitlab.com/ce/public_access/public_access.html
[project-services]: ../../user/project/integrations/project_services.md
[auto-deploy-templates]: https://gitlab.com/gitlab-org/gitlab-ci-yml/tree/master/autodeploy
[kubernetes-service]: ../../user/project/integrations/kubernetes.md
[docker-in-docker]: ../docker/using_docker_build.md#use-docker-in-docker-executor
[review-app]: ../review_apps/index.md
[kube-image]: https://gitlab.com/gitlab-examples/kubernetes-deploy/container_registry "Kubernetes deploy Container Registry"
[kube-deploy]: https://gitlab.com/gitlab-examples/kubernetes-deploy "Kubernetes deploy example project"
[container-registry]: https://docs.gitlab.com/ce/user/project/container_registry.html
[postgresql]: https://www.postgresql.org/
