CREATE OR REPLACE FUNCTION ana_calculate_report_row_as_json(selection_query varchar, function_name VARCHAR, param_ids INTEGER[], where_query VARCHAR)
RETURNS varchar AS $$
DECLARE
actual_value varchar;

BEGIN

EXECUTE 'SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT '  || selection_query || ' FROM ' || ana_get_report_name_call(function_name, param_ids) || ' WHERE ' || where_query || ' LIMIT 1) t' INTO actual_value;

return actual_value;

END
$$ LANGUAGE plpgsql;