﻿CREATE OR REPLACE FUNCTION common_create_health_plan_type(input_id integer, is_active BOOLEAN, type_name VARCHAR, is_commercial BOOLEAN, is_medicare BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
health_plan_type_id INTEGER DEFAULT NULL;
BEGIN

SELECT hpt.id INTO health_plan_type_id FROM healthplantype hpt WHERE hpt.isactive=is_active and hpt.name= type_name LIMIT 1;

--VALIDATE IF THE HEALTH PLAN TYPE DOESNT EXISTS
IF health_plan_type_id IS NULL THEN		
	--INSERT  HEALTH PLAN TYPE RECORD
	INSERT INTO healthplantype(id, isactive, name, webname, explanationtext, iscommercial, ismedicare, health_plan_type_group_id, health_plan_type_aggregate_id)
	VALUES (input_id, CASE when is_active IS NULL THEN TRUE ELSE is_active END, type_name, type_name, NULL, CASE when is_commercial IS NULL THEN FALSE ELSE is_commercial END, CASE when is_medicare IS NULL THEN FALSE ELSE is_medicare END, NULL, NULL) RETURNING id INTO health_plan_type_id;

	RETURN health_plan_type_id;
ELSE
	RETURN health_plan_type_id;
END IF;
END
$$ LANGUAGE plpgsql;

