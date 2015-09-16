CREATE OR REPLACE FUNCTION alter_data_entry_foreign_servers(host_name varchar, temp_ff_new_db_name varchar, postgres_password varchar)
RETURNS void AS $$
DECLARE
  
BEGIN

  EXECUTE 'alter server foreign_ff_new options (set host ''' || host_name || ''')';
  EXECUTE 'alter server foreign_ff_new options (set dbname ''' || temp_ff_new_db_name || ''')';
  EXECUTE 'alter USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (set user ''postgres'', set password ''' || postgres_password || ''')';  

END
$$ LANGUAGE plpgsql;
