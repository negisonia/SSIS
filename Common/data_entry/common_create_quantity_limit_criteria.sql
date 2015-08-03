CREATE OR REPLACE FUNCTION common_create_quantity_limit_criteria(new_quantity_limit_id INTEGER, new_criteria_id INTEGER, active BOOLEAN) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM quantity_limit_criteria qlc WHERE qlc.is_active=active  and qlc.quantity_limit_id=new_quantity_limit_id and qlc.criterium_id=new_criteria_id  LIMIT 1) INTO valueExists;

--VALIDATE IF THE QUANTITY LIMIT CRITERIA ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT QUANTITY LIMIT CRITERIA RECORD
INSERT INTO quantity_limit_criteria(
             created_at, updated_at, criterium_id, quantity_limit_id,
            active, amount_val, time_val, amount_type, time_type, is_active,
            copiedfromid)
    VALUES (current_timestamp, current_timestamp, new_criteria_id, new_quantity_limit_id,
            active,null, null, null, null,active,
            null);

END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
