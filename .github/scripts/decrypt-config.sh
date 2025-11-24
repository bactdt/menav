#!/bin/sh

# 使用 OpenSSL 解密配置文件
openssl enc -aes-256-cbc -d -pbkdf2 \
  -in config/user/site.yml.enc \
  -out config/user/site.yml \
  -k "$CONFIG_PASSPHRASE"

echo "配置文件解密完成"
