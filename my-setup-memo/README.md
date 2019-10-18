# ISUCON9-final 環境構築メモ

## 1. VM作成
- Azure VM x 4台(うち1台はベンチマーク実行用)
  - サイズ: Standard F2s (2 vcpu 数、4 GiB メモリ)
  - OS: Linux (ubuntu 18.04)
  - ネットワーク 受信ポートの規則: 22, 80, 443, 5000, 8080をAllow
- 今後業務でAzureを触れる予感があるのと約20,000円のクレジットを使用できたため
- ほんとはAzure Resource Managerでうまくやってみたいところだったが、時間の都合上断念

## 2. 必要なソフトウェアのインストールとか
- 参考: <https://github.com/isucon/isucon9-final> 
### 2.1. とりあえずアップグレード
```
# System upgrade
$ sudo apt update
$ sudo apt upgrade -y
```

### 2.2. Docker周りのインストール
- Dockerの公式Documentを参考に導入
```
# before installing docker
$ sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# install docker
$ sudo apt install docker-ce docker-ce-cli containerd.io -y
$ sudo docker run hello-world

# install docker-compose
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

### 2.3. Goのインストール
- **やられた...**: `apt install golang`で導入されるgoはバージョンが古くgo modが使えない 
- benchもビルドする場合、v1.13のソースを取ってきて導入する必要あり
```
# install golang
$ wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
$ sudo tar -C /usr/local -xzf go1.13.3.linux-amd64.tar.gz
$ echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
```

## 3. ISUCON9-finalの導入
- 今回はPython用の環境を構築
- 参考: <https://github.com/isucon/isucon9-final/blob/master/docs/IMPLEMENT.md>
```
# setup ISUCON9-final
$ cd
$ git clone https://github.com/isucon/isucon9-final
$ cd ~/isucon9-final/webapp/frontend && make

$ cd ~/isucon9-final/
$ export LANGUAGE=python
$ sudo docker-compose -f webapp/docker-compose.yml -f webapp/docker-compose.${LANGUAGE}.yml build
$ sudo docker-compose -f webapp/docker-compose.yml -f webapp/docker-compose.${LANGUAGE}.yml up
```

## 4. メモリ使用量の制限
- メモリ4GBのVMを用意してあるが、公式<http://isucon.net/>で下記文言があったため同じく1GBに制限
> ただし、今回のアプリケーションではメモリに全ての切らない環境を再現するために、Linuxにはメモリを1GBしか認識させていません。CPUは2コアで、メモリ1GBの環境を再現しています。
- 本番と近い環境を構築するため、こちらも同じくOSが認識するメモリを1GBに制限する
```
# grubファイルのバックアップ
$ sudo cp /etc/default/grub{,.org}

# grubファイルを下記のように修正
$ diff /etc/default/grub /etc/default/grub.org 
11c11
< GRUB_CMDLINE_LINUX="mem=1G"
---
> GRUB_CMDLINE_LINUX=""

# grubの更新
$ sudo update-grub
$ sudo reboot
```

## 5. bench環境の構築
- bench用のVMに導入
```
# bench導入
cd
git clone https://github.com/isucon/isucon9-final
cd ~/isucon9-final/bench
make
```

## 6. IPアドレスとドメイン
- 今回はドメインを取得せず、VMとホスト(MacBook Pro)の/etc/hostsに追記することで対応

## 7. ISUCON9-finalアプリとbenchの動作確認
- 結果: コンテナ(webapp_payment_1やwebapp_nginx_1)が起動後落ちる
  - メモリ制限をなくすとちゃんと起動ができ、benchもちゃんと動く
- 原因: メモリ不足?? 


