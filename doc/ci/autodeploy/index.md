# Auto Deploy--�Զ�������

> [Introduced][mr-8135] in GitLab 8.15.
> Auto deploy is an experimental feature and is **not recommended for Production use** at this time.��GitLab 8.15�����롣 �Զ�������һ��ʵ���Թ��ܣ�Ŀǰ���Ƽ�����������

> As of GitLab 9.1, access to the container registry is only available while the
Pipeline is running. Restarting a pod, scaling a service, or other actions which
require on-going access **will fail**. On-going secure access is planned for a
subsequent release.
��GitLab 9.1��ʼ��ֻ���ڹܵ���Pipeline������ʱ���ܷ�������ע��� ��������pod�����ŷ����������Ҫ�������ʵĲ�������ʧ�ܡ� �ƻ��ں����汾�г������а�ȫ���ʡ�


> As of GitLab 10.0, Auto Deploy templates are **deprecated** and the
functionality has been included in [Auto
DevOps](../../topics/autodevops/index.md).
��GitLab 10.0��ʼ��Auto Deployģ���ѱ����ã����Ҹù����Ѱ�����Auto DevOps�С�


Auto deploy is an easy way to configure GitLab CI for the deployment of your
application. GitLab Community maintains a list of `.gitlab-ci.yml`
templates for various infrastructure providers and deployment scripts
powering them. These scripts are responsible for packaging your application,
setting up the infrastructure and spinning up necessary services (for
example a database).

�Զ�����������GitLab CI�Բ���Ӧ�ó���ļ򵥷����� GitLab����Ϊ���ֻ����ܹ��ṩ�̺Ͳ���ű��ṩ.gitlab-ci.ymlģ���б� ��Щ�ű�������Ӧ�ó������û����ܹ���������Ҫ�ķ����������ݿ⣩��

## How it works--����ԭ��

