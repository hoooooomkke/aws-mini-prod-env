# W4 達成状況（通知/監査）  — 2025-10-27 00:59:26 +09:00

## 達成項目
- Secrets Manager: **AWSCURRENT** 存在を確認（値は未出力）
- Lambda: Slack Webhook シークレット読取 → 送信 **OK**（slack-post.txt）
- SNS → Lambda サブスクリプション確認（sns-subscriptions.json）
- Lambda 単体実行 & CloudWatch Logs でエラー無し（lambda-invoke-log.txt / cloudwatch-tail.txt）
- SNS 経由の発火で **MessageId** 取得（sns-publish.json）
- CloudTrail 設定（バケット/プレフィックス/マルチリージョン）取得（cloudtrail-config.json）
- AWS Config マネージドルールのコンプライアンス取得（config-compliance.json）

## 添付ファイル
- slack-post.txt / lambda-invoke-log.txt / cloudwatch-tail.txt
- sns-subscriptions.json / sns-publish.json
- lambda-config.json
- cloudtrail-config.json / config-compliance.json
- event.json（テスト用）

## スクショ（手動で保存）
- Slack チャンネルに届いた通知
- SNS トピック / Lambda 設定画面（Env, Role）
- Config ルールの COMPLIANT 状態
