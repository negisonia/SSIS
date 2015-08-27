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
LOCAL_POSTGRES_PASSWORD=gap2012

# NOT CONFIGURABLE OPTIONS
# ---------------------
DATAWAREHOUSE_SCRIPT_PATH=data_warehouse/r20_data_warehouse.sql
FRONT_END_SCRIPT_PATH=front_end/front_end_db.sql
REPORT_DATA_SCRIPT_PATH=report_data/report_data_db.sql
ADMIN_SCRIPT_PATH=admin/r20_admin.sql
DATA_ENTRY_SCRIPT_PATH=dump/data_entry.sql
FF_NEW_SCRIPT_PATH=dump/ff_new.sql

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
  echo "  - REBUILD_ENV: Creating temp databases for datawarehouse, front end, report data and admin"
  create_and_load_db $TEMP_DATAWAREHOUSE_DB_NAME $DATAWAREHOUSE_SCRIPT_PATH
  create_and_load_db $TEMP_FRONT_END_DB_NAME $FRONT_END_SCRIPT_PATH
  create_and_load_db $TEMP_REPORT_DATA_DB_NAME $REPORT_DATA_SCRIPT_PATH
  create_and_load_db $TEMP_ADMIN_DB_NAME $ADMIN_SCRIPT_PATH  
}

create_and_load_ff_new_data_entry(){
  echo "  - REBUILD_ENV: Creating temp database for data entry"
  pg_dump -s restrictions20_data_entry -h rdwo3djw14v9sq.cayadjd1xwwj.us-east-1.rds.amazonaws.com -n public -U r2de -p 5432 -W > dump/data_entry.sql:
  create_and_load_db $TEMP_DATA_ENTRY_DB_NAME $DATA_ENTRY_SCRIPT_PATH

  echo "  - REBUILD_ENV: Creating temp database for ff new"
  pg_dump -s ff_new -h db01.fingertipformulary.com -n public -U restrictions20 -p 5432 -W > dump/ff_new.sql:
  create_and_load_db $TEMP_FF_NEW_DB_NAME $FF_NEW_SCRIPT_PATH  
}

load_scripts(){
  echo "  - REBUILD_ENV: Loading Admin scripts"

  psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres -W < Load/load_admin.sql

  echo "  - REBUILD_ENV: Loading Data Warehouse scripts"

  psql -d $DATAWAREHOUSE_DB_NAME -h $HOST -U postgres -W < Load/load_data_warehouse.sql

  echo "  - REBUILD_ENV: Loading FF New scripts"

  psql -d $TEMP_FF_NEW_DB_NAME -h $HOST -U postgres -W < Load/load_ff_new.sql

  echo "  - REBUILD_ENV: Loading Front End scripts"

  psql -d $TEMP_FRONT_END_DB_NAME -h $HOST -U postgres -W < Load/load_front_end.sql  
}

