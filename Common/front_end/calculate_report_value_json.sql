CREATE OR REPLACE FUNCTION calculate_report_value_json(selection_query boolean, from_query VARCHAR, where_query VARCHAR)--ANALYTICS FRONT END
RETURNS varchar AS $$
DECLARE

actual_value varchar;

BEGIN

EXECUTE 'SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT '  || selection_query || ' FROM ' || from_query || ' WHERE ' || where_query || ' LIMIT 1) t' INTO actual_value;

return actual_value;

END
$$ LANGUAGE plpgsql;