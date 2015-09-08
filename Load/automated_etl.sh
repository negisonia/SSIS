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
DUMP_FOLDER_PATH=dump

# Host Names
DATA_ENTRY_DB_HOST=rdwo3djw14v9sq.cayadjd1xwwj.us-east-1.rds.amazonaws.com
DATA_ENTRY_DB_USER=r2de
SOURCE_DATA_ENTRY_DB_NAME=restrictions20_data_entry
FF_NEW_DB_HOST=proddb01.fingertipformulary.com
FF_NEW_DB_USER=postgres
QA_DB_HOST=restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com
QA_DB_PREFIX=sandbox

# CLONE OPTIONS
# DB NAMES
ADMIN=admin
DATAWAREHOUSE=datawarehouse
DATA_ENTRY=data_entry
FF_NEW=ff_new
FRONT_END=front_end
REPORT_DATA=report_data
db_names="$ADMIN $DATAWAREHOUSE $FRONT_END $REPORT_DATA $DATA_ENTRY $FF_NEW"
DEFAULT_PREFIX=sandbox

create_pg_pass(){
  echo "$HOST:5432:postgres:$SERVER_POSTGRES_PASSWORD" >> $HOME/.pgpass
  echo "$FF_NEW_DB_HOST:5432:postgres:" >> $HOME/.pgpass
  echo "$DATA_ENTRY_DB_HOST:5432:$DATA_ENTRY_DB_USER:eod9Phouch1ued7sahho" >> $HOME/.pgpass
  echo "$QA_DB_HOST:5432:postgres:VsOCWIozIelwQcRgR4w3" >> $HOME/.pgpass
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
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting existing temporary databases if already created"

  delete_db $TEMP_DATAWAREHOUSE_DB_NAME
  delete_db $TEMP_FRONT_END_DB_NAME
  delete_db $TEMP_REPORT_DATA_DB_NAME
  delete_db $TEMP_ADMIN_DB_NAME
  delete_db $TEMP_DATA_ENTRY_DB_NAME
  delete_db $TEMP_FF_NEW_DB_NAME
}

delete_final_dbs()
{
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting final databases if already created"

  delete_db $DATAWAREHOUSE_DB_NAME
  delete_db $FRONT_END_DB_NAME
  delete_db $REPORT_DATA_DB_NAME
  delete_db $ADMIN_DB_NAME
  delete_db $DATA_ENTRY_DB_NAME
  delete_db $FF_NEW_DB_NAME
}

delete_clone_dbs()
{
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting clone databases if already created"

  for db_name in $db_names
  do
    PREFIX_DB_NAME="${PREFIX}_${db_name}"

    kill_session $PREFIX_DB_NAME
    delete_db $PREFIX_DB_NAME
  done
}

create_and_load_etl_dbs(){
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for datawarehouse"
  create_and_load_db $TEMP_DATAWAREHOUSE_DB_NAME $DATAWAREHOUSE_SCRIPT_PATH
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for front end"
  create_and_load_db $TEMP_FRONT_END_DB_NAME $FRONT_END_SCRIPT_PATH
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for report data"
  create_and_load_db $TEMP_REPORT_DATA_DB_NAME $REPORT_DATA_SCRIPT_PATH
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for admin"
  create_and_load_db $TEMP_ADMIN_DB_NAME $ADMIN_SCRIPT_PATH  
}

create_and_load_ff_new_data_entry(){
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Dumping data entry"
  pg_dump -s $SOURCE_DATA_ENTRY_DB_NAME -h $DATA_ENTRY_DB_HOST -n public -U $DATA_ENTRY_DB_USER -p 5432 > $DATA_ENTRY_SCRIPT_PATH
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for data entry and loading script"
  create_and_load_db $TEMP_DATA_ENTRY_DB_NAME $DATA_ENTRY_SCRIPT_PATH

  
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Dumping ff new"
  pg_dump --exclude-table "DELETE*" -s ff_new -h $FF_NEW_DB_HOST -n public -U $FF_NEW_DB_USER -p 5432 -x > $FF_NEW_SCRIPT_PATH
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for ff new and loading script"
  create_and_load_db $TEMP_FF_NEW_DB_NAME $FF_NEW_SCRIPT_PATH
}

