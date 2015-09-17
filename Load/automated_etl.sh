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

# Script paths
DATAWAREHOUSE_SCRIPT_PATH=data_warehouse/r20_data_warehouse.sql
FRONT_END_SCRIPT_PATH=front_end/front_end_db.sql
REPORT_DATA_SCRIPT_PATH=report_data/report_data_db.sql
ADMIN_SCRIPT_PATH=admin/r20_admin.sql
DATA_ENTRY_SCRIPT_PATH=dump/data_entry.sql
FF_NEW_SCRIPT_PATH=dump/ff_new.sql
DUMP_FOLDER_PATH=dump
LOAD_FOLDER_PATH=load

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
DATAWAREHOUSE=data_warehouse
DATA_ENTRY=data_entry
FF_NEW=ff_new
FRONT_END=front_end
REPORT_DATA=report_data
DB_NAMES="$ADMIN $DATAWAREHOUSE $FRONT_END $REPORT_DATA $DATA_ENTRY $FF_NEW"
DEFAULT_PREFIX=sandbox
TMP_PREFIX=tmp
OLD_PREFIX=old

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

  for db_name in $DB_NAMES
  do
    PREFIX_DB_NAME="${TMP_PREFIX}_${PREFIX}_${db_name}"

    echo_msg_with_timestamp "  - AUTOMATED_ETL: Killing open sessions and deleting: $PREFIX_DB_NAME"
    kill_session $PREFIX_DB_NAME
    delete_db $PREFIX_DB_NAME
  done
}

delete_old_final_dbs()
{
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting old final databases"

  for db_name in $DB_NAMES
  do
    delete_db "${OLD_PREFIX}_${PREFIX}_${db_name}"
  done
}

delete_clone_dbs()
{
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting clone databases if already created"

  for db_name in $DB_NAMES
  do
    PREFIX_DB_NAME="${PREFIX}_${db_name}"

    kill_session $PREFIX_DB_NAME
    delete_db $PREFIX_DB_NAME
  done
}

create_and_load_etl_dbs(){
  for db_name in $DB_NAMES
  do
    PREFIX_DB_NAME="${TMP_PREFIX}_${PREFIX}_${db_name}"

    if [ "$db_name" == "$DATAWAREHOUSE" ]
      then
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for datawarehouse"
      create_and_load_db $PREFIX_DB_NAME $DATAWAREHOUSE_SCRIPT_PATH
    elif [ "$db_name" == "$FRONT_END" ]
      then
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for front end"
      create_and_load_db $PREFIX_DB_NAME $FRONT_END_SCRIPT_PATH
    elif [ "$db_name" == "$REPORT_DATA" ]
      then
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for report data"
      create_and_load_db $PREFIX_DB_NAME $REPORT_DATA_SCRIPT_PATH
    elif [ "$db_name" = "$ADMIN" ]
      then
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for admin"
      create_and_load_db $PREFIX_DB_NAME $ADMIN_SCRIPT_PATH  
    fi
  done
}

create_and_load_ff_new_data_entry(){
  for db_name in $DB_NAMES
    do
    PREFIX_DB_NAME="${TMP_PREFIX}_${PREFIX}_${db_name}"

    if [ "$db_name" == "$DATA_ENTRY" ]
      then
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Dumping data entry"
      pg_dump -s $SOURCE_DATA_ENTRY_DB_NAME -h $DATA_ENTRY_DB_HOST -n public -U $DATA_ENTRY_DB_USER -p 5432 > $DATA_ENTRY_SCRIPT_PATH
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for data entry and loading script"
      create_and_load_db $PREFIX_DB_NAME $DATA_ENTRY_SCRIPT_PATH
    elif [ "$db_name" == "$FF_NEW" ]
      then
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Dumping ff new"
      pg_dump --exclude-table "DELETE*" -s ff_new -h $FF_NEW_DB_HOST -n public -U $FF_NEW_DB_USER -p 5432 -x > $FF_NEW_SCRIPT_PATH
      echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating temp database for ff new and loading script"
      create_and_load_db $PREFIX_DB_NAME $FF_NEW_SCRIPT_PATH
    fi
  done
}

load_scripts_on_temp(){

  cd ../
  for db_name in $DB_NAMES
    do
      # FRONT_END does not have scripts to be loaded
      if [ "$db_name" != "$FRONT_END" ]
        then
        PREFIX_DB_NAME="${TMP_PREFIX}_${PREFIX}_${db_name}"

        echo_msg_with_timestamp "  - AUTOMATED_ETL: Loading ${db_name} scripts"
        SCRIPT_PATH="${LOAD_FOLDER_PATH}/load_${db_name}.sql"
        psql -d $PREFIX_DB_NAME -h $HOST -U postgres < $SCRIPT_PATH
      fi
  done

  cd Load/
}

