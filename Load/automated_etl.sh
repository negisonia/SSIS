# How to use
# ----------
# Run bash file as: ./automated_etl to get a list of available commands
# Bash file must be run inside of /Load folder
# Run bash file with this command: create_pg_pass ONLY ONCE to save the db connection strings

# Assumptions
# -----------
# Data-warehouse-storeprocedures git repository lives next to this project (under the same parent directory)

# NON CONFIGURABLE OPTIONS
# ---------------------
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

# Script paths
DATAWAREHOUSE_SCRIPT_PATH=data_warehouse/r20_data_warehouse.sql
FRONT_END_SCRIPT_PATH=front_end/front_end_db.sql
REPORT_DATA_SCRIPT_PATH=report_data/report_data_db.sql
ADMIN_SCRIPT_PATH=admin/r20_admin.sql
DATA_ENTRY_SCRIPT_PATH=dump/data_entry.sql
FF_NEW_SCRIPT_PATH=dump/ff_new.sql

# Host Names
DATA_ENTRY_DB_HOST=rdwo3djw14v9sq.cayadjd1xwwj.us-east-1.rds.amazonaws.com
DATA_ENTRY_DB_USER=r2de
SOURCE_DATA_ENTRY_DB_NAME=restrictions20_data_entry
FF_NEW_DB_HOST=proddb01.fingertipformulary.com
FF_NEW_DB_USER=postgres

create_pg_pass(){
  echo "$HOST:5432:postgres:$SERVER_POSTGRES_PASSWORD" >> $HOME/.pgpass
  echo "proddb01.fingertipformulary.com:5432:postgres:" >> $HOME/.pgpass
  echo "rdwo3djw14v9sq.cayadjd1xwwj.us-east-1.rds.amazonaws.com:5432:r2de:eod9Phouch1ued7sahho" >> $HOME/.pgpass
  echo "restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com:5432:postgres:VsOCWIozIelwQcRgR4w3" >> $HOME/.pgpass
  chmod 0600 $HOME/.pgpass
}

create_and_load_db()
{
  createdb -h $HOST -U postgres $1
  psql -d $1 -h $HOST -U postgres < $2
}

delete_db()
{
  dropdb -h $HOST -U postgres $1
}

delete_temp_dbs()
{
  echo "  - REBUILD_ENV: Deleting existing temporary databases if already created"

  delete_db $TEMP_DATAWAREHOUSE_DB_NAME
  delete_db $TEMP_FRONT_END_DB_NAME
  delete_db $TEMP_REPORT_DATA_DB_NAME
  delete_db $TEMP_ADMIN_DB_NAME
}

delete_final_dbs()
{
  echo "  - REBUILD_ENV: Deleting final databases if already created"

  delete_db $DATAWAREHOUSE_DB_NAME
  delete_db $FRONT_END_DB_NAME
  delete_db $REPORT_DATA_DB_NAME
  delete_db $ADMIN_DB_NAME
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
  pg_dump -s $SOURCE_DATA_ENTRY_DB_NAME -h $DATA_ENTRY_DB_HOST -n public -U $DATA_ENTRY_DB_USER -p 5432 > $DATA_ENTRY_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for data entry and loading script"
  create_and_load_db $TEMP_DATA_ENTRY_DB_NAME $DATA_ENTRY_SCRIPT_PATH

  
  echo "  - REBUILD_ENV: Dumping ff new"
  pg_dump --exclude-table "DELETE*" -s ff_new -h $FF_NEW_DB_HOST -n public -U $FF_NEW_DB_USER -p 5432 > $FF_NEW_SCRIPT_PATH
  echo "  - REBUILD_ENV: Creating temp database for ff new and loading script"
  create_and_load_db $TEMP_FF_NEW_DB_NAME $FF_NEW_SCRIPT_PATH
}

load_scripts_on_temp(){
  cd ../

  echo "  - REBUILD_ENV: Loading Admin scripts"
  psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres < Load/load_admin.sql

  echo "  - REBUILD_ENV: Loading Data Warehouse scripts"
  psql -d $TEMP_DATAWAREHOUSE_DB_NAME -h $HOST -U postgres < Load/load_data_warehouse.sql

  echo "  - REBUILD_ENV: Loading FF New scripts"
  psql -d $TEMP_FF_NEW_DB_NAME -h $HOST -U postgres < Load/load_ff_new.sql

  echo "  - REBUILD_ENV: Loading Front End scripts"
  psql -d $TEMP_FRONT_END_DB_NAME -h $HOST -U postgres < Load/load_front_end.sql  

  echo "  - REBUILD_ENV: Loading Data Entry scripts"
  psql -d $TEMP_DATA_ENTRY_DB_NAME -h $HOST -U postgres < Load/load_data_entry.sql    
}

alter_temp_foreign_servers(){
  alter_foreign_servers $TEMP_FF_NEW_DB_NAME $TEMP_DATA_ENTRY_DB_NAME $TEMP_ADMIN_DB_NAME $TEMP_DATAWAREHOUSE_DB_NAME $TEMP_FRONT_END_DB_NAME $TEMP_REPORT_DATA_DB_NAME $SERVER_POSTGRES_PASSWORD $HOST
}

