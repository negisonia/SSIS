CREATE OR REPLACE FUNCTION common_create_test_data_functions(function_name VARCHAR, function_order INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
function_id INTEGER DEFAULT NULL;
BEGIN
  
SELECT t.id INTO function_id FROM test_data_functions t WHERE t.name=function_name AND t.order_id=function_order LIMIT 1;

--VALIDATE IF FUNCTION ALREADY EXISTS
IF function_id IS NULL THEN
  --INSERT TIER RECORD
  INSERT INTO test_data_functions(name, order_id)
        VALUES (function_name, function_order) RETURNING id INTO function_id;
  RETURN function_id;
ELSE
  RETURN function_id;
END IF;

END
$$ LANGUAGE plpgsql;

