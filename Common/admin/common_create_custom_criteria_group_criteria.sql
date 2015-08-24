CREATE OR REPLACE FUNCTION common_create_custom_criteria_group_criterias(new_custom_criteria_group_id INTEGER, new_criteria_restriction_id INTEGER) --ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
  success BOOLEAN DEFAULT FALSE;
  valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS(SELECT 1 FROM custom_criteria_group_criterias cc WHERE cc.custom_criteria_group_id=new_custom_criteria_group_id AND cc.criteria_restriction_id=new_criteria_restriction_id) INTO valueExists;
IF valueExists IS FALSE THEN
    INSERT INTO public.custom_criteria_group_criterias(custom_criteria_group_id, criteria_restriction_id)
    VALUES (new_custom_criteria_group_id, new_criteria_restriction_id);
END IF;

success:=TRUE;
RETURN success;

END
$$ LANGUAGE plpgsql;