cat > bt_speedup.sh <<'EOF'
#!/bin/bash

echo "====== 宝塔5.9 加速优化开始 ======"

# 1. 备份源
cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 2. 更换 Debian 9 源为阿里云
cat > /etc/apt/sources.list <<EOL
deb http://mirrors.aliyun.com/debian stretch main contrib non-free
deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free
deb http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free
EOL

apt update -y

echo "✔ Debian 源已切换为阿里云"

# 3. DNS 优化
cat > /etc/resolv.conf <<EOL
nameserver 223.5.5.5
nameserver 114.114.114.114
EOL

echo "✔ DNS 已优化"

# 4. 强制 IPv4 优先
if ! grep -q "precedence ::ffff:0:0/96  100" /etc/gai.conf; then
    echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
fi

echo "✔ 已强制 IPv4 优先"

# 5. 设置宝塔下载源
mkdir -p /www/server/panel/data
echo "http://dg2.bt.cn" > /www/server/panel/data/download_url.pl

echo "✔ 宝塔下载源已切换"

# 6. pip 加速
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ 2>/dev/null

echo "✔ pip 源已加速"

# 7. wget 优化
echo "check_certificate = off" >> ~/.wgetrc

echo "✔ wget 已优化"

# 8. 创建缓存目录
mkdir -p /www/server/cache

echo "✔ 编译缓存目录已创建"

# 9. 提示
echo ""
echo "====== 优化完成 ======"
echo "建议："
echo "1. 宝塔安装软件时选择【极速安装】"
echo "2. 勾选【使用缓存】"
echo "3. 不要一次装多个PHP版本"
echo ""

EOF
