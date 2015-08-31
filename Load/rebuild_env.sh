# Assumptions
# -----------
# Data-warehouse-storeprocedures git repository lives next to this project (under the same parent directory)

# CONFIGURATION OPTIONS
# ---------------------
HOST=localhost

# Temp Database Names
TEMP_DATAWAREHOUSE_DB_NAME=tmp_sandbox_datawarehouse
TEMP_FRONT_END_DB_NAME=tmp_sandbox_front_end
TEMP_REPORT_DATA_DB_NAME=tmp_sandbox_report_data
TEMP_ADMIN_DB_NAME=tmp_sandbox_admin
TEMP_DATA_ENTRY_DB_NAME=tmp_sandbox_data_entry
TEMP_FF_NEW_DB_NAME=tmp_sandbox_ff_new

# Final Database Names
DATAWAREHOUSE_DB_NAME=sandbox_datawarehouse
FRONT_END_DB_NAME=sandbox_front_end
REPORT_DATA_DB_NAME=sandbox_report_data
ADMIN_DB_NAME=sandbox_admin
DATA_ENTRY_DB_NAME=sandbox_data_entry
FF_NEW_DB_NAME=sandbox_ff_new

# Local Postgres Password
SERVER_POSTGRES_PASSWORD=gap2012

# NOT CONFIGURABLE OPTIONS
# ---------------------
DATAWAREHOUSE_SCRIPT_PATH=data_warehouse/r20_data_warehouse.sql
FRONT_END_SCRIPT_PATH=front_end/front_end_db.sql
REPORT_DATA_SCRIPT_PATH=report_data/report_data_db.sql
ADMIN_SCRIPT_PATH=admin/r20_admin.sql
DATA_ENTRY_SCRIPT_PATH=dump/data_entry.sql
FF_NEW_SCRIPT_PATH=dump/ff_new.sql
DATA_ENTRY_DB_HOST=rdwo3djw14v9sq.cayadjd1xwwj.us-east-1.rds.amazonaws.com
DATA_ENTRY_DB_USER=r2de
DATA_ENTRY_DB_NAME=restrictions20_data_entry
FF_NEW_DB_HOST=proddb01.fingertipformulary.com
FF_NEW_DB_USER=postgres

create_and_load_db()
{
  createdb -h $HOST -U postgres -W $1
  psql -d $1 -h $HOST -U postgres -W < $2
}

delete_db()
{
  dropdb -h $HOST -U postgres -W $1
}

delete_temp()
{
  echo "  - REBUILD_ENV: Deleting existing temporary databases if already created"

  delete_db $TEMP_DATAWAREHOUSE_DB_NAME
  delete_db $TEMP_FRONT_END_DB_NAME
  delete_db $TEMP_REPORT_DATA_DB_NAME
  delete_db $TEMP_ADMIN_DB_NAME
}

create_and_load_etl_dbs(){
  echo "  - REBUILD_ENV: Creating temp database for datawarehouse"
  create_and_load_db $TEMP_DATAWAREHOUSE_DB_NAME $DATAWAREHOUSE_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for front end"
  create_and_load_db $TEMP_FRONT_END_DB_NAME $FRONT_END_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for report data"
  create_and_load_db $TEMP_REPORT_DATA_DB_NAME $REPORT_DATA_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for admin"
  create_and_load_db $TEMP_ADMIN_DB_NAME $ADMIN_SCRIPT_PATH  
}

create_and_load_ff_new_data_entry(){
  echo "  - REBUILD_ENV: Dumping data entry"
  #pg_dump -s $DATA_ENTRY_DB_NAME -h $DATA_ENTRY_DB_HOST -n public -U $DATA_ENTRY_DB_USER -p 5432 -W > $DATA_ENTRY_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for data entry and loading script"
  #create_and_load_db $TEMP_DATA_ENTRY_DB_NAME $DATA_ENTRY_SCRIPT_PATH

  
  echo "  - REBUILD_ENV: Dumping ff new"
  pg_dump --exclude-table public."DELETE*" -s ff_new -h $FF_NEW_DB_HOST -n public -U $FF_NEW_DB_USER -p 5432 -W > $FF_NEW_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for ff new and loading script"
  create_and_load_db $TEMP_FF_NEW_DB_NAME $FF_NEW_SCRIPT_PATH
}

