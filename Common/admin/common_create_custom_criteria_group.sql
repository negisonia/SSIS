CREATE OR REPLACE FUNCTION common_create_custom_criteria_group(new_group_name VARCHAR, new_indication_field_name VARCHAR) --ADMIN DB
RETURNS INTEGER AS $$
DECLARE
  success BOOLEAN DEFAULT false;
  custom_criteria_group_id INTEGER DEFAULT NULL;
BEGIN

INSERT INTO custom_criteria_groups(name, indication_field_name, is_multi_indication, created_by,updated_by, created_at, updated_at)
VALUES (new_group_name, new_indication_field_name, TRUE, 1, 1, current_timestamp, current_timestamp) RETURNING id INTO ;

END
$$ LANGUAGE plpgsql;