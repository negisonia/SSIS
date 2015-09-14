CREATE OR REPLACE FUNCTION res_validate_criteria_restriction(expected_report_id INTEGER, expected_indication_id INTEGER, expected_indication_name VARCHAR, expected_benefit_name VARCHAR, expected_restriction_type INTEGER, expected_restriction_name VARCHAR, expected_criteria_restriction_name VARCHAR, expected_criterion_type INTEGER, expected_view_type INTEGER) --ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = expected_report_id AND crs.indication_id=expected_indication_id AND crs.indication_name=expected_indication_name AND crs.benefit_name=expected_benefit_name AND crs.dim_restriction_type_id=expected_restriction_type AND crs.restriction_name=expected_restriction_name AND crs.criteria_restriction_name=expected_criteria_restriction_name AND crs.dim_criterion_type_id=expected_criterion_type AND crs.view_type_id=expected_view_type) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

return TRUE;
END
$$ LANGUAGE plpgsql;