source common.sh

echo -e "${color}Installing Nginx${nocolor}"
dnf install nginx -y    &>>${logfile}
func_StatCheck $?

echo -e "${color}Removing Default Dir${nocolor}"
rm -rf /usr/share/nginx/html/*    &>>${logfile}
func_StatCheck $?

echo -e "${color}Download frontend content${nocolor}"
curl -o /tmp/test.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip    &>>${logfile}
func_StatCheck $?

echo -e "${color}Unzip frontend content${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/test.zip     &>>${logfile}
func_StatCheck $?

echo -e "${color}Setup reverse proxy${nocolor}"
cp /home/centos/roboshop4-shell/test.conf /etc/nginx/default.d/roboshop.conf    &>>${logfile}
func_StatCheck $?

echo -e "${color}Start Nginx${nocolor}"
systemctl enable nginx    &>>${logfile}
systemctl restart nginx   &>>${logfile}
func_StatCheck $?