The Autodeploy templates are based on the [kubernetes-deploy][kube-deploy]
project which is used to simplify the deployment process to Kubernetes by
providing intelligent `build`, `deploy`, and `destroy` commands which you can
use in your `.gitlab-ci.yml` as is. It uses [Herokuish](https://github.com/gliderlabs/herokuish),
which uses [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks)
to do some of the work, plus some of GitLab's own tools to package it all up. For
your convenience, a [Docker image][kube-image] is also provided.

Autodeployģ�����kubernetes-deploy��Ŀ��ͨ���ṩ����`build`, `deploy`,�� `destroy`�����Щ���������.gitlab-ci.yml��ʹ�ã��Ӷ��򻯶�Kubernetes�Ĳ�����̡� ��ʹ��Herokuish����Herokuishʹ��Heroku buildpack�����һЩ�������ټ���һЩGitLab�Լ��Ĺ���������� Ϊ�����ķ��㣬���ṩ��һ��Docker����

You can use the [Kubernetes project service](../../user/project/integrations/kubernetes.md)
to store credentials to your infrastructure provider and they will be available
during the deployment.

������ʹ��Kubernetes��Ŀ����ƾ֤��credentials���洢�����Ļ����ܹ��ṩ�̣����ڲ����ڼ���á�


## Quick start--��������

We made a [simple guide](quick_start_guide.md) to using Auto Deploy with GitLab.com.
����������һ��markdown�ĵ����������GitLabʹ���Զ������𡣣�quick_start_guide.md��

## Supported templates--֧�ֵ�ģ��

The list of supported auto deploy templates is available in the
[gitlab-ci-yml project][auto-deploy-templates].

��֧�ֵ��Զ�����ģ���б���gitlab-ci-yml��Ŀ�п��á�

## Configuration--����

>**Note:**
In order to understand why the following steps are required, read the
[how it works](#how-it-works) section.

ע�⣺Ϊ�����Ϊʲô��Ҫִ�����²��裬���Ķ�����ԭ���֡�

To configure Autodeploy, you will need to:

Ϊ�������Զ��������㽫��Ҫ��

1. Enable a deployment [project service][project-services] to store your
   credentials. For example, if you want to deploy to OpenShift you have to
   enable [Kubernetes service][kubernetes-service].���ò�����Ŀ�������洢����ƾ֤�� ���磬�����Ҫ����OpenShift�����������Kubernetes����
   
1. Configure GitLab Runner to use the
   [Docker or Kubernetes executor](https://docs.gitlab.com/runner/executors/) with
   [privileged mode enabled][docker-in-docker].--��GitLab Runner������privilegedģʽ��Docker��Kubernetesִ�г���
   
1. Navigate to the "Project" tab and click "Set up auto deploy" button.--����������Ŀ��ѡ���Ȼ�󵥻��������Զ����𡱰�ť��
   ![Auto deploy button](img/auto_deploy_button.png)
1. Select a template.--ѡ��һ��ģ��
  ![Dropdown with auto deploy templates](img/auto_deploy_dropdown.png)
1. Commit your changes and create a merge request.--�ύ���������һ��merge����
1. Test your deployment configuration using a [Review App][review-app] that was
   created automatically for you.--ʹ��Ϊ���Զ�������Review App�������Ĳ������á�


## Private project support--˽����Ŀ��֧��

> Experimental support [introduced][mr-2] in GitLab 9.1.

When a project has been marked as private, GitLab's [Container Registry][container-registry] requires authentication when downloading containers. Auto deploy will automatically provide the required authentication information to Kubernetes, allowing temporary access to the registry. Authentication credentials will be valid while the pipeline is running, allowing for a successful initial deployment.

��һ����Ŀ�����Ϊ˽��ʱ��GitLab��Container Registry����������ʱ��Ҫ��֤�� �Զ������Զ���Kubernetes�ṩ����������֤��Ϣ��������ʱ����ע��� �����֤ƾ�ݽ��ڹܵ�����ʱ��Ч���Ӷ����Գɹ����г�ʼ����

After the pipeline completes, Kubernetes will no longer be able to access the container registry. Restarting a pod, scaling a service, or other actions which require on-going access to the registry will fail. On-going secure access is planned for a subsequent release.

pipeline��ɺ�Kubernetes�������ܹ���������ע��� ��������pod����չ������������Ҫ��������ע���Ĳ�����ʧ�ܡ� �ƻ��ں����汾�г������а�ȫ���ʡ�

## PostgreSQL database support--PostgreSQL���ݿ�֧��

> Experimental support [introduced][mr-8] in GitLab 9.1.--��GitLab 9.1��������ʵ��֧�֡�

In order to support applications that require a database, [PostgreSQL][postgresql] is provisioned by default. Credentials to access the database are preconfigured, but can be customized by setting the associated [variables](#postgresql-variables). These credentials can be used for defining a `DATABASE_URL` of the format: `postgres://user:password@postgres-host:postgres-port/postgres-database`. It is important to note that the database itself is temporary, and contents will be not be saved.

Ϊ��֧����Ҫ���ݿ��Ӧ�ó���PostgreSQLĬ�ϱ����䡣 �������ݿ��ƾ֤��Ԥ���õģ�������ͨ��������صı������ж��ơ� ��Щƾ�ݿ����ڶ����ʽΪ`DATABASE_URL`: `postgres://user:password@postgres-host:postgres-port/postgres-database`�� ��ע�⣬���ݿⱾ������ʱ�ģ����ݽ����ᱻ���档

PostgreSQL provisioning can be disabled by setting the variable `DISABLE_POSTGRES` to `"yes"`.

����ͨ��������DISABLE_POSTGRES����Ϊ��yes��������PostgreSQL���á�

The following PostgreSQL variables are supported:

֧������PostgreSQL������

1. `DISABLE_POSTGRES: "yes"`: disable automatic deployment of PostgreSQL--����PostgreSQL���Զ�������
1. `POSTGRES_USER: "my-user"`: use custom username for PostgreSQL--ʹ��PostgreSQL�Զ����û�����
1. `POSTGRES_PASSWORD: "password"`: use custom password for PostgreSQL--ʹ��PostgreSQL�Զ������룻
1. `POSTGRES_DB: "my database"`: use custom database name for PostgreSQL--ʹ��PostgreSQL�Զ������ݿ�����

## Auto Monitoring--�Զ������

> Introduced in [GitLab 9.5](https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/13438).��GitLab 9.5����

Apps auto-deployed using one the [Kubernetes templates](#supported-templates) can also be automatically monitored for:

ʹ��һ��Kubernetesģ���Զ������Ӧ�ó���Ҳ���Ա��Զ���أ�

* Response Metrics: latency, throughput, error rate--��Ӧ������׼���ӳ٣���������������
* System Metrics: CPU utilization, memory utilization--ϵͳ������׼��CPU�����ʣ��ڴ�������

Metrics are gathered from [nginx-ingress](../../user/project/integrations/prometheus_library/nginx_ingress.md) and [Kubernetes](../../user/project/integrations/prometheus_library/kubernetes.md).

ָ������nginx-ingress��Kubernetes��

To view the metrics, open the [Monitoring dashboard for a deployed environment](../environments.md#monitoring-environments).

Ҫ�鿴������׼�����Monitoring dashboard for a deployed environment�Ǳ�塣

![Auto Metrics](img/auto_monitoring.png)

### Configuring Auto Monitoring--�����Զ������

If GitLab has been deployed using the [omnibus-gitlab](../../install/kubernetes/gitlab_omnibus.md) Helm chart, no configuration is required.

���GitLab�Ѿ�ʹ��omnibus-gitlab Helmͼ����в�������Ҫ�������á�

If you have installed GitLab using a different method:

�����ʹ������������װ��GitLab����ִ�����²�����

1. [Deploy Prometheus](../../user/project/integrations/prometheus.md#configuring-your-own-prometheus-server-within-kubernetes) into your Kubernetes cluster--��Prometheus��������Kubernetes��Ⱥ�У�
1. If you would like response metrics, ensure you are running at least version 0.9.0 of NGINX Ingress and [enable Prometheus metrics](https://github.com/kubernetes/ingress/blob/master/examples/customization/custom-vts-metrics/nginx/nginx-vts-metrics-conf.yaml).--�������Ҫ��Ӧָ�꣬��ȷ������������NGINX Ingress 0.9.0�棬������Prometheusָ�ꡣ
1. Finally, [annotate](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) the NGINX Ingress deployment to be scraped by Prometheus using `prometheus.io/scrape: "true"` and `prometheus.io/port: "10254"`.--���ʹ��PrometheusץȡNGINX Ingress����`prometheus.io/scrape: "true"` �� `prometheus.io/port: "10254"`��


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
