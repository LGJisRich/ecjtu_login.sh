USER_ID="学号"
PASSWORD="密码"
ISP="cmcc" #移动 cmcc 联通 unicom 电信 telecom

echo "-------START-------"
echo "开始检测网络认证状态"
KEYWORD=$(curl -s http://baidu.com | grep NextURL) 
if [[ "$(printf '%s' "${KEYWORD}")" != '' ]]; then
  echo "检测到尚未认证，尝试自动认证"
  #CURRENT_IP=$(ifconfig | grep inet | grep -v inet6 | grep -v 127 | grep -v 192 | awk '{print $(NF-2)}' | cut -d ':' -f2 | head -1)
  #MAC_ADDRESS=$(ifconfig  | grep HWaddr | awk '{print $NF}' | tr '[:upper:]' '[:lower:]' | tr ':' '-' | head -1)
  LOGIN_STATUS=$(curl -i -X POST "http://172.16.2.100:801/eportal/?c=ACSetting&a=Login&hostname=172.16.2.100" -d "DDDDD=%2C0%2C${USER_ID}%40${ISP}&upass=${PASSWORD}") 
  echo "Connecting........."
  SUCCESS=$(echo ${LOGIN_STATUS} | grep 302)
  if [[ "$(printf '%s' "${SUCCESS}")" != '' ]]; then
    echo "自动认证成功"
  else
    LOGIN_STATUS=$(echo ${LOGIN_STATUS} | cut -d ',' -f3 | cut -d '"' -f4)
    echo "自动认证失败: ${LOGIN_STATUS}"
  fi
else
  echo "检测到已经认证"
  echo "-------END---------"
fi
