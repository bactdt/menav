#!/bin/bash

# 检查密码参数
if [ -n "$1" ]; then
  PASSWORD="$1"
elif [ -n "$CONFIG_PASSPHRASE" ]; then
  PASSWORD="$CONFIG_PASSPHRASE"
else
  read -sp "请输入解密密码: " PASSWORD
  echo
fi

if [ -z "$PASSWORD" ]; then
  echo "❌ 错误: 密码不能为空"
  exit 1
fi

echo "🔓 开始解密 config/user 目录下的所有 .enc 文件..."
echo ""

# 统计变量
total=0
success=0
failed=0

# 查找并解密所有 .enc 文件
while IFS= read -r enc_file; do
  total=$((total + 1))
  original_file="${enc_file%.enc}"
  
  echo "[$total] 解密: $enc_file"
  echo "    -> $original_file"
  
  if openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
    -in "$enc_file" \
    -out "$original_file" \
    -k "$PASSWORD" 2>/dev/null; then
    echo "    ✅ 成功"
    success=$((success + 1))
  else
    echo "    ❌ 失败"
    failed=$((failed + 1))
  fi
  echo ""
done < <(find config/user -name "*.yml.enc" -type f)

echo "================================"
echo "解密完成！"
echo "总计: $total 个文件"
echo "成功: $success 个"
echo "失败: $failed 个"
echo "================================"

if [ "$failed" -gt 0 ]; then
  echo "❌ 严重错误: 有 $failed 个文件解密失败"
  exit 1
fi
