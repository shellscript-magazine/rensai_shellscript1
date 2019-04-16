#!/bin/sh

case $1 in
  0 ) sed "/^#/d" $2 ;;
  1 ) grep -v "^#" $2 | grep -v "^$" ;;
esac
