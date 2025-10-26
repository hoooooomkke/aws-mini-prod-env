
COST
概算（月額目安）

NAT GW: 約1〜1.5万円

EC2 t3.micro: 数百円

RDS db.t4g.micro: 数千円

ALB: 数百円

S3/CloudWatch/Lambda/SNS: 微小

合計: 約1〜2万円/月（NATが主）

コスト最適化

NAT停止またはスケジュール制御

ASG最小数0運用/Spot利用

RDS停止スナップショット化

S3ライフサイクル: IA→Glacier