alter_temp_foreign_servers(){
  alter_foreign_servers "${TMP_PREFIX}_${PREFIX}_${FF_NEW}" "${TMP_PREFIX}_${PREFIX}_${DATA_ENTRY}" "${TMP_PREFIX}_${PREFIX}_${ADMIN}" "${TMP_PREFIX}_${PREFIX}_${DATAWAREHOUSE}" "${TMP_PREFIX}_${PREFIX}_${FRONT_END}" "${TMP_PREFIX}_${PREFIX}_${REPORT_DATA}"
}

alter_foreign_servers(){
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter foreign servers"

  for db_name in $DB_NAMES
    do
      if [ "$db_name" == "$DATAWAREHOUSE" ]
        then
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Data-warehouse foreign servers"
        psql -d $4 -h $HOST -U postgres < alter_data_warehouse_foreign_servers.sql
        psql -d $4 -h $HOST -U postgres -c "Select alter_datawarehouse_foreign_servers('$HOST', '$1', '$2', '$3', '$SERVER_POSTGRES_PASSWORD');"
      elif [ "$db_name" == "$REPORT_DATA" ]
        then
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Report Data foreign servers"
        psql -d $6 -h $HOST -U postgres < alter_report_data_foreign_servers.sql
        psql -d $6 -h $HOST -U postgres -c "Select alter_report_data_foreign_servers('$HOST', '$4', '$5', '$SERVER_POSTGRES_PASSWORD');"
      elif [ "$db_name" == "$ADMIN" ]
        then
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Admin foreign servers"
        psql -d $3 -h $HOST -U postgres < alter_admin_foreign_servers.sql
        psql -d $3 -h $HOST -U postgres -c "Select alter_admin_foreign_servers('$HOST', '$4', '$1', '$SERVER_POSTGRES_PASSWORD');"
      elif [ "$db_name" == "$DATA_ENTRY" ]
        then
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Alter Data Entry foreign servers"
        psql -d $2 -h $HOST -U postgres < alter_data_entry_foreign_servers.sql
        psql -d $2 -h $HOST -U postgres -c "Select alter_data_entry_foreign_servers('$HOST', '$1', '$SERVER_POSTGRES_PASSWORD');"
      fi
    done
}

alter_final_foreign_servers(){
  alter_foreign_servers "${PREFIX}_${FF_NEW}" "${PREFIX}_${DATA_ENTRY}" "${PREFIX}_${ADMIN}" "${PREFIX}_${DATAWAREHOUSE}" "${PREFIX}_${FRONT_END}" "${PREFIX}_${REPORT_DATA}"
}

alter_clone_foreign_servers(){
  alter_foreign_servers "${PREFIX}_${FF_NEW}" "${PREFIX}_${DATA_ENTRY}" "${PREFIX}_${ADMIN}" "${PREFIX}_${DATAWAREHOUSE}" "${PREFIX}_${FRONT_END}" "${PREFIX}_${REPORT_DATA}"
}

rebuild_temp_test_enviroment(){
  delete_temp_dbs
  build_temp_etl
  load_scripts_on_temp
  alter_temp_foreign_servers
  add_roles
}

add_roles(){
  psql -h $HOST -U postgres -c 'CREATE ROLE restrictions20 LOGIN;'
}

build_temp_etl(){

  cd ../../
  cd data-warehouse-storeprocedures/
  echo_msg_with_timestamp "  - AUTOMATED_ETL: Downloading latest changes from data-warehouse-storeprocedures repository"
  git pull origin master

  create_and_load_etl_dbs

  cd ../
  cd data-warehouse-storeprocedures-tests/

  mkdir dump
  create_and_load_ff_new_data_entry

  cd Load
}

kill_session(){
  psql -d $1 -h $HOST -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname = '$1'";
}

rename_db(){
  psql -d $1 -h $HOST -U postgres -c "ALTER DATABASE $2 RENAME TO $3"
}

