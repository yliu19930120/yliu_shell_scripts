

declare -A alia=([da]=yliu_data_akshare)
workPath=/home/admin/code/

function guide(){
	echo "支持以下程序包"
	echo "[python程序] yliu_data_akshare(da)"
	echo ""
	echo "输入发布项目,多个项目用空格隔开"

}

function main(){

	currentPath=`pwd`

	test -d $workPath || mkdir -p $workPath

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

		proid=`ps -ef | grep ${project} | grep -v grep | awk '{print $2}'`
		if [ -n "${proid}" ]
		then
		echo "kill 程序 ${project} pid=${proid}"
		kill -9 ${proid}
		fi
		echo ''
		echo "启动程序 ${project} 日志输出到${workPath}${project}.log"
		cd ${workPath}

		nohup python3 ${proName}/app.py >>/dev/null  2>&1 &
	done
	echo ' '
	echo '打包完了..........'

	cd ${currentPath}
}

main
