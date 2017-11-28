class MigrateKubernetesServiceToNewClustersArchitectures < ActiveRecord::Migration
  DOWNTIME = false
  DEFAULT_KUBERNETES_SERVICE_CLUSTER_NAME = 'KubernetesService'

  class Cluster < ActiveRecord::Base
    self.table_name = 'clusters'

    has_many :cluster_projects, class_name: 'ClustersProject'
    has_many :projects, through: :cluster_projects, class_name: 'Project'
    has_one :provider_gcp, class_name: 'ProvidersGcp'
    has_one :platform_kubernetes, class_name: 'PlatformsKubernetes'

    attr_encrypted :token,
      mode: :per_attribute_iv,
      key: Gitlab::Application.secrets.db_key_base,
      algorithm: 'aes-256-cbc'

    accepts_nested_attributes_for :provider_gcp
    accepts_nested_attributes_for :platform_kubernetes

    enum platform_type: {
      kubernetes: 1
    }

    enum provider_type: {
      user: 0,
      gcp: 1
    }
  end

  class Project < ActiveRecord::Base
    self.table_name = 'projects'

    has_one :cluster_project, class_name: 'ClustersProject'
    has_one :cluster, through: :cluster_project, class_name: 'Cluster'
  end

  class Service < ActiveRecord::Base
    include EachBatch

    self.table_name = 'services'

    belongs_to :project, class_name: 'Project'

    # When users create a cluster, KubernetesService is automatically synchronized
    # with Platforms::Kubernetes due to delegate Kubernetes specific logic.
    # We only target unmanaged KubernetesService records.
    scope :unmanaged_kubernetes_service, -> do
      joins(
        'INNER JOIN projects ON projects.id = services.project_id' \
        'INNER JOIN cluster_projects ON projects.id = cluster_projects.project_id' \
        'INNER JOIN clusters ON cluster_projects.cluster_id = clusters.id' \
        'INNER JOIN cluster_platforms_kubernetes ON cluster_platforms_kubernetes.cluster_id = clusters.id')
      .where(
        "services.category = 'deployment' AND services.type = 'KubernetesService'" \
        "AND (" \
        "    cluster_projects.project_id IS NULL" \
        "    OR" \
        "    services.properties NOT LIKE CONCAT('%', cluster_platforms_kubernetes.api_url, '%')" \
        ")")
    end
  end

  class ClustersProject < ActiveRecord::Base
    self.table_name = 'cluster_projects'

    belongs_to :cluster, class_name: 'Cluster'
    belongs_to :project, class_name: 'Project'
  end

  class ProvidersGcp < ActiveRecord::Base
    self.table_name = 'cluster_providers_gcp'
  end

  class PlatformsKubernetes < ActiveRecord::Base
    self.table_name = 'cluster_platforms_kubernetes'
  end

  def up
    Service.unmanaged_kubernetes_service
      .find_each(batch_size: 1) do |kubernetes_service|
        Cluster.create(
          enabled: kubernetes_service.active,
          user_id: nil, # KubernetesService doesn't have
          name: DEFAULT_KUBERNETES_SERVICE_CLUSTER_NAME,
          provider_type: Cluster.provider_types[:user],
          platform_type: Cluster.platform_types[:kubernetes],
          projects: [kubernetes_service.project],
          platform_kubernetes_attributes: {
            api_url: kubernetes_service.api_url,
            ca_cert: kubernetes_service.ca_pem,
            namespace: kubernetes_service.namespace,
            username: nil, # KubernetesService doesn't have
            encrypted_password: nil, # KubernetesService doesn't have
            encrypted_password_iv: nil, # KubernetesService doesn't have
            token: kubernetes_service.token # encrypted_token and encrypted_token_iv
          } )
    end
  end

  def down
    # noop
  end
end
