#!bin/bash
#代码拉取脚本

githost='git@github.com:yliu19930120/'
javaProPath=/home/admin/code/
javaProjects=('yliu_base_server' 'yliu_crawler' 'yliu_crawler_core' 'yliu_executer' 'yliu_utils_mongo' 'yliu_scheduler' 'yliu_utils_redis' 'yliu_base_core' 'yliu_scheduler_server' 'yliu_data_akshare' 'yliu_calculator' 'yliu_file' 'yliu_bksys_server')
serverProjects=('yliu_appserver' 'yliu_consumer_server')
sciptsProjects=('yliu_shell_scripts')

currentPath=`pwd`

test -d $projectPath || mkdir -p $projectPath

#拉取函数 参数1:工作路径;参数2:拉取的项目(注意是数组)
function pullOrClone(){

	projectPath=$1
	projects=`echo $2`

	echo "进入到路径:$projectPath"
	cd $projectPath
	echo "$projects"
	for p in ${projects}
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
	}
echo "拉取java项目"
pullOrClone $javaProPath "${javaProjects[*]}"
echo "拉取server项目"
pullOrClone $javaProPath "${serverProjects[*]}"

cd $currentPath
