CREATE OR REPLACE FUNCTION restrictions_test_027_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1 INTEGER;
admin_report_1 INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
expected_source_comments_output VARCHAR;

BEGIN

--RETRIEVE PROVIDER ID
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;


--RETRIVE REPORT ID
SELECT  crr.report_id INTO admin_report_1 FROM criteria_restriction_reports crr WHERE crr.report_name='report_1';

SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;

expected_source_comments_output = '';

SELECT res_rpt_provider_source_comments_validate_data(admin_report_1, provider_1, commercial_plan_type_id, expected_source_comments_output);


success:=true;
return success;
END
$$ LANGUAGE plpgsql;