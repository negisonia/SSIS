CREATE OR REPLACE FUNCTION res_validate_report_drug(expected_report_id INTEGER, expected_indication_id INTEGER, expected_drug_id INTEGER, expected_drug_class_id INTEGER) --FRONT END DB
RETURNS BOOLEAN AS $$
DECLARE
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=expected_report_id AND rd.indication_id=expected_indication_id AND rd.drug_id=expected_drug_id AND rd.drug_class_id=expected_drug_class_id) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error(format('report:%s indication:%s drug: %s drug class: %s does not exists',expected_report_id, expected_indication_id,expected_drug_id,expected_drug_class_id));
END IF;

return TRUE;
END
$$ LANGUAGE plpgsql;