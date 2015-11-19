CREATE OR REPLACE FUNCTION alter_report_data_foreign_servers(host_name varchar, temp_data_warehouse_db_name varchar, temp_front_end_db_name varchar, postgres_password varchar) --Report Data
RETURNS void AS $$
DECLARE
  
BEGIN

  EXECUTE 'alter server foreign_data_warehouse options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_data_warehouse options (set dbname ''' || temp_data_warehouse_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_data_warehouse OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

  EXECUTE 'alter server foreign_front_end options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_front_end options (set dbname ''' ||  temp_front_end_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_front_end OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';

END
$$ LANGUAGE plpgsql;
