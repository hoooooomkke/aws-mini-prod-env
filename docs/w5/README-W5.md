# W5 結果レポート
- 日時: 2025-10-27 02:07:50 +09:00
- 環境: prod (ap-northeast-1)

## 達成項目
- GitHub OIDC Provider 作成（token.actions.githubusercontent.com / 固定thumbprint）
- GitHub Actions 用ロール作成（trust: aud=sts.amazonaws.com, sub=repo:<owner>/<repo>:*）
- Terraform CI/CD ワークフロー配置（PR=Plan / main=Apply）
- 出力 gha_role_arn: $ghaRoleArn

## 主要リンク
- ALB: http://mini-prod-hoooo2025-alb-381766404.ap-northeast-1.elb.amazonaws.com/
- IAM OIDC Provider ARN: $oidcArn
- GHA Role: $roleName

## 添付ファイル
- iam-oidc-provider.json / gha-role.json
- gha-role-trust-policy.json / gha-role-attached-policies.json
- gh-plan-pr-run.json / gh-plan-pr.log
- gh-apply-main-run.json / gh-apply-main.log
- workflow.terraform.yml
- 	erraform-outputs.json / 	erraform-state-list.txt

## メモ
- 以降の変更は GitHub Actions 経由（長期アクセスキー不要運用）
- project_ops は初期は広め。回り始めたら **タグ条件（aws:RequestTag/Project / aws:ResourceTag/Project）**で締める
