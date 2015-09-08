CREATE OR REPLACE FUNCTION test_data_hli_medical_benefit_lives() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

provider VARCHAR:='provider';
hli_medical_benefit_designs VARCHAR:='hli_medical_benefit_designs';
BEGIN

    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(hli_medical_benefit_designs,'Commercial PPO Fully Insured'),common_get_county_id_by_name_and_state('Middlesex','Massachusetts'), common_get_table_id_by_name(provider,'provider_1'),100);
    PERFORM common_create_hli_medical_benefit_lives(common_get_table_id_by_name(hli_medical_benefit_designs,'Commercial PPO Self-Insured'),common_get_county_id_by_name_and_state('Middlesex','Connecticut'),common_get_table_id_by_name(provider,'provider_1'),100);

success=true;
return success;
END
$$ LANGUAGE plpgsql;