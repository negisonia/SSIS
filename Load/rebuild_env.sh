HOST=localhost
SANDBOX_DATAWAREHOUSE_DB_NAME=sandbox_datawarehouse_tmp

SANDBOX_DATAWAREHOUSE_SCRIPT_PATH=data_warehouse/r20_data_warehouse.sql

create_and_load_db()
{
  createdb -h $HOST -U postgres -W $1
  psql -d $1 -h $HOST -U postgres -W < $2
}

echo "  - REBUILD_ENV: Downloading latest changes from data-warehouse-storeprocedures repo"
cd ../../
cd data-warehouse-storeprocedures/
git pull origin master

echo "  - REBUILD_ENV: Creating Sandbox database"
create_and_load_db $SANDBOX_DATAWAREHOUSE_DB_NAME $SANDBOX_DATAWAREHOUSE_SCRIPT_PATH


exit 0