load_scripts(){
  echo "  - REBUILD_ENV: Loading Admin scripts"

  psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres -W < Load/load_admin.sql

  echo "  - REBUILD_ENV: Loading Data Warehouse scripts"

  psql -d $TEMP_DATAWAREHOUSE_DB_NAME -h $HOST -U postgres -W < Load/load_data_warehouse.sql

  echo "  - REBUILD_ENV: Loading FF New scripts"

  psql -d $TEMP_FF_NEW_DB_NAME -h $HOST -U postgres -W < Load/load_ff_new.sql

  echo "  - REBUILD_ENV: Loading Front End scripts"

  psql -d $TEMP_FRONT_END_DB_NAME -h $HOST -U postgres -W < Load/load_front_end.sql  
}

alter_temp_foreign_servers(){
  alter_foreign_servers $TEMP_FF_NEW_DB_NAME $TEMP_DATA_ENTRY_DB_NAME $TEMP_ADMIN_DB_NAME $TEMP_DATAWAREHOUSE_DB_NAME $TEMP_FRONT_END_DB_NAME $TEMP_REPORT_DATA_DB_NAME $SERVER_POSTGRES_PASSWORD $HOST

  #echo "  - REBUILD_ENV: Alter foreign servers"

  #echo "  - REBUILD_ENV: Alter Data-warehouse foreign servers"
  #psql -d $TEMP_DATAWAREHOUSE_DB_NAME -h $HOST -U postgres -W < alter_data_warehouse_foreign_servers.sql
  #psql -d $TEMP_DATAWAREHOUSE_DB_NAME -h $HOST -U postgres -W -c "Select alter_datawarehouse_foreign_servers('$HOST', '$TEMP_FF_NEW_DB_NAME', '$TEMP_DATA_ENTRY_DB_NAME', '$TEMP_ADMIN_DB_NAME', '$SERVER_POSTGRES_PASSWORD');"

  #echo "  - REBUILD_ENV: Alter Report Data foreign servers"
  #psql -d $TEMP_REPORT_DATA_DB_NAME -h $HOST -U postgres -W < alter_report_data_foreign_servers.sql
  #psql -d $TEMP_REPORT_DATA_DB_NAME -h $HOST -U postgres -W -c "Select alter_report_data_foreign_servers('$HOST', '$TEMP_DATAWAREHOUSE_DB_NAME', '$TEMP_FRONT_END_DB_NAME', '$SERVER_POSTGRES_PASSWORD');"

  #echo "  - REBUILD_ENV: Alter Admin foreign servers"
  #psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres -W < alter_admin_foreign_servers.sql
  #psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres -W -c "Select alter_admin_foreign_servers('$HOST', '$TEMP_DATAWAREHOUSE_DB_NAME', '$SERVER_POSTGRES_PASSWORD');"
}

alter_foreign_servers(){
  echo "  - REBUILD_ENV: Alter foreign servers"

  echo "  - REBUILD_ENV: Alter Data-warehouse foreign servers"
  psql -d $4 -h $8 -U postgres -W < alter_data_warehouse_foreign_servers.sql
  psql -d $4 -h $8 -U postgres -W -c "Select alter_datawarehouse_foreign_servers('$8', '$1', '$2', '$3', '$7');"

  echo "  - REBUILD_ENV: Alter Report Data foreign servers"
  psql -d $6 -h $8 -U postgres -W < alter_report_data_foreign_servers.sql
  psql -d $6 -h $8 -U postgres -W -c "Select alter_report_data_foreign_servers('$8', '$4', '$5', '$7');"

  echo "  - REBUILD_ENV: Alter Admin foreign servers"
  psql -d $3 -h $8 -U postgres -W < alter_admin_foreign_servers.sql
  psql -d $3 -h $8 -U postgres -W -c "Select alter_admin_foreign_servers('$8', '$4', '$7');"
}

alter_final_foreign_servers(){
  alter_foreign_servers $FF_NEW_DB_NAME $DATA_ENTRY_DB_NAME $ADMIN_DB_NAME $DATAWAREHOUSE_DB_NAME $FRONT_END_DB_NAME $REPORT_DATA_DB_NAME $SERVER_POSTGRES_PASSWORD $HOST
}

