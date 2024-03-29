echo -e "${color}${nocolor}"
color="\e[34m"
nocolor="\e[0m"

logfile="/tmp/roboshop.log"

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
    echo -e "\e[31mRoot permission required to proceed\e[0m"
    exit 1
fi

func_StatCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
  fi
}

func_AppPresetup() {
  echo -e "${color}Add App user${nocolor}"
  id roboshop   &>>${logfile}
  if [ $? -ne 0 ]; then
    useradd roboshop  &>>${logfile}
  fi
  func_StatCheck $?

  echo -e "${color}Create App Dir${nocolor}"
  rm -rf /app
  mkdir /app
  func_StatCheck $?

  echo -e "${color}Download App Content${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>${logfile}
  func_StatCheck $?

  echo -e "${color}Unzip App Content${nocolor}"
  cd /app
  unzip /tmp/${component}.zip    &>>${logfile}
  func_StatCheck $?
}

func_systemd() {
  echo -e "${color}Setup ${component} service${nocolor}"
  cp /home/centos/roboshop4-shell/${component}.service /etc/systemd/system/${component}.service   &>>${logfile}
  func_StatCheck $?

  sed -i -e "s/roboshop_pwd/${roboshop_pwd}/" /etc/systemd/system/${component}.service   &>>${logfile}


  echo -e "${color}Start ${component} service${nocolor}"
  systemctl daemon-reload   &>>${logfile}
  systemctl enable ${component}    &>>${logfile}
  systemctl restart ${component}   &>>${logfile}
  func_StatCheck $?
}

func_nodejs() {
  echo -e "${color}Enable 18 version ${nocolor}"
  dnf module disable nodejs -y    &>>${logfile}
  dnf module enable nodejs:18 -y    &>>${logfile}
  func_StatCheck $?
  
  echo -e "${color}Install nodejs${nocolor}"
  dnf install nodejs -y   &>>${logfile}
  func_StatCheck $?
  
  func_AppPresetup

  echo -e "${color}Download App Dependencies${nocolor}"
  npm install   &>>${logfile}
  func_StatCheck $?
  
  func_systemd
}

func_mongodb() {
  echo -e "${color}Setup mongodb repo${nocolor}"
  cp /home/centos/roboshop4-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>${logfile}
  func_StatCheck $?

  echo -e "${color}Install mongodb client${nocolor}"
  dnf install mongodb-org-shell -y    &>>${logfile}
  func_StatCheck $?

  echo -e "${color}Load schema${nocolor}"
  mongo --host mongodb-dev.smitdevops.online </app/schema/${component}.js   &>>${logfile}
  func_StatCheck $?
}

func_mysql() {
  echo -e "${color}Install Mysql Client${nocolor}"
  dnf install mysql -y    &>>${logfile}

  echo -e "${color}Load Schema${nocolor}"
  mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} </app/schema/${component}.sql    &>>${logfile}
}

func_maven() {
  echo -e "${color}Install Maven${nocolor}"
  dnf install maven -y    &>>${logfile}
  func_StatCheck $?

  func_AppPresetup

  echo -e "${color}Download App Dependencies${nocolor}"
  mvn clean package   &>>${logfile}
  mv target/${component}-1.0.jar ${component}.jar   &>>${logfile}
  func_StatCheck $?

  func_mysql

  func_systemd
}

func_python() {
  echo -e "${color}Install python${nocolor}"
  dnf install python36 gcc python3-devel -y   &>>${logfile}
  func_StatCheck $?

  func_AppPresetup

  echo -e "${color}Download Dependencies${nocolor}"
  pip3.6 install -r requirements.txt    &>>${logfile}
  func_StatCheck $?

  func_systemd
}