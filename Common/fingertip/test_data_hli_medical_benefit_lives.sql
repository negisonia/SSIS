CREATE OR REPLACE FUNCTION test_data_hli_medical_benefit_lives() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

provider VARCHAR:='provider';

BEGIN

    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(provider,'provider_1'),100);
    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(provider,'provider_2'),100);
    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(provider,'provider_6'),100);
    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(provider,'provider_7'),100);
    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(provider,'provider_9'),100);
    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(provider,'provider_10'),100);

success=true;
return success;
END
$$ LANGUAGE plpgsql;