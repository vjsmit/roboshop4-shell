source common.sh
component=shipping

mysql_pwd=$1

if [ -z "$mysql_pwd" ]; then
  echo -e "\e[31mProvide mysql pwd to proceed\e[0m"
fi

func_maven
