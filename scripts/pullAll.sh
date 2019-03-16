#!bin/bash
projectPath=/home/admin/java/yliu/
githost='git@github.com:yliu19930120/'
projects=('yliu_base_server' 'yliu_crawler' 'yliu_crawler_core' 'yliu_executer' 'yliu_utils_mongo' 'yliu_scheduler' 'yliu_utils_redis')
currentPath=`pwd`
test -d $projectPath || mkdir -p $projectPath
cd $projectPath
for p in ${projects[@]}
do 
	echo '拉取项目:'${p}
if [ -e ${p} ]
then
	cd ${p}
	git pull ${githost}${p}
	cd ..
else
	git clone ${githost}${p}
fi
done

cd $currentPath
