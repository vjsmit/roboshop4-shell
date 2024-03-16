echo -e "${color}${nocolor}"
color="\e[1;34m"
nocolor="\e[1;0m"

logfile="/tmp/roboshop.log"

#user_id=$(id -u)
#
#if [ $user_id -ne 0 ]; then
#    echo -e "\e[31mRoot permission required to proceed\e[0m"
#fi

func_StatCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
  fi
}

