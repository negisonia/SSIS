﻿CREATE OR REPLACE FUNCTION common_create_parent(parent_name VARCHAR,is_active BOOLEAN, last_update timestamp without time zone , last_update_user_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
parentId INTEGER DEFAULT NULL;
BEGIN

SELECT p.id INTO parentId FROM parents p WHERE p.name= parent_name LIMIT 1;

--VALIDATE IF THE PARENT ALREADY EXISTS
IF parentId IS NULL THEN
	IF parent_name = NULL THEN
		select throw_error('common_create_parent: PARENT NAME IS REQUIRED');
	END IF;
	

	--INSERT PARENT RECORD
	INSERT INTO parents(name, isactive, lastupdate, lastupdateffuserid)
	VALUES ( parent_name, CASE when is_active IS NULL THEN TRUE ELSE is_active END, CASE when last_update IS NULL THEN current_timestamp ELSE last_update END, CASE when last_update_user_id IS NULL THEN 0 ELSE last_update_user_id END) RETURNING id INTO parentId;
	RETURN parentId;
ELSE
	RETURN parentId;
END IF;
END
$$ LANGUAGE plpgsql;

