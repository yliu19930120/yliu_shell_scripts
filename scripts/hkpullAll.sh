#!/usr/bin/env bash
#代码拉取脚本
# @Author Yliu

githost='git@gitee.com:liu-mengchen3055/'
pythonPath=/home/admin/code/
pythonPros=('quant')

currentPath=`pwd`

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

echo "拉取python项目"
pullOrClone $pythonPath "${pythonPros[*]}"

cd $currentPath
