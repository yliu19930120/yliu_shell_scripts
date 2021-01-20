#!bin/bash
baseJars=(yliu_utils_redis yliu_utils_mongo yliu_base_core yliu_base_server yliu_crawler_core)
declare -A alia=([ec]=yliu_executer [sc]=yliu_scheduler [as]=yliu_appserver  [sd]=yliu_scheduler_server  [cs]=yliu_scheduler_server)
appserver=(yliu_appserver yliu_scheduler_server yliu_consumer_server)
workPath=/home/admin/java/work/
javaPath=/home/admin/code/
version="1.0-SNAPSHOT"

#接收两个参数1:打包的项目，2:打包的命令
function package(){
	echo "------------------------------我是分割线---------------------------------"
	project=$1
	cmd=$2
	jarPath=target/${project}-${version}.jar
	cd ${project}
	echo '打包项目:'${project}
	mvn clean ${cmd} -DskipTests
	echo '复制到工作目录:'
	cp ${jarPath} ${workPath}/${project}.jar -f
	cd ..
}
function guide(){
	echo "支持以下程序包"
	echo "[jar程序] yliu_executer(ec)|yliu_scheduler(sc)"
	echo "[server程序] yliu_appserver(as) yliu_scheduler_server(sd) yliu_consumer_server(cs)"
	echo ""
	echo "输入发布项目,多个项目用空格隔开"

}

function packBaseJars(){
  currentPath=`pwd`
  cd ${javaPath}
  for bj in ${baseJars[@]}
  do
    cd ${bj}
    echo "打包 ${bj}"
    echo `pwd`
    mvn clean install -DskipTests
    cd ..
  done
  cd ${currentPath}
}
function main(){

	currentPath=`pwd`

	test -d $workPath || mkdir -p $workPath

	cd ${javaPath}

	guide
	read -e name
	names=`(echo ${name})`
	pacBase=0
	for n in ${names[@]}
	do
		project=
		test -n ${alia[$n]} && project=${alia[$n]}
		test -z ${project} && echo "ERROR:程序名称错误" && continue
		test pacBase==0 && packBaseJars && pacBase=1

		cmd=assembly:assembly
		echo "${appserver[@]}" | grep -wq "${project}" &&  cmd=install
#		test ${project} =~ "appserver" && cmd=build
		package ${project}  ${cmd}

		proid=`ps -ef | grep ${project} | grep -v grep | awk '{print $2}'`
		if [ -n "${proid}" ]
		then
		echo "kill 程序 ${project} pid=${proid}"
		kill -9 ${proid}
		fi
		echo ''
		echo "启动程序 ${project} 日志输出到${workPath}logs/${project}.log"
		cd ${workPath}
		proName=${project}.jar
		#test ${project} =~ "appserver" && proName=${project}.jar
		echo "${appserver[@]}" | grep -wq "${project}" && proName=${project}.jar
		nohup java -jar ${proName} >>/dev/null  2>&1 &
		cd ${javaPath}
	done
	echo ' '
	echo '打包完了..........'

	cd ${currentPath}
}

main
