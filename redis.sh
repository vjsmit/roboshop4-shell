source common.sh

echo -e "${color}Setup redis repo file${nocolor}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y    &>>${logfile}
func_StatCheck $?

echo -e "${color}Enable Redis 6.2${nocolor}"
dnf module enable redis:remi-6.2 -y   &>>${logfile}
func_StatCheck $?

echo -e "${color}Install Redis${nocolor}"
dnf install redis -y    &>>${logfile}
func_StatCheck $?

echo -e "${color}Update redis listen address${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf    &>>${logfile}
func_StatCheck $?

echo -e "${color}Start redis service${nocolor}"
systemctl enable redis    &>>${logfile}
systemctl restart redis   &>>${logfile}
func_StatCheck $?
