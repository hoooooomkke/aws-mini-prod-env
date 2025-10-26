
SECURITY
方針

最小権限（IAM/SG）

SSH禁止, SSM運用

長期アクセスキー廃止（OIDC）

IAM

ロール: mini-prod-github-oidc-role

Trust: token.actions.githubusercontent.com

Policy:

backend_min: S3/DynamoDB

project_ops: リソース操作（タグ条件で制限予定）

ネットワーク

ALBのみ80公開

EC2: ALB→80のみ

RDS: Appサブネットのみ

VPCE: S3/DynamoDB Gateway

データ保護

RDS暗号化

S3 SSE有効

Secrets Managerで機密管理

TLS必須 (require_secure_transport=ON)

監査

CloudTrail / AWS Config有効
