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


