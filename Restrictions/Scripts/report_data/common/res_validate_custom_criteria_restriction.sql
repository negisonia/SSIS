CREATE OR REPLACE FUNCTION res_validate_custom_criteria_restriction(expected_report_id INTEGER, expected_client_id INTEGER, expected_indication_id INTEGER, expected_indication_name VARCHAR, expected_benefit_name VARCHAR, expected_dim_restriction_type INTEGER, expected_criteria_restriction_name VARCHAR, expected_dim_criterion_type_id INTEGER, expected_restriction_name VARCHAR) --FRONT END
RETURNS BOOLEAN AS $$
DECLARE
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=expected_report_id AND ccs.client_id=expected_client_id AND ccs.indication_id=expected_indication_id AND ccs.indication_name=expected_indication_name AND ccs.benefit_name=expected_benefit_name AND ccs.dim_restriction_type_id=expected_dim_restriction_type AND ccs.criteria_restriction_name=expected_criteria_restriction_name AND ccs.dim_criterion_type_id=expected_dim_criterion_type_id AND ccs.restriction_name=expected_restriction_name) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP ');
END IF;

return TRUE;
END
$$ LANGUAGE plpgsql;