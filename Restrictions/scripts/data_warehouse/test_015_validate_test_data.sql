CREATE OR REPLACE FUNCTION restrictions_test_015_validate_test_data() --DATA WAREHOUSE
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;

client_1 INTEGER DEFAULT NULL;
client_2 INTEGER DEFAULT NULL;
client_3 INTEGER DEFAULT NULL;
client_4 INTEGER DEFAULT NULL;

report_1 INTEGER DEFAULT NULL;
report_2 INTEGER DEFAULT NULL;
report_3 INTEGER DEFAULT NULL;
report_4 INTEGER DEFAULT NULL;

indication_1 INTEGER;
indication_2 INTEGER;
indication_3 INTEGER;
indication_4 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;
drug_class_4 INTEGER;
drug_class_5 INTEGER;

BEGIN

--RETRIEVE INDICATIONS
SELECT i.id INTO indication_1 FROM fe.indications i WHERE i.name='indication_1';
SELECT i.id INTO indication_2 FROM fe.indications i WHERE i.name='indication_2';
SELECT i.id INTO indication_3 FROM fe.indications i WHERE i.name='indication_3';
SELECT i.id INTO indication_4 FROM fe.indications i WHERE i.name='indication_4';

--RETRIEVE DRUGS
SELECT d.id INTO drug_1 FROM fe.drugs d WHERE d.name='drug_1';
SELECT d.id INTO drug_2 FROM fe.drugs d WHERE d.name='drug_2';
SELECT d.id INTO drug_3 FROM fe.drugs d WHERE d.name='drug_3';
SELECT d.id INTO drug_4 FROM fe.drugs d WHERE d.name='drug_4';
SELECT d.id INTO drug_5 FROM fe.drugs d WHERE d.name='drug_5';
SELECT d.id INTO drug_6 FROM fe.drugs d WHERE d.name='drug_6';
SELECT d.id INTO drug_7 FROM fe.drugs d WHERE d.name='drug_7';
SELECT d.id INTO drug_8 FROM fe.drugs d WHERE d.name='drug_8';
SELECT d.id INTO drug_9 FROM fe.drugs d WHERE d.name='drug_9';

--RETRIEVE DRUG CLASSES
SELECT dc.id INTO drug_class_1 FROM fe.drug_classes dc WHERE dc.name='drug_class_1';
SELECT dc.id INTO drug_class_2 FROM fe.drug_classes dc WHERE dc.name='drug_class_2';
SELECT dc.id INTO drug_class_3 FROM fe.drug_classes dc WHERE dc.name='drug_class_3';
SELECT dc.id INTO drug_class_4 FROM fe.drug_classes dc WHERE dc.name='drug_class_4';
SELECT dc.id INTO drug_class_5 FROM fe.drug_classes dc WHERE dc.name='drug_class_5';

---------------------VALIDATE EXPECTED CLIENTS
SELECT c.id INTO client_1 FROM fe.clients c WHERE c.name='client_1';
IF client_1 IS NULL THEN
    SELECT throw_error('CLIENT 1 DOES NOT EXISTS');
END IF;

SELECT c.id INTO client_2 FROM fe.clients c WHERE c.name='client_2';
IF client_2 IS NULL THEN
    SELECT throw_error('CLIENT 2 DOES NOT EXISTS');
END IF;

SELECT c.id INTO client_3 FROM fe.clients c WHERE c.name='client_3';
IF client_3 IS NULL THEN
    SELECT throw_error('CLIENT 3 DOES NOT EXISTS');
END IF;

SELECT c.id INTO client_4 FROM fe.clients c WHERE c.name='client_4';
IF client_4 IS NULL THEN
    SELECT throw_error('CLIENT 4 DOES NOT EXISTS');
END IF;


---------------------VALIDATE EXPECTED REPORTS
SELECT cr.report_id INTO report_1 FROM fe.criteria_restriction_reports cr WHERE cr.report_name='report_1' AND cr.business_id='report_1';
IF report_1 IS NULL THEN
    SELECT throw_error('REPORT 1 DOES NOT EXISTS');
END IF;

SELECT cr.report_id INTO report_2 FROM fe.criteria_restriction_reports cr WHERE cr.report_name='report_2' AND cr.business_id='report_2';
IF report_2 IS NOT NULL THEN
    SELECT throw_error('REPORT 2 SHOULD NOT EXISTS');
END IF;

SELECT cr.report_id INTO report_3 FROM fe.criteria_restriction_reports cr WHERE cr.report_name='report_3' AND cr.business_id='report_3';
IF report_3 IS NULL THEN
    SELECT throw_error('REPORT 3 DOES NOT EXISTS');
END IF;

SELECT cr.report_id INTO report_4 FROM fe.criteria_restriction_reports cr WHERE cr.report_name='report_4' AND cr.business_id='report_4';
IF report_4 IS NULL THEN
    SELECT throw_error('REPORT 4 DOES NOT EXISTS');
END IF;

--------------------- VALIDATE REPORT DRUGS
--REPORT#1
PERFORM  res_validate_report_drug(report_1, indication_1, drug_1, drug_class_1);
PERFORM  res_validate_report_drug(report_1, indication_1, drug_2, drug_class_1);
PERFORM  res_validate_report_drug(report_1, indication_1, drug_3, drug_class_1);
PERFORM  res_validate_report_drug(report_1, indication_1, drug_4, drug_class_1);


