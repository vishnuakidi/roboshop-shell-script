#!/bin/bash
check_root() {
  USER_ID = $(id -u)
  if [$USER_ID -ne 0 ]; then
    echo -e "\e[31mYou should be running this script as root user, or sudo is required"
    exit 1
    fi
}

check_stat() {
  if [ $1 -ne 0 ]; then
    echo -e "\e[31mFailed\e[0m"
    exit 2
  else
    echo -e "\e[32mSUCESS\e[0m"
  fi
}

app_setup(){
  check_root
  yum install nginx -y
  check_stat $?

  Print "Download  ${component} content"
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip"
  check_stat $?

  PRINT "clean old content"
   cd /usr/share/nginx/html
   rm -rf *
   check_stat $?

   PRINT "Extract ${component} content"
   unzip /tmp/${component}.zip
   check_stat $?

   PRINT "organize ${component} content"
   mv ${component}-main/* . && mv static/* . && rm -rf ${component}-master README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf
   check $?

   for backend in catalogue cart user shipping payment; do
     PRINT "Update configuration $backend"
     sed -i -e "/$backend/ s/localhost/$backend.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
     check_stat $?
     done

   PRINT "Start nginx service"
   systemctl enable nginx && systemctl restart nginx
   check_stat $?
}
