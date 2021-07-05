#!/bin/sh

if [ ! -f docker-compose.yml ] ; then
  echo "We are not in a docker-compose repository"
  exit
fi

docker-compose ps | cut -d ' ' -f 1| tail -n +3 > /tmp/list_containers.txt

if [ ! -d "/opt/monit/bin" ] ; then
  mkdir -p /opt/monit/bin
fi

for i in `cat /tmp/list_containers.txt` ; do
echo "#!/bin/sh

sudo docker top ${i};
exit \$?;
" > /opt/monit/bin/docker_check_${i}.sh

chmod +x  /opt/monit/bin/docker_check_${i}.sh

echo "
check program ${i} with path /opt/monit/bin/docker_check_${i}.sh
  if status != 0 then alert
" > /etc/monit/conf.d/docker_${i}
done

rm /tmp/list_containers.txt