alter_foreign_servers(){
  echo "  - REBUILD_ENV: Alter foreign servers"

  echo "  - REBUILD_ENV: Alter Data-warehouse foreign servers"

  psql -d $TEMP_DATAWAREHOUSE_DB_NAME -h $HOST -U postgres <<EOF
  \x
    alter server foreign_ff_new options (set host $HOST);
    alter server foreign_ff_new options (set dbname $TEMP_FF_NEW_DB_NAME);
    alter USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (set user 'postgres', set password $LOCAL_POSTGRES_PASSWORD);

    alter server foreign_data_entry options (set host $HOST);
    alter server foreign_data_entry options (set dbname $TEMP_DATA_ENTRY_DB_NAME);
    alter USER MAPPING FOR postgres SERVER foreign_data_entry OPTIONS (set user 'postgres', set password $LOCAL_POSTGRES_PASSWORD);

    alter server foreign_admin options (set host $HOST);
    alter server foreign_admin options (set dbname $TEMP_ADMIN_DB_NAME);
    alter USER MAPPING FOR postgres SERVER foreign_admin OPTIONS (set user 'postgres', set password $LOCAL_POSTGRES_PASSWORD);  
  EOF

  echo "  - REBUILD_ENV: Alter Report Data foreign servers"

  psql -d $TEMP_REPORT_DATA_DB_NAME -h $HOST -U postgres <<EOF
  \x
    alter server foreign_data_warehouse options (set host $HOST);
    alter server foreign_data_warehouse options (set dbname $TEMP_DATAWAREHOUSE_DB_NAME);
    alter USER MAPPING FOR postgres SERVER foreign_data_warehouse OPTIONS (set user 'postgres', set password $LOCAL_POSTGRES_PASSWORD);

    alter server foreign_front_end options (set host $HOST);
    alter server foreign_front_end options (set dbname $TEMP_FRONT_END_DB_NAME);
    alter USER MAPPING FOR postgres SERVER foreign_front_end OPTIONS (set user 'postgres', set password $LOCAL_POSTGRES_PASSWORD);  
  EOF

  echo "  - REBUILD_ENV: Alter Admin foreign servers"

  psql -d $TEMP_ADMIN_DB_NAME -h $HOST -U postgres <<EOF
  \x
    alter server foreign_data_warehouse options (set host $HOST);
    alter server foreign_data_warehouse options (set dbname $TEMP_DATAWAREHOUSE_DB_NAME);
    alter USER MAPPING FOR postgres SERVER foreign_data_warehouse OPTIONS (set user 'postgres', set password $LOCAL_POSTGRES_PASSWORD);  
  EOF
}

build_temp(){

  echo "  - REBUILD_ENV: Downloading latest changes from data-warehouse-storeprocedures repo"
  cd ../../
  cd data-warehouse-storeprocedures/
  git pull origin master

  delete_temp

  create_and_load_etl_dbs

  cd ../../
  cd data-warehouse-storeprocedures-tests/

  create_and_load_ff_new_data_entry

  alter_foreign_servers

  load_scripts
}

switch_db(){

  delete_db $DATAWAREHOUSE_DB_NAME
  delete_db $FRONT_END_DB_NAME
  delete_db $REPORT_DATA_DB_NAME
  delete_db $ADMIN_DB_NAME

  echo "  - REBUILD_ENV: Renaming temporary dbs"
  psql -h $HOST -U postgres <<EOF
  \x
    ALTER DATABASE $TEMP_DATAWAREHOUSE_DB_NAME RENAME TO $DATAWAREHOUSE_DB_NAME;
    ALTER DATABASE $TEMP_FRONT_END_DB_NAME RENAME TO $FRONT_END_DB_NAME;
    ALTER DATABASE $TEMP_REPORT_DATA_DB_NAME RENAME TO $REPORT_DATA_DB_NAME;
    ALTER DATABASE $TEMP_ADMIN_DB_NAME RENAME TO $ADMIN_DB_NAME;
    ALTER DATABASE $TEMP_DATA_ENTRY_DB_NAME RENAME TO $DATA_ENTRY_DB_NAME;
    ALTER DATABASE $TEMP_FF_NEW_DB_NAME RENAME TO $FF_NEW_DB_NAME;
  EOF
}

if [ "$1" != "" && ("$1" == "build_temp" || "$1" == "switch" || "$1" == "delete_temp") ]; then

  if [ "$1" = "build_temp" ]
  then
      echo "  - REBUILD_ENV: Rebuilding temporary enviroments "
      build_temp
  elif [ "$1" = "switch" ]
  then
      echo "  - REBUILD_ENV: Deleting existing db enviroments and renaming temporary dbs "
      switch_db
  elif [ "$1" = "delete_temp" ]
      echo "  - REBUILD_ENV: Deleting temporary dbs "
      delete_temp
  fi
else
    echo "Missing parameter"
fi

exit 0