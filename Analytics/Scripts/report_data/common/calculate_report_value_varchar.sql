CREATE OR REPLACE FUNCTION calculate_report_value_varchar(selection_query VARCHAR, from_query VARCHAR, where_query VARCHAR)--ANALYTICS FRONT END
RETURNS varchar AS $$
DECLARE

actual_value varchar;

BEGIN

EXECUTE 'SELECT (' || selection_query || ' :: varchar) FROM '  || from_query || ' WHERE ' || where_query || ' LIMIT 1' INTO actual_value;

return actual_value;

END
$$ LANGUAGE plpgsql;