CREATE OR REPLACE FUNCTION alter_admin_foreign_servers(host_name varchar, temp_data_warehouse_db_name varchar, temp_ff_new_db_name varchar, postgres_password varchar) --Admin
RETURNS void AS $$
DECLARE
  
BEGIN

  EXECUTE 'alter server foreign_data_warehouse options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_data_warehouse options (set dbname ''' || temp_data_warehouse_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_data_warehouse OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

  EXECUTE 'alter server foreign_ff_new options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_ff_new options (set dbname ''' || temp_ff_new_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';  

END
$$ LANGUAGE plpgsql;
