CREATE OR REPLACE FUNCTION test_data_hli_medical_benefit_designs() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

BEGIN

    PERFORM common_create_hli_medical_benefit_designs(1,'Commercial HMO Fully Insured');
    PERFORM common_create_hli_medical_benefit_designs(2,'Commercial PPO Fully Insured');
    PERFORM common_create_hli_medical_benefit_designs(3,'Commercial POS Fully Insured');
    PERFORM common_create_hli_medical_benefit_designs(4,'Commercial HMO Self-Insured');
    PERFORM common_create_hli_medical_benefit_designs(5,'Commercial PPO Self-Insured');
    PERFORM common_create_hli_medical_benefit_designs(6,'Commercial POS Self-Insured');
    PERFORM common_create_hli_medical_benefit_designs(7,'Commercial Indemnity Fully Insured');
    PERFORM common_create_hli_medical_benefit_designs(8,'Commercial Indemnity Self-Insured');
    PERFORM common_create_hli_medical_benefit_designs(9,'Medicare');
    PERFORM common_create_hli_medical_benefit_designs(10,'Medicaid');

success=true;
return success;
END
$$ LANGUAGE plpgsql;