load_scripts_on_temp(){
  cd ../

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Loading Admin scripts"
  psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres < Load/load_admin.sql

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Loading Data Warehouse scripts"
  psql -d $TEMP_DATAWAREHOUSE_DB_NAME -h $HOST -U postgres < Load/load_data_warehouse.sql

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Loading FF New scripts"
  psql -d $TEMP_FF_NEW_DB_NAME -h $HOST -U postgres < Load/load_ff_new.sql

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Loading Front End scripts"
  psql -d $TEMP_FRONT_END_DB_NAME -h $HOST -U postgres < Load/load_front_end.sql  

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Loading Data Entry scripts"
  psql -d $TEMP_DATA_ENTRY_DB_NAME -h $HOST -U postgres < Load/load_data_entry.sql    
}

alter_temp_foreign_servers(){
  alter_foreign_servers $TEMP_FF_NEW_DB_NAME $TEMP_DATA_ENTRY_DB_NAME $TEMP_ADMIN_DB_NAME $TEMP_DATAWAREHOUSE_DB_NAME $TEMP_FRONT_END_DB_NAME $TEMP_REPORT_DATA_DB_NAME $SERVER_POSTGRES_PASSWORD $HOST
}

alter_foreign_servers(){
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter foreign servers"

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Data-warehouse foreign servers"
  psql -d $4 -h $8 -U postgres < alter_data_warehouse_foreign_servers.sql
  psql -d $4 -h $8 -U postgres -c "Select alter_datawarehouse_foreign_servers('$8', '$1', '$2', '$3', '$7');"

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Report Data foreign servers"
  psql -d $6 -h $8 -U postgres < alter_report_data_foreign_servers.sql
  psql -d $6 -h $8 -U postgres -c "Select alter_report_data_foreign_servers('$8', '$4', '$5', '$7');"

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Admin foreign servers"
  psql -d $3 -h $8 -U postgres < alter_admin_foreign_servers.sql
  psql -d $3 -h $8 -U postgres -c "Select alter_admin_foreign_servers('$8', '$4', '$1', '$7');"

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Data Entry foreign servers"
  psql -d $2 -h $8 -U postgres < alter_data_entry_foreign_servers.sql
  psql -d $2 -h $8 -U postgres -c "Select alter_data_entry_foreign_servers('$8', '$1', '$7');"
}

alter_final_foreign_servers(){
  alter_foreign_servers $FF_NEW_DB_NAME $DATA_ENTRY_DB_NAME $ADMIN_DB_NAME $DATAWAREHOUSE_DB_NAME $FRONT_END_DB_NAME $REPORT_DATA_DB_NAME $SERVER_POSTGRES_PASSWORD $HOST
}

alter_clone_foreign_servers(){
  alter_foreign_servers "${PREFIX}_${FF_NEW}" "${PREFIX}_${DATA_ENTRY}" "${PREFIX}_${ADMIN}" "${PREFIX}_${DATAWAREHOUSE}" "${PREFIX}_${FRONT_END}" "${PREFIX}_${REPORT_DATA}" $SERVER_POSTGRES_PASSWORD $HOST
}

rebuild_temp_test_enviroment(){
  build_temp_etl  
  build_temp_non_etl
  load_scripts_on_temp
}

build_temp_etl(){

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Downloading latest changes from data-warehouse-storeprocedures repository"
  cd ../../
  cd data-warehouse-storeprocedures/
  git pull origin master

  delete_temp_dbs

  create_and_load_etl_dbs

  cd ../
  cd data-warehouse-storeprocedures-tests/Load

  alter_temp_foreign_servers

}

build_temp_non_etl(){
  cd ../
  mkdir dump
  create_and_load_ff_new_data_entry
  cd Load/
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
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming datawarehouse"
  kill_session $TEMP_DATAWAREHOUSE_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $DATAWAREHOUSE_DB_NAME
  
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming front end"
  kill_session $TEMP_FRONT_END_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $FRONT_END_DB_NAME

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming report data"
  kill_session $TEMP_REPORT_DATA_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $REPORT_DATA_DB_NAME

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming admin"
  kill_session $TEMP_ADMIN_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $ADMIN_DB_NAME

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming data entry"
  kill_session $TEMP_DATA_ENTRY_DB_NAME
  rename_db $TEMP_FF_NEW_DB_NAME $DATA_ENTRY_DB_NAME

  echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming ff new"
  kill_session $TEMP_FF_NEW_DB_NAME
  rename_db $DATAWAREHOUSE_DB_NAME $FF_NEW_DB_NAME

  alter_final_foreign_servers
}

