source common.sh

echo -e "${color}Installing Nginx${nocolor}"
dnf install nginx -y
func_StatCheck

echo -e "${color}Removing Default Dir${nocolor}"
rm -rf /usr/share/nginx/html/*
func_StatCheck

echo -e "${color}Download frontend content${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_StatCheck

echo -e "${color}Unzip frontend content${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
func_StatCheck

echo -e "${color}Setup reverse proxy${nocolor}"
cp /home/centos/roboshop4-shell/frontend.conf /etc/nginx/default.d/roboshop.conf
func_StatCheck

echo -e "${color}Start Nginx${nocolor}"
systemctl enable nginx
systemctl restart nginx
func_StatCheck