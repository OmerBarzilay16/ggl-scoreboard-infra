resource "kubernetes_namespace_v1" "scoreboard" {
  metadata {
    name = "scoreboard"
  }
}

resource "kubernetes_role_binding_v1" "deployer_edit" {
  metadata {
    name      = "scoreboard-deployer-edit"
    namespace = kubernetes_namespace_v1.scoreboard.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "User"
    name      = data.google_service_account.scoreboard_deployer.email
    api_group = "rbac.authorization.k8s.io"
  }
}
