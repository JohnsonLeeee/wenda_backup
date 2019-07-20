#!/usr/bin/bash

# 对msyql,redis进行每日备份，并上传至github

DATE=$(date +%Y_%m_%d-%H-%M-%S)
echo "==========================================================现在是:$DATE=============================================================================="
echo "===========================================================开始备份=================================================================================="

#主机
HOST=localhost
# read -t 5 -p "请输入MySQL地址（默认localhost）：" HOST
#用户名
DB_USER=root
# read -t 5 -p "请输入MySQL用户名（默认root）：" DB_USER
#密码
DB_PWD=is.mMxl:w1:l
# read -t 5 -p "请输入MySQL密码：" -s DB_PWD
#s数据库名
DB_NAME=wenda
#备份的路径
BACKUP=./


#备份mysql
#短路运算，条件为真，则||后不执行
MYSQL_BACKUP_HOME=$BACKUP/mysql
[ -d $MYSQL_BACKUP_HOME ] || mkdir -p $MYSQL_BACKUP_HOME
#备份msyql数据库
mysqldump -u${DB_USER} -p${DB_PWD} -B ${DB_NAME} > $MYSQL_BACKUP_HOME/${DATE}.sql
# mysqldump -uroot -pis.mMxl:w1:l -B wenda

#备份redis数据库,直接cp即可
REDIS_DATA_HOME=/var/lib/redis
REDIS_BACKUP_HOME=$BACKUP/redis
[ -d $REDIS_BACKUP_HOME ] || mkdir -p $REDIS_BACKUP_HOME
[ -f $REDIS_DATA_HOME/dump.rdb ] && cp $REDIS_DATA_HOME/dump.rdb $REDIS_BACKUP_HOME/${DATE}.rdb || echo "$REDIS_DATA_HOME/dump.rdb不存在"

#删掉10天前的数据库  
find $BACKUP -mtime +10  \( -name "*.sql" -o -name "*.rdb" \) -exec rm -rf {} \;
# find . -type d -delete #删掉所有目录



echo "==============================================================本机备份路径为$BACKUP=============================================================="
 
