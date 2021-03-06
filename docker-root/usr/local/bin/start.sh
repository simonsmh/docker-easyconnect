#!/bin/bash


# 在虚拟网络设备 tun0 打开时运行 proxy 代理服务器
(until [ -e /sys/class/net/tun0 ]
do
sleep 5
done
danted
)&

# 登陆信息持久化处理
infos='
easy_connect.json
ecagent_conf.json
setting_root.json
'
for info in $infos
do
rm -f /usr/share/sangfor/EasyConnect/resources/conf/$info
touch ~/$info
ln -s ~/$info /usr/share/sangfor/EasyConnect/resources/conf/$info
done

export DISPLAY

# 拒绝 tun0 侧主动请求的连接.
iptables -I INPUT -p tcp -j REJECT
iptables -I INPUT -i eth0 -p tcp -j ACCEPT
iptables -I INPUT -i lo -p tcp -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

if [ "$TYPE" != "X11" -a "$TYPE" != "x11" ]
then
	# $PASSWORD 不为空时，更新 vnc 密码
	[ -e ~/.vnc/passwd ] || (mkdir -p ~/.vnc && (echo password | tigervncpasswd -f > ~/.vnc/passwd)) 
	[ -n "$PASSWORD" ] && printf %s "$PASSWORD" | tigervncpasswd -f > ~/.vnc/passwd

	DISPLAY=:1
	tigervncserver -kill $DISPLAY
	tigervncserver $DISPLAY -geometry 1600x900 -localhost no -passwd ~/.vnc/passwd -xstartup flwm
fi

exec start-sangfor.sh
