#!/bin/bash
logdate=`date +'%Y-%m-%d'`
source=/var/log/nginx
shopt -s dotglob
sudo tar zcvf $source/ngxlog_$logdate.tar.gz $source/*.log
for file in "${source}"/*.gz
do
   if [ -f "${file}" ]; then
      instance_details=` /home/ec2-user/scripts/ec2-metadata -i`
      find_str="instance-id: "
      replace_str=""
      instance_id=${instance_details//$find_str/$replace_str}
      aws s3 cp $file s3://alm2nginxlogs/WSNginxLogs/$instance_id/
      rm -f $file
   fi
done