switch_db(){
  BASE_CONECTION="postgres"

  # Rename current final dbs to be replaced by the temporary ones
  for db_name in $DB_NAMES
  do
    FINAL_DB_NAME="${PREFIX}_${db_name}"
    # Rename the temp db names to the final db names
    echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming ${FINAL_DB_NAME} TO ${OLD_PREFIX}_${FINAL_DB_NAME}"
    kill_session $FINAL_DB_NAME
    rename_db $BASE_CONECTION $FINAL_DB_NAME "${OLD_PREFIX}_${FINAL_DB_NAME}"
  done

  for db_name in $DB_NAMES
  do
    TMP_DB_NAME="${TMP_PREFIX}_${PREFIX}_${db_name}"
    FINAL_DB_NAME="${PREFIX}_${db_name}"
    # Rename the temp db names to the final db names
    echo_msg_with_timestamp "  - AUTOMATED_ETL: Renaming ${TMP_DB_NAME} to ${FINAL_DB_NAME}"
    kill_session $TMP_DB_NAME
    rename_db $BASE_CONECTION $TMP_DB_NAME $FINAL_DB_NAME
  done

  alter_final_foreign_servers
}

clone_from_qa(){
  delete_clone_dbs

  cd ..
  mkdir $DUMP_FOLDER_PATH

  for db_name in $DB_NAMES
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
  add_roles
}

get_params(){
  # First set of params
  get_param_option $2 $3
  # Second set of params
  get_param_option $4 $5
  # Third set of params
  get_param_option $6 $7
  # Fourth set of params
  get_param_option ${8:-"-l"} "${9:-$DB_NAMES}"
}

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

get_param_option(){
  case ${1} in
       -h) HOST="${2}"
          ;; 
       -p) SERVER_POSTGRES_PASSWORD="${2}"
          ;;
       -x) PREFIX="${2}"
          ;;
       -l)
        # Validata param db names exist
        for db_name in $2
        do
            if ! [[ " ${DB_NAMES[@]} " =~ " ${db_name} " ]]; then
              echo_msg_with_timestamp "  - AUTOMATED_ETL: ERROR Wrong database name: ${db_name}"
              exit 1
            fi
        done
        DB_NAMES="${2}"
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
  echo -e "  ./`basename ${0}` create_pg_pass -h host -p postgres_password"
  echo -e "  ./`basename ${0}` [reconstruct] | [switch] | [delete_old] | [clone_from_qa] -h host -p postgres_password -x prefix_db_name -l db_names_list \n"
  echo "  [create_pg_pass] : Run ONLY ONCE to setup the conection strings and avoid being prompted for passwords"
  echo "  [reconstruct] : Builds the temporary dbs, alters foreign servers and loads testing scripts"
  echo "  [switch] : Renames current final dbs to old_db_name and makes temporary dbs the new final dbs, alters foreign servers"
  echo "  [delete_old] : Deletes old dbs from switch command"
  echo -e "  [clone_from_qa] : Clones dbs from QA Enviroment \n"
  echo "  -h The db host name, ie: localhost"
  echo "  -p The db password for the postgres user of the passed host"
  echo "  -x A string with the prefix to be appended to the ETL db, ie: 'sandbox', will create a 'sandbox_data_warehouse' db"
  echo -e "  -l A list of space separated db names, defaults to: 'admin data_warehouse front_end report_data data_entry ff_new' \n"
  echo -e "  Note: Make sure 'Data-warehouse-storeprocedures' git repository lives next to this project (under the same parent directory) for this script to work \n"
  exit 1 # Command to come out of the program with status 1
}

  case "$1" in
    "create_pg_pass") echo_msg_with_timestamp "  - AUTOMATED_ETL: Creating pg pass file "
        # Get host
        get_param_option $2 $3
        # Get password
        get_param_option $4 "$5"
        create_pg_pass
        echo_msg_with_timestamp "  - AUTOMATED_ETL: PG Pass file created "
     ;;
    "reconstruct") echo_msg_with_timestamp "  - AUTOMATED_ETL: Reconstructing temporary enviroments of ETL dbs "
        get_params $1 $2 $3 $4 "$5" $6 $7 $8 "$9"
        rebuild_temp_test_enviroment
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Temporary dbs reconstruct completed "
     ;;
     "switch")  echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting existing db enviroments and renaming temporary dbs "
        get_params $1 $2 $3 $4 "$5" $6 $7 $8 "$9"
        switch_db
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Switch process completed "
     ;;
     "clone_from_qa") echo_msg_with_timestamp "  - AUTOMATED_ETL: Cloning QA dbs "
        get_params $1 $2 $3 $4 "$5" $6 $7 $8 "$9"
        clone_from_qa
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Cloned all dbs "
     ;;
     "delete_old") echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleting old final dbs "
        get_params $1 $2 $3 $4 "$5" $6 $7 $8 "$9"
        delete_old_final_dbs
        echo_msg_with_timestamp "  - AUTOMATED_ETL: Deleted all final dbs "
     ;;
    *)
      usage_msg
      ;;
  esac

exit 0