--REPORT#2 --REPORT 2 DOES NOT EXISTS SO WE CAN'T KNOW THE REPORT ID EVEN IF THE DRUGS ARE ASSOCIATED THE REPORT ID IS UNKNOWN


--REPORT#4
PERFORM  res_validate_report_drug(report_4, indication_1, drug_1, drug_class_1);
PERFORM  res_validate_report_drug(report_4, indication_1, drug_2, drug_class_1);

--------------------- VALIDATE REPORT CRITERIAS
--REPORT#1
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Age', 'criteria_age_1', 1, 1);

--STEPS CRITERIAS
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'Single', 'Single', 4, 2);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 3, 'Single', 'Single', 4, 2);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 6, 'Single', 'Single', 4, 2);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 3, 'Double', 'Double', 4, 2);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 6, 'Double', 'Double', 4, 2);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Medical', 2, 'Single', 'Single', 4, 2);

-- ATOMIC CRITERIAS
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 3, 'ST - Double', 'custom_option_1 AND  custom_option_2', 2, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Medical', 2, 'Unspecified', 'Criteria Unspecified', 1, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Medical', 2, 'ST - Single', 'custom_option_2', 2, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Clinical', 'criteria_clinical_1', 1, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Diagnosis', 'criteria_diagnosis_1', 1, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Diagnosis', 'criteria_diagnosis_3', 1, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 4, 'QL', 'criteria_ql_1', 1, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Unspecified', 'Criteria Unspecified', 1, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA/ST - Single', 'custom_option_1', 2, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 3, 'ST - Single', 'custom_option_1', 2, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Pharmacy', 1, 'PA/ST - Single', 'Fail any one: custom_option_1, custom_option_2', 2, 1);
PERFORM res_validate_criteria_restriction(report_1, indication_1, 'indication_1', 'Medical', 2, 'Age', 'criteria_age_1', 1, 1);


--REPORT#2 SHOULD NOT CONTAINS ANY RESTRICTION
SELECT EXISTS (SELECT 1 FROM fe.criteria_restriction_selection crs WHERE crs.report_id = report_2) INTO valueExists;
IF valueExists IS TRUE THEN
    SELECT throw_error('REPORT 2 SHOULD NOT CONTAINS CRITERIAS');
END IF;



--REPORT#4
PERFORM res_validate_criteria_restriction(report_4, indication_1, 'indication_1', 'Medical', 2, 'Unspecified', 'Criteria Unspecified', 1, 1);
PERFORM res_validate_criteria_restriction(report_4, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Diagnosis', 'criteria_diagnosis_1', 1, 1);
PERFORM res_validate_criteria_restriction(report_4, indication_1, 'indication_1', 'Pharmacy', 4, 'QL', 'criteria_ql_1', 1, 1);
PERFORM res_validate_criteria_restriction(report_4, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Unspecified', 'Criteria Unspecified', 1, 1);
PERFORM res_validate_criteria_restriction(report_4, indication_1, 'indication_1', 'Pharmacy', 1, 'PA - Clinical', 'criteria_clinical_1', 1, 1);
PERFORM res_validate_criteria_restriction(report_4, indication_1, 'indication_1', 'Medical', 2, 'Age', 'criteria_age_1', 1, 1);


---------------------  VALIDATE  REPORT CUSTOM GROUPS
--REPORT #1
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Medical',2,'rep_1_group_both - Single',5,'rep_1_group_both');
PERFORM res_validate_custom_criteria_restriction(report_1,client_2,indication_1,'indication_1','Pharmacy',6,'rep_1_group_1',3,'rep_1_group_1');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_1',3,'rep_1_group_1');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_2',3,'rep_1_group_2');
PERFORM res_validate_custom_criteria_restriction(report_1,client_2,indication_1,'indication_1','Pharmacy',6,'rep_1_group_3',3,'rep_1_group_3');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_single',3,'rep_1_group_single');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_single - Single',5,'rep_1_group_single');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',3,'rep_1_group_single - Single',5,'rep_1_group_single');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',1,'rep_1_group_single - Single',5,'rep_1_group_single');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_all',3,'rep_1_group_all');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',3,'rep_1_group_all - Double',5,'rep_1_group_all');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_all - Double',5,'rep_1_group_all');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_all - Single',5,'rep_1_group_all');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',3,'rep_1_group_all - Single',5,'rep_1_group_all');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_both',3,'rep_1_group_both');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',1,'rep_1_group_both - Single',5,'rep_1_group_both');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_both - Single',5,'rep_1_group_both');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',3,'rep_1_group_both - Single',5,'rep_1_group_both');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Medical',2,'rep_1_group_both - Single',5,'rep_1_group_both');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_steps',3,'rep_1_group_steps');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_steps - Double',5,'rep_1_group_steps');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',3,'rep_1_group_steps - Double',5,'rep_1_group_steps');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',1,'rep_1_group_steps - Single',5,'rep_1_group_steps');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Pharmacy',6,'rep_1_group_steps - Single',5,'rep_1_group_steps');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Medical',2,'rep_1_group_all',3,'rep_1_group_all');
PERFORM res_validate_custom_criteria_restriction(report_1,client_1,indication_1,'indication_1','Medical',2,'rep_1_group_all - Single',5,'rep_1_group_all');


--REPORT #4
PERFORM res_validate_custom_criteria_restriction(report_4,client_4,indication_1,'indication_1','Pharmacy',6,'rep_4_group_1',3,'rep_4_group_1');


success=true;
return success;
END
$$ LANGUAGE plpgsql;