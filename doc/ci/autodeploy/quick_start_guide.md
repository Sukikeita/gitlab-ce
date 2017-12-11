# Auto Deploy: quick start guide

This is a step-by-step guide to deploying a project hosted on GitLab.com to Google Cloud, using Auto Deploy.

这是使用Auto Deploy将托管在GitLab.com上的项目部署到Google Cloud的分步指南。

We made a minimal [Ruby application](https://gitlab.com/gitlab-examples/minimal-ruby-app) to use as an example for this guide. It contains two files:

我们做了一个最小的Ruby应用程序来作为本指南的一个例子。 它包含两个文件：

* `server.rb` - our application. It will start an HTTP server on port 5000 and render “Hello, world!” --我们的应用。 它将在端口5000上启动一个HTTP服务器并呈现“Hello，world！”
* `Dockerfile` - to build our app into a container image. It will use a ruby base image and run `server.rb` --将我们的应用程序构建成一个容器图像。 它将使用ruby基础镜像并运行server.rb

## Fork sample project on GitLab.com在GitLab.com上分享示例项目

Let’s start by forking our sample application. Go to [the project page](https://gitlab.com/gitlab-examples/minimal-ruby-app) and press the `Fork` button. Soon you should have a project under your namespace with the necessary files.

让我们开始fork我们的示例应用程序。 转到项目页面链接并按Fork按钮。 不久，你应该有你的名字空间下的必要文件的项目。

## Setup your own cluster on Google Container Engine--在Google Container Engine上设置您自己的群集

If you do not already have a Google Cloud account, create one at https://console.cloud.google.com.

如果您还没有Google Cloud帐户，请通过https://console.cloud.google.com创建一个帐户。

Visit the [`Container Engine`](https://console.cloud.google.com/kubernetes/list) tab and create a new cluster. You can change the name and leave the rest of the default settings. Once you have your cluster running, you need to connect to the cluster by following the Google interface.

访问容器引擎选项卡并创建一个新的群集。 您可以更改名称并保留其余的默认设置。 一旦您的群集正在运行，您需要按照Google界面连接到群集。

## Connect to Kubernetes cluster--连接到Kubernetes群集

You need to have the Google Cloud SDK installed. e.g.
On OSX, install [homebrew](https://brew.sh):

您需要安装Google Cloud SDK。 例如 在OSX上，安装自制软件：

1. Install Brew Caskroom--安装Brew Caskroom: `brew install caskroom/cask/brew-cask`
2. Install Google Cloud SDK--安装Google Cloud SDK: `brew cask install google-cloud-sdk`
3. Add `kubectl`: `gcloud components install kubectl`
4. Log in--登陆: `gcloud auth login`

Now go back to the Google interface, find your cluster, and follow the instructions under `Connect to the cluster` and open the Kubernetes Dashboard. It will look something like `gcloud container clusters get-credentials ruby-autodeploy \ --zone europe-west2-c --project api-project-XXXXXXX` and then `kubectl proxy`.

现在返回到Google界面，找到您的群集，然后按照连接到群集的说明进行操作，然后打开Kubernetes Dashboard。 它会看起来像`gcloud container clusters get-credentials ruby-autodeploy \ --zone europe-west2-c --project api-project-XXXXXXX`然后是`kubectl proxy`。

![connect to cluster](img/guide_connect_cluster.png)

## Copy credentials to GitLab.com project

Once you have the Kubernetes Dashboard interface running, you should visit `Secrets` under the  `Config` section. There you should find the settings we need for GitLab integration: ca.crt and token.

一旦运行了Kubernetes Dashboard界面，您应该在访问Config部分下的Secrets。 在那里你应该找到我们需要的GitLab集成设置：ca.crt和令牌。

![connect to cluster](img/guide_secret.png)

You need to copy-paste the ca.crt and token into your project on GitLab.com in the Kubernetes integration page under project `Settings` > `Integrations` > `Project services` > `Kubernetes`. Don't actually copy the namespace though. Each project should have a unique namespace, and by leaving it blank, GitLab will create one for you.

您需要将ca.crt和标记复制粘贴到GitLab.com项目 中，具体位置是：Kubernetes集成页面中的`Settings` > `Integrations` > `Project services` > `Kubernetes`下。 不要实际上复制命名空间。 每个项目都应该有一个唯一的名称空间，并保留空白，GitLab将为您创建一个。

![connect to cluster](img/guide_integration.png)

For API URL, you should use the `Endpoint` IP from your cluster page on Google Cloud Platform.

对于API URL，您应该使用Google云端平台上的群集页面中的端点（`Endpoint`）IP。

## Expose the application to the internet--将凭据复制到GitLab.com项目

In order to be able to visit your application, you need to install an NGINX ingress controller and point your domain name to its external IP address.

为了能够访问您的应用程序，您需要安装NGINX入口控制器，并将您的域名指向其外部IP地址。

### Set up Ingress controller--设置Ingress控制器

You’ll need to make sure you have an ingress controller. If you don’t have one, do:

你需要确保你有一个入口控制器。 如果你没有，那请安装：

```sh
brew install kubernetes-helm
helm init
helm install --name ruby-app stable/nginx-ingress
```

This should create several services including `ruby-app-nginx-ingress-controller`. You can list your services by running `kubectl get svc` to confirm that.

这应该创建几个服务，包括`ruby-app-nginx-ingress-controller`。 你可以通过运行kubectl get svc列出服务来确认你的服务。

### Point DNS at Cluster IP--在群集IP点DNS

Find out the external IP address of the `ruby-app-nginx-ingress-controller` by running:

通过运行以下命令找出ruby-app-nginx-ingress-controller的外部IP地址：

```sh
kubectl get svc ruby-app-nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

Use this IP address to configure your DNS. This part heavily depends on your preferences and domain provider. But in case you are not sure, just create an A record with a wildcard host like `*.<your-domain>` pointing to the external IP address you found above.

使用此IP地址来配置您的DNS。 这部分很大程度上取决于您的偏好和域名提供者。 但是，如果您不确定，只需使用通配符主机（如`*.<your-domain>`）创建一条A记录，指向上面找到的外部IP地址。

Use `nslookup minimal-ruby-app-staging.<yourdomain>` to confirm that domain is assigned to the cluster IP.

使用`nslookup minimal-ruby-app-staging.<yourdomain>`以确认域被分配给群集IP。

## Setup Auto Deploy--设置自动化部署

Visit the home page of your GitLab.com project and press "Set up Auto Deploy" button.

访问您的GitLab.com项目的主页，然后按"Set up Auto Deploy"按钮。

![auto deploy button](img/auto_deploy_btn.png)

You will be redirected to the "New file" page where you can apply one of the Auto Deploy templates. Select "Kubernetes" to apply the template, then in the file, replace `domain.example.com` with your domain name and make any other adjustments you need.

您将被重定向到“新建文件”页面，您可以在其中应用其中一个Auto Deploy模板。 选择“Kubernetes”来应用模板，然后在文件中，将domain.example.com替换为您的域名，并进行其他所需的调整。
	
![auto deploy template](img/auto_deploy_dropdown.png)

Change the target branch to `master`, and submit your changes. This should create
a new pipeline with several jobs. If you made only the domain name change, the
pipeline will have three jobs: `build`, `staging`, and `production`.

将目标分支更改为主，并提交您的更改。 这应该创造一个新的管道与几个工作。 如果您只进行域名更改，则管道将有三个作业：构建，分段和生产。

The `build` job will create a Docker image with your new change and push it to
the GitLab Container Registry. The `staging` job will deploy this image on your
cluster. Once the deploy job succeeds you should be able to see your application by
visiting the Kubernetes dashboard. Select the namespace of your project, which
will look like `ruby-autodeploy-23`, but with a unique ID for your project, and
your app will be listed as "staging" under the "Deployment" tab.

`build`作业将创建针对新的更改的Docker镜像，并将其推送到GitLab容器注册表。 `staging`作业将在您的群集上部署此映像。 一旦部署工作成功，您应该可以通过访问Kubernetes仪表板来查看您的应用程序。 选择你的项目的命名空间，看起来像ruby-autodeploy-23，但是有一个唯一的ID给你的项目，你的应用程序将被列为“部署”选项卡下的“暂存”。

Once its ready - just visit http://minimal-ruby-app-staging.yourdomain.com to see “Hello, world!”
一旦准备就绪 - 只需访问http://minimal-ruby-app-staging.yourdomain.com看到“你好，世界！”
