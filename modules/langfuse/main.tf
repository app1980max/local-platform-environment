
resource "helm_release" "langfuse" {
  name       = "langfuse"
  repository = "https://langfuse.github.io/langfuse-k8s"
  chart      = "langfuse"
  #version    = "2.4.9"

  namespace        = "langfuse"
  create_namespace = true

  atomic            = true
  cleanup_on_fail   = true
  dependency_update = true
  wait              = true
  timeout           = 600

  values = [<<EOF
langfuse:
  salt:
    valueFrom:
      secretKeyRef:
        name: langfuse
        key: salt
  encryptionKey:
    valueFrom:
      secretKeyRef:
        name: langfuse
        key: encryption-key
  nextauth:
    secret:
      valueFrom:
        secretKeyRef:
          name: langfuse
          key: nextauth-secret

redis:
  deploy: true
  auth:
    valueFrom:
      secretKeyRef:
        name: langfuse-redis-auth
        key: password

clickhouse:
  deploy: true
  auth:
    valueFrom:
      secretKeyRef:
        name: langfuse-clickhouse-auth
        key: password

postgresql:
  deploy: true
  auth:
    valueFrom:
      secretKeyRef:
        name: langfuse-postgresql-auth
        key: password

s3:
  deploy: true
  auth:
    valueFrom:
      secretKeyRef:
        name: langfuse-s3-auth
        key: rootPassword
EOF
  ]
}
