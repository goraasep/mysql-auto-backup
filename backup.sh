#!/bin/bash
#script auto backup database by ecampuz
#bagian-1
user=userbackup
pass=pass123
host=localhost
dir=/home/ecampuz/backup_sql
port=3306
#bagian-2
backup(){
  date=$(date +%Y%m%d-%H%M)
  tanggal=$(date +%d)
  bulan=$(date +%m)
  tahun=$(date +%Y)
  if [ ! -d "$dir/$tahun/$bulan/$tanggal/" ];
    then mkdir --parents $dir/$tahun/$bulan/$tanggal;
  fi
  dump=/usr/bin/mysqldump
  $dump $dbs -u$user -p$pass -h$host -P$port -R -K --triggers > $dir/$tahun/$bulan/$tanggal/$dbs-$date.sql
  gzip -f $dir/$tahun/$bulan/$tanggal/$dbs-$date.sql
}

#bagian-3
#######jika seluruh db dalam grant tersebut ingin dibackup
sql=/usr/bin/mysql

for dbs in $($sql -u$user -p$pass -e 'show databases' | sed 1d); 
do if [ "$dbs" != "mysql" ] || [ "$dbs" != "information_schema" ] || [ "$dbs" != "performance_schema" ]; 
then backup; 
fi; 
done;

#bagian-4
#######jika database ditentukan yang akan dibackup

#database="db1 db2 db3"
#for dbs in $database
#do
#backup
#done
exit 0

#bagian-5
rm `find $dir/ -mtime +365`
