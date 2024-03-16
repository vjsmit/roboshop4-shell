source common.sh

echo -e "${color}${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "${color}${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "${color}${nocolor}"
dnf install rabbitmq-server -y

echo -e "${color}${nocolor}"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "${color}${nocolor}"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"