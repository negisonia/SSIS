CREATE OR REPLACE FUNCTION common_create_quantity_limits(new_data_entry_id INTEGER, active BOOLEAN) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
quantity_limit_id INTEGER DEFAULT NULL;
BEGIN

SELECT ql.id INTO quantity_limit_id FROM quantity_limits ql WHERE  ql.data_entry_id=new_data_entry_id and ql.is_active=active LIMIT 1;

--VALIDATE IF THE QUANTITY LIMITS ALREADY EXISTS
IF quantity_limit_id IS NULL THEN
  --INSERT  QUANTITY LIMITS RECORD
  INSERT INTO quantity_limits(created_at, updated_at, data_entry_id, drug_id, indication_id,provider_id, healthplantype_id, is_active, copiedfromid)
  VALUES (current_timestamp, current_timestamp, new_data_entry_id, NULL, NULL,NULL, NULL, active, NULL) RETURNING id INTO quantity_limit_id;
  RETURN quantity_limit_id;
ELSE
  RETURN quantity_limit_id;
END IF;

END
$$ LANGUAGE plpgsql;
