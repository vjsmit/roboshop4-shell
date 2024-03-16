echo -e "${color}Setup mongodb repo file${nocolor}"
cp /home/centos/roboshop4-shell/mongo.repo /etc/yum.repos.d/mongo.repo    $>>${logfile}
func_StatCheck $?

echo -e "${color}Installing mongodb${nocolor}"
dnf install mongodb-org -y    $>>${logfile}
func_StatCheck $?

echo -e "${color}Update listen address${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf   $>>${logfile}
func_StatCheck $?

echo -e "${color}Start mongod service${nocolor}"
systemctl enable mongod   $>>${logfile}
systemctl restart mongod    $>>${logfile}
func_StatCheck $?