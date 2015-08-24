CREATE OR REPLACE FUNCTION common_create_client_custom_criteria_group(new_report_client_id INTEGER, new_custom_criteria_group_id INTEGER, new_display_order_id INTEGER, new_active BOOLEAN) --ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
  success BOOLEAN DEFAULT false;
  valueExists BOOLEAN;
BEGIN

SELECT EXISTS (SELECT 1 FROM client_custom_criteria_groups c WHERE c.report_client_id=new_report_client_id AND c.custom_criteria_group_id= new_custom_criteria_group_id and c.display_order = new_display_order_id and c.is_active=new_active) INTO valueExists;
IF valueExists IS FALSE THEN
    INSERT INTO public.client_custom_criteria_groups(report_client_id, custom_criteria_group_id, display_order, is_active)
     VALUES (new_report_client_id, new_custom_criteria_group_id, new_display_order_id, new_active);
END IF;

success :=TRUE;
RETURN success;
END
$$ LANGUAGE plpgsql;