build_temp(){

#  echo "  - REBUILD_ENV: Downloading latest changes from data-warehouse-storeprocedures repository"
#  cd ../../
#  cd data-warehouse-storeprocedures/
#  git pull origin master

#  delete_temp

#  create_and_load_etl_dbs

#  cd ../
#  cd data-warehouse-storeprocedures-tests/Load

  cd ../
#  mkdir dump
#  create_and_load_ff_new_data_entry

#  alter_temp_foreign_servers

  load_scripts
}

switch_db(){

  delete_db $DATAWAREHOUSE_DB_NAME
  delete_db $FRONT_END_DB_NAME
  delete_db $REPORT_DATA_DB_NAME
  delete_db $ADMIN_DB_NAME

  psql -d $4 -h $HOST -U postgres -W < alter_data_warehouse_foreign_servers.sql
  psql -d $4 -h $HOST -U postgres -W -c "Select alter_datawarehouse_foreign_servers('$8', '$1', '$2', '$3', '$7');"

#  echo "  - REBUILD_ENV: Renaming temporary dbs"
 # psql -h $HOST -U postgres <<EOF
  #\x
   # ALTER DATABASE $TEMP_DATAWAREHOUSE_DB_NAME RENAME TO $DATAWAREHOUSE_DB_NAME;
    #ALTER DATABASE $TEMP_FRONT_END_DB_NAME RENAME TO $FRONT_END_DB_NAME;
    #ALTER DATABASE $TEMP_REPORT_DATA_DB_NAME RENAME TO $REPORT_DATA_DB_NAME;
    #ALTER DATABASE $TEMP_ADMIN_DB_NAME RENAME TO $ADMIN_DB_NAME;
    #ALTER DATABASE $TEMP_DATA_ENTRY_DB_NAME RENAME TO $DATA_ENTRY_DB_NAME;
    #ALTER DATABASE $TEMP_FF_NEW_DB_NAME RENAME TO $FF_NEW_DB_NAME;
  #EOF
  alter_final_foreign_servers
}

#if [ "$1" != "" ]
#then
  case "$1" in
     "build_temp")  echo "  - REBUILD_ENV: Rebuilding temporary enviroments "
                    build_temp
     ;;
     "switch")  echo "  - REBUILD_ENV: Deleting existing db enviroments and renaming temporary dbs "
                switch_db
     ;;
     "delete_temp") echo "  - REBUILD_ENV: Deleting temporary dbs "
                    delete_temp
     ;;
     "alter_temp_foreign_servers") echo "  - REBUILD_ENV: Altering foreign servers "
                    alter_temp_foreign_servers
     ;;
     "load_scripts") echo "  - REBUILD_ENV: Loading scripts for ETL Testing "
                    load_scripts
     ;;
    *)
      echo -e "\nUsage: \n"
      echo -e "  `basename ${0}` [build_temp] | [switch] | [delete_temp] | [alter_temp_foreign_servers] | [load_scripts] \n"
      echo "  [build_temp] : Builds temporary dbs from master repository, alters foreign servers and loads etl scripts"
      echo "  [switch] : Deletes currents dbs and makes temporary dbs the new dbs, alter foreign servers"
      echo "  [delete_temp] : Deletes temporary dbs"
      echo "  [alter_temp_foreign_servers] : Alters the foreign server for the temporary dbs"
      echo -e "  [load_scripts] : Loads ETL Testing scripts \n"
      exit 1 # Command to come out of the program with status 1
      ;; 
  esac



  #if ["$1" == "build_temp" || "$1" == "switch" || "$1" == "delete_temp"]
  #then
  #  if [ "$1" = "build_temp" ]
  #  then
  #      echo "  - REBUILD_ENV: Rebuilding temporary enviroments "
  #      build_temp
  #  elif [ "$1" = "switch" ]
  #  then
  #      echo "  - REBUILD_ENV: Deleting existing db enviroments and renaming temporary dbs "
  #      switch_db
  #  elif [ "$1" = "delete_temp" ]
  #      echo "  - REBUILD_ENV: Deleting temporary dbs "
  #      delete_temp
  #  fi
  #else
  #  echo "Wrong parameter name"
  #fi
#else
#  echo "Missing parameter"
#fi

exit 0