#!/bin/bash

# 检查密码参数
if [ -n "$1" ]; then
  PASSWORD="$1"
elif [ -n "$CONFIG_PASSPHRASE" ]; then
  PASSWORD="$CONFIG_PASSPHRASE"
else
  read -sp "请输入加密密码: " PASSWORD
  echo
fi

if [ -z "$PASSWORD" ]; then
  echo "❌ 错误: 密码不能为空"
  exit 1
fi

echo "🔐 开始加密 config/user 目录下的所有 .yml 文件..."
echo ""

# 统计变量
total=0
success=0
failed=0

# 查找并加密所有 .yml 文件
while IFS= read -r file; do
  total=$((total + 1))
  echo "[$total] 加密: $file"
  
  if openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 \
    -in "$file" \
    -out "${file}.enc" \
    -k "$PASSWORD" 2>/dev/null; then
    echo "    ✅ 成功: ${file}.enc"
    success=$((success + 1))
  else
    echo "    ❌ 失败"
    failed=$((failed + 1))
  fi
  echo ""
done < <(find config/user -name "*.yml" -type f)

echo "================================"
echo "加密完成！"
echo "总计: $total 个文件"
echo "成功: $success 个"
echo "失败: $failed 个"
echo "================================"
echo ""
echo "生成的加密文件:"
find config/user -name "*.enc" -type f
