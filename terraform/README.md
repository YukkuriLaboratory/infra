# Terraform (OpenTofu) - Cloudflare Tunnel

OpenTofu で Cloudflare Tunnel + Access を管理する。

## 構成

| ファイル | 用途 |
|---------|------|
| `versions.tf` | Provider要件 + 暗号化state設定 |
| `providers.tf` | Cloudflare provider |
| `variables.tf` | 変数定義 |
| `terraform.tfvars` | 変数値（非機密項目のみ） |
| `tunnel.tf` | Cloudflare Tunnel + Config + DNS |
| `access.tf` | CF Access Application + Policy |
| `outputs.tf` | Tunnel Token出力 |

## 事前準備

1. Cloudflare API Token を作成（権限: Zone.DNS, Account.Zero Trust）
2. `.env` に以下を設定（sopsで復号されることを前提）:

```
SOPS_AGE_KEY_CMD="rbw get yukulab-infra-age-key"
```

3. 環境変数をエクスポート:

```bash
export TF_VAR_cloudflare_api_token="<api-token>"
export TF_VAR_state_encryption_passphrase="<passphrase>"
```

## 使い方

```bash
# 初期化
tofu init

# 変更計画の確認
tofu plan

# 適用
tofu apply

# Tunnel Token の取得（cloudflared K8s Secret作成に使用）
tofu output -raw tunnel_token

# 暗号化stateをGitにコミット
git add terraform/terraform.tfstate
git commit -m "chore: update encrypted terraform state"
```

## 注意事項

- State は PBKDF2+AES-GCM で暗号化され、`terraform.tfstate` としてGit管理される
- パスフレーズなしでは復号不可
- `terraform.tfvars` に機密情報は記載しない（API Token, パスフレーズは環境変数）
