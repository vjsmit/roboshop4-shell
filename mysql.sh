source common.sh
mysql_pwd=$1

if [ -z "$mysql_pwd" ]; then
  echo -e "\e[31mPlease provide mysql_pwd to proceed\e[0m"
  exit 1
fi

echo -e "${color}Disable MySQL 8${nocolor}"
dnf module disable mysql -y   &>>{logfile}
func_StatCheck $?

echo -e "${color}Setup the MySQL5.7 repo file${nocolor}"
cp /home/centos/roboshop4-shell/mysql.repo /etc/yum.repos.d/mysql.repo    &>>{logfile}
func_StatCheck $?

echo -e "${color}Install MySQL Server${nocolor}"
dnf install mysql-community-server -y   &>>{logfile}
func_StatCheck $?

echo -e "${color}Start MySQL Service${nocolor}"
systemctl enable mysqld   &>>{logfile}
systemctl restart mysqld    &>>{logfile}
func_StatCheck $?

echo -e "${color}Change the default root password${nocolor}"
mysql_secure_installation --set-root-pass ${mysql_pwd}    &>>{logfile}
func_StatCheck $?