alter_foreign_servers(){
  echo "  - REBUILD_ENV: Alter foreign servers"

  echo "  - REBUILD_ENV: Alter Data-warehouse foreign servers"
  psql -d $4 -h $8 -U postgres < alter_data_warehouse_foreign_servers.sql
  psql -d $4 -h $8 -U postgres -c "Select alter_datawarehouse_foreign_servers('$8', '$1', '$2', '$3', '$7');"

  echo "  - REBUILD_ENV: Alter Report Data foreign servers"
  psql -d $6 -h $8 -U postgres < alter_report_data_foreign_servers.sql
  psql -d $6 -h $8 -U postgres -c "Select alter_report_data_foreign_servers('$8', '$4', '$5', '$7');"

  echo "  - REBUILD_ENV: Alter Admin foreign servers"
  psql -d $3 -h $8 -U postgres < alter_admin_foreign_servers.sql
  psql -d $3 -h $8 -U postgres -c "Select alter_admin_foreign_servers('$8', '$4', '$7');"
}

alter_final_foreign_servers(){
  alter_foreign_servers $FF_NEW_DB_NAME $DATA_ENTRY_DB_NAME $ADMIN_DB_NAME $DATAWAREHOUSE_DB_NAME $FRONT_END_DB_NAME $REPORT_DATA_DB_NAME $SERVER_POSTGRES_PASSWORD $HOST
}

rebuild_temp_test_enviroment(){
  build_temp_etl  
  build_temp_non_etl
  load_scripts_on_temp
}

build_temp_etl(){

  echo "  - REBUILD_ENV: Downloading latest changes from data-warehouse-storeprocedures repository"
  cd ../../
  cd data-warehouse-storeprocedures/
  git pull origin master

  delete_temp_dbs

  create_and_load_etl_dbs

  alter_temp_foreign_servers
}

build_temp_non_etl(){
  cd ../
  mkdir dump
  create_and_load_ff_new_data_entry
}

kill_session(){
  psql -d $1 -h $HOST -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname = '$1'";
}

rename_db(){
  psql -d $1 -h $HOST -U postgres -c "ALTER DATABASE tmp_$2 RENAME TO $2"
}

switch_db(){
  # Deletes the current final dbs to be replaced by the temporary ones
  delete_final_dbs

  # Rname the temp db names to the final db names
  echo "  - REBUILD_ENV: Renaming datawarehouse"
  kill_session $TEMP_DATAWAREHOUSE_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $DATAWAREHOUSE_DB_NAME
  
  echo "  - REBUILD_ENV: Renaming front end"
  kill_session $TEMP_FRONT_END_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $FRONT_END_DB_NAME

  echo "  - REBUILD_ENV: Renaming report data"
  kill_session $TEMP_REPORT_DATA_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $REPORT_DATA_DB_NAME

  echo "  - REBUILD_ENV: Renaming admin"
  kill_session $TEMP_ADMIN_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $ADMIN_DB_NAME

  echo "  - REBUILD_ENV: Renaming data entry"
  kill_session $TEMP_DATA_ENTRY_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $DATA_ENTRY_DB_NAME

  echo "  - REBUILD_ENV: Renaming ff new"
  kill_session $TEMP_FF_NEW_DB_NAME
  rename_db $DATAWAREHOUSE_DB_NAME $FF_NEW_DB_NAME

  alter_final_foreign_servers
}

get_params(){
  # First set of params
  get_param_option $2 $3
  # Second set of params
  get_param_option $4 $5
}

get_param_option(){
  case ${1} in
       -h) HOST="${2}" 
          echo "Host is $HOST"
          ;; 
       -p) SERVER_POSTGRES_PASSWORD="${2}" 
          echo "Postgres password is $SERVER_POSTGRES_PASSWORD"
          ;; 
       *)
        echo "  - REBUILD_ENV: ERROR Missing parameters or wrong parameter names "
        usage_msg
        ;;
  esac
}

usage_msg(){
  echo -e "\nUsage: \n"
  echo -e "  `basename ${0}` [create_pg_pass] | {[rebuild_temp_test_enviroment] | [switch] | [delete_temp_dbs] -h host -p postgres_password} \n"
  echo "  [create_pg_pass] : Run ONLY ONCE to setup the conection string and avoid being prompted for passwords"
  echo "  [rebuild_temp_test_enviroment] -h host -p postgres_password : Build all ETL and non ETL scripts in temporary dbs, alters foreign servers and loads testing scripts"
  echo "  [switch] -h host -p postgres_password : Deletes currents dbs and makes temporary dbs the new dbs, alters foreign servers"
  echo -e "  [delete_temp_dbs] -h host -p postgres_password : Deletes temporary dbs \n"
  exit 1 # Command to come out of the program with status 1
}

  case "$1" in
    "create_pg_pass") echo "  - REBUILD_ENV: Creating pg pass file "
        create_pg_pass
     ;;
    "rebuild_temp_test_enviroment") echo "  - REBUILD_ENV: Rebuilding temporary enviroments of ETL dbs "
        get_params $1 $2 $3 $4 $5
        rebuild_temp_test_enviroment
     ;;
     "switch")  echo "  - REBUILD_ENV: Deleting existing db enviroments and renaming temporary dbs "
        get_params $1 $2 $3 $4 $5
        switch_db
     ;;
     "delete_temp_dbs") echo "  - REBUILD_ENV: Deleting temporary dbs "
        get_params $1 $2 $3 $4 $5
        delete_temp_dbs
     ;;
    *)
      usage_msg
      ;;
  esac

exit 0