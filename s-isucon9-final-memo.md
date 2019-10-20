# s-isucon9-final-memo

## VM
- Azure VM x 4台(うち1台はベンチマーク実行用)
    - サイズ: Standard F2s (2 vcpu 数、4 GiB メモリ)
    - OS: Linux (ubuntu 18.04)
    - usernane: isucon
    - password; password
- URL
    - a.isucon9-hinatan.ga
    - b.isucon9-hinatan.ga
    - c.isucon9-hinatan.ga
    - bench.isucon9-hinatan.ga
- SSH
    - secret key: 別途送付(isucon9_key)
    - 接続方法例: ssh -i ~/.ssh/isucon9_key isucon@a.isucon9-hinatan.ga   

## github
-<https://github.com/Qsk812/s-isucon9-final>

## Webapp
- systemctlは未対応

### 起動
- docker-composeでコンテナを起動すると、webapp、MySQL、Nginx、外部決済サービスが起動します。
```
sudo docker-compose -f ~/s-isucon9-final/webapp/docker-compose.yml -f ~/s-isucon9-final/webapp/docker-compose.python.yml build
sudo docker-compose -f ~/s-isucon9-final/webapp/docker-compose.yml -f ~/s-isucon9-final/webapp/docker-compose.python.yml up
```

### 再起動
- コードの変更時にwebappが自動で再起動しない場合には以下のコマンドでwebappコンテナだけ再起動することができます。
```
sudo docker-compose -f ~/s-isucon9-final/webapp/docker-compose.yml -f ~/s-isucon9-final/webapp/docker-compose.python.yml restart webapp
```

## Bench
- 実行例
```bash
~/s-isucon9-final/bench/bin/bench_linux run --payment=http://localhost:5000 --target=http://localhost:8080 --assetdir=webapp/frontend/dist
```

### ベンチマーカーが必要とする情報を集める
以下に、案内通りの起動を行なった場合の情報を記載します
- 課金のアドレス
  - http://localhost:5000
- webappのアドレス
  - http://localhost:8080
- 静的ファイルの配置ディレクトリ
  - webapp/frontend/dist


