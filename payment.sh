source common.sh
component=payment

roboshop_pwd=$1

if [ -z "roboshop_pwd" ]; then
  echo -e "\e[31mProvide rabbitmq pwd to proceed\e[0m"
  exit 1
fi

func_python