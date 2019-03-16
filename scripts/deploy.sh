#!bin/bash
projects=('yliu_executer' 'yliu_scheduler')
declare -A alia=([ec]=yliu_executer [sc]=yliu_scheduler)
workPath=/home/admin/java/work/
javaPath=/home/admin/java/yliu/
setGradlePath=/home/admin/yliu_shell_scripts/gradle/settings.gradle

function package(){
	echo "------------------------------我是分割线---------------------------------"
	project=$1	
	jarPath=${project}/build/libs/${project}-all.jar
	echo '打包项目:'${project}
	gradle ${project}:clean ${project}:shadowJar -c $setGradlePath
	echo '复制到工作目录:'
	cp ${jarPath} ${workPath}/${project}-all.jar -f 
}
function guide(){
	echo "支持以下程序包"
	echo "[jar程序] yliu_executer(ec)|yliu_scheduler(sc)"
	echo ""
	echo "输入发布项目,多个项目用空格隔开"

}
function main(){
	
	currentPath=`pwd`
	
	test -d $javaPath || mkdir -p $javaPath
	
	cd ${javaPath}
	
	guide
	read -e name
	names=`(echo ${name})`
	for n in ${names[@]}
	do	
		project=
		test -n ${alia[$n]} && project=${alia[$n]}
		test -z ${project} && echo "ERROR:程序名称错误" && continue
		package ${project}
		fileName=`ls ${javaPath}${project}/build/libs/*`
		echo "复制${fileName} 到 ${workPath}"
		cp ${fileName} ${workPath} -f 
		
		proid=`ps -ef | grep ${project} | grep -v grep | awk '{print $2}'`
		if [ -n "${proid}" ]
		then
		echo "kill 程序 ${project} pid=${proid}"
		kill -9 ${proid}
		fi	
		echo ''
		echo "启动程序 ${project} 日志输出到${workPath}logs/${project}.log"
		cd ${workPath}
		nohup java -jar ${project}-all.jar >>/dev/null  2>&1 &
		cd ${javaPath}
	done	
	echo ' '
	echo '打包完了..........'
	
	cd ${currentPath}
}

main
