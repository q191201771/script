#!/usr/bin/env bash
# @file   captrue_proc_info.sh
# @author chef <191201771@qq.com>
#

usage() {
  echo "Usage: $0 <proc name> <interval_sec> <cpu output file> <mem output file>"
}

[ $# != 4 ] && {
  usage
  exit
}

platform=`uname -a | awk '{print $1}'`
[ $platform != 'Linux' ] && {
  echo "Platform $platorm not support, only support linux."
  exit
}

proc_name=$1
echo "PROC NAME: $proc_name"
interval_sec=$2
cpu_output_file=$3
mem_output_file=$4

if [ -e $cpu_output_file ]; then
  mv $cpu_output_file ${cpu_output_file}.bak
fi
if [ -e $mem_output_file ]; then
  mv $mem_output_file ${mem_output_file}.bak
fi

for ((; ; )); do
  info=`ps aux | grep ${proc_name} | grep -v 'grep' | grep -v $0`
  echo "INFO: $info"

  pid=`echo ${info} | awk '{print $2}'`
  echo "PID: $pid"

  top_info=`top -b -p ${pid} -n1 | grep ${pid}`
  echo "TOP INFO: $top_info"

  cpu_percent=`echo ${top_info} | awk '{print $9}'`
  echo "CPU: $cpu_percent"
  echo $cpu_percent >> $cpu_output_file

  mem_rss=`echo ${info} | awk '{print $6}'`
  echo "RSS: $mem_rss"
  echo $mem_rss >> $mem_output_file

  sleep ${interval_sec}
done
