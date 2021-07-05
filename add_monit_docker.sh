#!/bin/sh

if [ "X$1" = "X" ]
then
echo "I need container name"
exit
fi
container=$1
if [ ! -d "/opt/monit/bin" ]
then
  mkdir -p /opt/monit/bin
fi

echo "#!/bin/sh

sudo docker top ${container};
exit \$?;
" > /opt/monit/bin/docker_check_${container}.sh

chmod +x  /opt/monit/bin/docker_check_${container}.sh

echo "
check program ${container} with path /opt/monit/bin/docker_check_${container}.sh
  if status != 0 then alert
" > /etc/monit/conf.d/docker_${container}