clone_from_qa(){
  delete_clone_dbs

  cd ..
  mkdir $DUMP_FOLDER_PATH

  for db_name in $db_names
  do
    PREFIX_DB_NAME="${PREFIX}_${db_name}"
    echo_msg_with_timestamp "  - AUTOMATED_ETL: Dumping script for: $PREFIX_DB_NAME"
    SCRIPT_PATH="${DUMP_FOLDER_PATH}/${PREFIX_DB_NAME}.sql"
    pg_dump "${QA_DB_PREFIX}_${db_name}" -h $QA_DB_HOST -U postgres -p 5432 > $SCRIPT_PATH
    
    echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating database from script for ${PREFIX_DB_NAME}"
    create_and_load_db $PREFIX_DB_NAME $SCRIPT_PATH
  done

  cd Load/
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Altering foreign servers for cloned dbs"
  alter_clone_foreign_servers
}

get_params(){
  # First set of params
  get_param_option $2 $3
  # Second set of params
  get_param_option $4 $5
  # Third set of params
  get_param_option $6 $7
}

get_param_option(){
  case ${1} in
       -h) HOST="${2}"
          ;; 
       -p) SERVER_POSTGRES_PASSWORD="${2}"
          ;;
       -x) PREFIX="${2}"
          ;;
       *)
        echo_msg_with_timestamp "  - AUTOMATED_ETL: ERROR Missing parameters or wrong parameter names "
        usage_msg
        ;;
  esac
}

echo_msg_with_timestamp() {
  date +"%R $*"
}

usage_msg(){
  echo -e "\nUsage: \n"
  echo -e "  `basename ${0}` create_pg_pass"
  echo -e "  `basename ${0}` [rebuild_temp_test_enviroment] | [switch] | [delete_temp_dbs] -h host -p postgres_password"
  echo -e "  `basename ${0}` clone_from_qa -h host -p postgres_password -x prefix_db_name \n"
  echo "  [create_pg_pass] : Run ONLY ONCE to setup the conection string and avoid being prompted for passwords"
  echo "  [rebuild_temp_test_enviroment] -h host -p postgres_password : Build all ETL and non ETL scripts in temporary dbs, alters foreign servers and loads testing scripts"
  echo "  [switch] -h host -p postgres_password : Deletes currents dbs and makes temporary dbs the new dbs, alters foreign servers"
  echo "  [delete_temp_dbs] -h host -p postgres_password : Deletes temporary dbs"
  echo -e "  [clone_from_qa] -h host -p postgres_password -x prefix_db_name : Clones dbs from QA Enviroment into the passed argumets, prefix defaults to sandbox \n"
  exit 1 # Command to come out of the program with status 1
}

  case "$1" in
    "create_pg_pass") echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating pg pass file "
        create_pg_pass
        echo_msg_with_timestamp "  - AUTOMATED_ETL: PG Pass file created "
     ;;
    "rebuild_temp_test_enviroment") echo_msg_with_timestamp "  - AUTOMATED_ETL: Rebuilding temporary enviroments of ETL dbs "
        get_params $1 $2 $3 $4 $5
        rebuild_temp_test_enviroment
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Temporary dbs rebuild completed "
     ;;
     "switch")  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting existing db enviroments and renaming temporary dbs "
        get_params $1 $2 $3 $4 $5
        switch_db
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Switch process completed "
     ;;
     "delete_temp_dbs") echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting temporary dbs "
        get_params $1 $2 $3 $4 $5
        delete_temp_dbs
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleted all temporary dbs "
     ;;
     "clone_from_qa") echo_msg_with_timestamp "  - AUTOMATED_ETL: Cloning QA dbs "
        get_params $1 $2 $3 $4 $5 ${6:-"-x"} ${7:-$DEFAULT_PREFIX}
        clone_from_qa
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Cloned all dbs "
     ;;
    *)
      usage_msg
      ;;
  esac

exit 0