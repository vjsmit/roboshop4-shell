source common.sh
rabbitmq_pwd=$1

if [ -z "$rabbitmq_pwd" ]; then
  echo -e "\e[31mProvide rabbitmq pwd to proceed\e[0m"
fi

echo -e "${color}Setup erlang repo${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash   &>>${logfile}
func_StatCheck $?

echo -e "${color}Setup rabbitmq repo${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash    &>>${logfile}
func_StatCheck $?

echo -e "${color}Install rabbitmq${nocolor}"
dnf install rabbitmq-server -y    &>>${logfile}
func_StatCheck $?

echo -e "${color}Start rabbitmq service${nocolor}"
systemctl enable rabbitmq-server    &>>${logfile}
systemctl restart rabbitmq-server   &>>${logfile}
func_StatCheck $?

echo -e "${color}Create app user and fix permissions${nocolor}"
rabbitmqctl add_user roboshop ${rabbitmq_pwd}   &>>${logfile}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"    &>>${logfile}
func_StatCheck $?