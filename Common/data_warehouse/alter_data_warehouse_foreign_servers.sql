CREATE OR REPLACE FUNCTION alter_datawarehouse_foreign_servers(host_name varchar, temp_ff_new_db_name varchar, temp_data_entry_db_name varchar, temp_admin_db_name varchar, postgres_password varchar) --Data Warehouse
RETURNS void AS $$
DECLARE
  
BEGIN

  EXECUTE 'alter server foreign_ff_new options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_ff_new options (set dbname ''' || temp_ff_new_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

  EXECUTE 'alter server foreign_data_entry options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_data_entry options (set dbname ''' ||  temp_data_entry_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_data_entry OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

  EXECUTE 'alter server foreign_admin options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_admin options (set dbname ''' || temp_admin_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_admin OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

  EXECUTE 'alter server foreign_ff_new_historical options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_ff_new_historical options (set dbname ''' || temp_admin_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_ff_new_historical OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

END
$$ LANGUAGE plpgsql;
