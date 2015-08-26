CREATE OR REPLACE FUNCTION restrictions_test_015_validate_test_data() --ADMIN
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
SELECT i.id INTO indication_1 FROM indications i WHERE i.name='indication_1';
SELECT i.id INTO indication_2 FROM indications i WHERE i.name='indication_2';
SELECT i.id INTO indication_3 FROM indications i WHERE i.name='indication_3';
SELECT i.id INTO indication_4 FROM indications i WHERE i.name='indication_4';

--RETRIEVE DRUGS
SELECT d.id INTO drug_1 FROM drugs d WHERE d.name='drug_1';
SELECT d.id INTO drug_2 FROM drugs d WHERE d.name='drug_2';
SELECT d.id INTO drug_3 FROM drugs d WHERE d.name='drug_3';
SELECT d.id INTO drug_4 FROM drugs d WHERE d.name='drug_4';
SELECT d.id INTO drug_5 FROM drugs d WHERE d.name='drug_5';
SELECT d.id INTO drug_6 FROM drugs d WHERE d.name='drug_6';
SELECT d.id INTO drug_7 FROM drugs d WHERE d.name='drug_7';
SELECT d.id INTO drug_8 FROM drugs d WHERE d.name='drug_8';
SELECT d.id INTO drug_9 FROM drugs d WHERE d.name='drug_9';

--RETRIEVE DRUG CLASSES
SELECT dc.id INTO drug_class_1 FROM drug_classes dc WHERE dc.name='drug_class_1';
SELECT dc.id INTO drug_class_2 FROM drug_classes dc WHERE dc.name='drug_class_2';
SELECT dc.id INTO drug_class_3 FROM drug_classes dc WHERE dc.name='drug_class_3';
SELECT dc.id INTO drug_class_4 FROM drug_classes dc WHERE dc.name='drug_class_4';
SELECT dc.id INTO drug_class_5 FROM drug_classes dc WHERE dc.name='drug_class_5';

---------------------VALIDATE EXPECTED CLIENTS

SELECT c.id INTO client_1 FROM clients c WHERE c.name='client_1';
IF client_1 IS NULL THEN
    SELECT throw_error('CLIENT 1 DOES NOT EXISTS');
END IF;

SELECT c.id INTO client_2 FROM clients c WHERE c.name='client_2';
IF client_2 IS NULL THEN
    SELECT throw_error('CLIENT 2 DOES NOT EXISTS');
END IF;

SELECT c.id INTO client_3 FROM clients c WHERE c.name='client_3';
IF client_3 IS NULL THEN
    SELECT throw_error('CLIENT 3 DOES NOT EXISTS');
END IF;

SELECT c.id INTO client_4 FROM clients c WHERE c.name='client_4';
IF client_4 IS NULL THEN
    SELECT throw_error('CLIENT 4 DOES NOT EXISTS');
END IF;


---------------------VALIDATE EXPECTED REPORTS
SELECT cr.report_id INTO report_1 FROM criteria_restriction_reports cr WHERE cr.report_name='report_1' AND cr.business_id='report_1';
IF report_1 IS NULL THEN
    SELECT throw_error('REPORT 1 DOES NOT EXISTS');
END IF;

SELECT cr.report_id INTO report_2 FROM criteria_restriction_reports cr WHERE cr.report_name='report_2' AND cr.business_id='report_2';
IF report_2 IS NOT NULL THEN
    SELECT throw_error('REPORT 2 SHOULD NOT EXISTS');
END IF;

SELECT cr.report_id INTO report_3 FROM criteria_restriction_reports cr WHERE cr.report_name='report_3' AND cr.business_id='report_3';
IF report_3 IS NULL THEN
    SELECT throw_error('REPORT 3 DOES NOT EXISTS');
END IF;

SELECT cr.report_id INTO report_4 FROM criteria_restriction_reports cr WHERE cr.report_name='report_4' AND cr.business_id='report_4';
IF report_4 IS NULL THEN
    SELECT throw_error('REPORT 4 DOES NOT EXISTS');
END IF;





--------------------- VALIDATE REPORT DRUGS
--REPORT#1
SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_1 AND rd.indication_id=indication_1 AND rd.drug_id=drug_1 AND RD.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_1||' indication:'||indication_1||' drug:'||drug_1||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_1 AND rd.indication_id=indication_1 AND rd.drug_id=drug_2 AND RD.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_1||' indication:'||indication_1||' drug:'||drug_2||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_1 AND rd.indication_id=indication_1 AND rd.drug_id=drug_3 AND RD.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_1||' indication:'||indication_1||' drug:'||drug_3||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_1 AND rd.indication_id=indication_1 AND rd.drug_id=drug_4 AND RD.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_1||' indication:'||indication_1||' drug:'||drug_4||' drug class:'||drug_class_1||' does not exists');
END IF;




--REPORT#2 --REPORT 2 DOES NOT EXISTS SO WE CAN'T KNOW THE REPORT ID EVEN IF THE DRUGS ARE ASSOCIATED THE REPORT ID IS UNKNOWN
--SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_2 AND rd.indication_id=indication_2 AND rd.drug_id=drug_5 AND rd.drug_class_id=drug_class_2) INTO valueExists;
--RAISE NOTICE 'report:% , indication:% , drug: %, drug_class:%',report_2,indication_2,drug_5,drug_class_2;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('report:'||report_2||' indication:'||indication_2||' drug:'||drug_5||' drug class:'||drug_class_2||' does not exists');
--END IF;
--
--SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_2 AND rd.indication_id=indication_2 AND rd.drug_id=drug_6 AND rd.drug_class_id=drug_class_2) INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('report:'||report_2||' indication:'||indication_2||' drug:'||drug_6||' drug class:'||drug_class_2||' does not exists');
--END IF;
--
--SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_2 AND rd.indication_id=indication_2 AND rd.drug_id=drug_7 AND rd.drug_class_id=drug_class_2) INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('report:'||report_2||' indication:'||indication_2||' drug:'||drug_7||' drug class:'||drug_class_2||' does not exists');
--END IF;




--REPORT#3
SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_3 AND rd.indication_id=indication_1 AND rd.drug_id=drug_1 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_3||' indication:'||indication_1||' drug:'||drug_1||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_3 AND rd.indication_id=indication_3 AND rd.drug_id=drug_1 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_3||' indication:'||indication_3||' drug:'||drug_1||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_3 AND rd.indication_id=indication_3 AND rd.drug_id=drug_2 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_3||' indication:'||indication_3||' drug:'||drug_2||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_3 AND rd.indication_id=indication_1 AND rd.drug_id=drug_2 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_3||' indication:'||indication_1||' drug:'||drug_2||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_3 AND rd.indication_id=indication_1 AND rd.drug_id=drug_3 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_3||' indication:'||indication_1||' drug:'||drug_3||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_3 AND rd.indication_id=indication_3 AND rd.drug_id=drug_9 AND rd.drug_class_id=drug_class_3) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_3||' indication:'||indication_3||' drug:'||drug_9||' drug class:'||drug_class_3||' does not exists');
END IF;




--REPORT#4
SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_4 AND rd.indication_id=indication_1 AND rd.drug_id=drug_1 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_4||' indication:'||indication_1||' drug:'||drug_1||' drug class:'||drug_class_1||' does not exists');
END IF;

SELECT EXISTS (SELECT 1 FROM report_drug rd WHERE rd.report_id=report_4 AND rd.indication_id=indication_1 AND rd.drug_id=drug_2 AND rd.drug_class_id=drug_class_1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('report:'||report_4||' indication:'||indication_1||' drug:'||drug_2||' drug class:'||drug_class_1||' does not exists');
END IF;






--------------------- VALIDATE REPORT CRITERIAS
--REPORT#1
SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Age' AND crs.criteria_restriction_name='criteria_age_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;

IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

--STEPS CRITERIAS
SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='Single' AND crs.criteria_restriction_name='Single' AND crs.dim_criterion_type_id=4 AND crs.view_type_id=2) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=3 AND crs.restriction_name='Single' AND crs.criteria_restriction_name='Single' AND crs.dim_criterion_type_id=4 AND crs.view_type_id=2) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=6 AND crs.restriction_name='Single' AND crs.criteria_restriction_name='Single' AND crs.dim_criterion_type_id=4 AND crs.view_type_id=2) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=3 AND crs.restriction_name='Double' AND crs.criteria_restriction_name='Double' AND crs.dim_criterion_type_id=4 AND crs.view_type_id=2) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=6 AND crs.restriction_name='Double' AND crs.criteria_restriction_name='Double' AND crs.dim_criterion_type_id=4 AND crs.view_type_id=2) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Medical' AND crs.dim_restriction_type_id=2 AND crs.restriction_name='Single' AND crs.criteria_restriction_name='Single' AND crs.dim_criterion_type_id=4 AND crs.view_type_id=2) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;
-- ATOMIC CRITERIAS
SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=3 AND crs.restriction_name='ST - Double' AND crs.criteria_restriction_name='custom_option_1 AND  custom_option_2' AND crs.dim_criterion_type_id=2 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Medical' AND crs.dim_restriction_type_id=2 AND crs.restriction_name='Unspecified' AND crs.criteria_restriction_name='Criteria Unspecified' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Medical' AND crs.dim_restriction_type_id=2 AND crs.restriction_name='ST - Single' AND crs.criteria_restriction_name='custom_option_2' AND crs.dim_criterion_type_id=2 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Clinical' AND crs.criteria_restriction_name='criteria_clinical_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Diagnosis' AND crs.criteria_restriction_name='criteria_diagnosis_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Diagnosis' AND crs.criteria_restriction_name='criteria_diagnosis_3' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=4 AND crs.restriction_name='QL' AND crs.criteria_restriction_name='criteria_ql_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Unspecified' AND crs.criteria_restriction_name='Criteria Unspecified' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA/ST - Single' AND crs.criteria_restriction_name='custom_option_1' AND crs.dim_criterion_type_id=2 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=3 AND crs.restriction_name='ST - Single' AND crs.criteria_restriction_name='custom_option_1' AND crs.dim_criterion_type_id=2 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA/ST - Single' AND crs.criteria_restriction_name='Fail any one: custom_option_1, custom_option_2' AND crs.dim_criterion_type_id=2 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

--SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_1 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Medical' AND crs.dim_restriction_type_id=2 AND crs.restriction_name='Age' AND crs.criteria_restriction_name='criteria_age_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CRITERIA');
--END IF;

--REPORT#2 SHOULD NOT CONTAINS ANY RESTRICTION
SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_2) INTO valueExists;
IF valueExists IS TRUE THEN
    SELECT throw_error('REPORT 2 SHOULD NOT CONTAINS CRITERIAS');
END IF;




--REPORT#3
SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_3 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Age' AND crs.criteria_restriction_name='criteria_age_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_3 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Clinical' AND crs.criteria_restriction_name='criteria_clinical_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_3 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Unspecified' AND crs.criteria_restriction_name='Criteria Unspecified' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_3 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=4 AND crs.restriction_name='QL' AND crs.criteria_restriction_name='criteria_ql_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

--SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_3 AND crs.indication_id=indication_3 AND crs.indication_name='Ind3' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Labs' AND crs.criteria_restriction_name='criteria_lab_3' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CRITERIA');
--END IF;

--SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_3 AND crs.indication_id=indication_3 AND crs.indication_name='Ind3' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Clinical' AND crs.criteria_restriction_name='criteria_clinical_3' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CRITERIA');
--END IF;




--REPORT#4
SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_4 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Medical' AND crs.dim_restriction_type_id=2 AND crs.restriction_name='Unspecified' AND crs.criteria_restriction_name='Criteria Unspecified' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_4 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Diagnosis' AND crs.criteria_restriction_name='criteria_diagnosis_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_4 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=4 AND crs.restriction_name='QL' AND crs.criteria_restriction_name='criteria_ql_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_4 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Unspecified' AND crs.criteria_restriction_name='Criteria Unspecified' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_4 AND crs.indication_id=indication_1 AND crs.indication_name='Ind1' AND crs.benefit_name='Pharmacy' AND crs.dim_restriction_type_id=1 AND crs.restriction_name='PA - Clinical' AND crs.criteria_restriction_name='criteria_clinical_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CRITERIA');
END IF;

--SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection crs WHERE crs.report_id = report_4 AND crs.indication_id=indication_1 AND crs.indication_name='indication_1' AND crs.benefit_name='Medical' AND crs.dim_restriction_type_id=2 AND crs.restriction_name='Age' AND crs.criteria_restriction_name='criteria_age_1' AND crs.dim_criterion_type_id=1 AND crs.view_type_id=1) INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CRITERIA');
--END IF;






---------------------  VALIDATE  REPORT CUSTOM GROUPS
--REPORT #1
SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_2 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_1' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_1') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_1'|| ' client: '|| client_2);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_1' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_1') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_1'|| ' client: '|| client_1);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_2' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_2') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_2'|| ' client: '|| client_1);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_2 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_3' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_3') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_3'|| ' client: '|| client_2);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_single' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_single') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_single'|| ' client: '|| client_1);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_all' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_all') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_all'|| ' client: '|| client_1);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_both' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_both') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_both'|| ' client: '|| client_1);
END IF;

SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_1 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_1_group_steps' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_1_group_steps') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_1_group_steps'|| ' client: '|| client_1);
END IF;



--REPORT #3
--SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_3 AND ccs.client_id=client_1 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='criteria_lab_3' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='criteria_lab_3') INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'criteria_lab_3'|| ' client: '|| client_1);
--END IF;

--SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_3 AND ccs.client_id=client_3 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='criteria_clinical_3' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='criteria_clinical_3') INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'criteria_clinical_3'|| ' client: '|| client_3);
--END IF;

--SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_3 AND ccs.client_id=client_1 AND ccs.indication_id=indication_3 AND ccs.indication_name='indication_3' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='criteria_lab_3' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='criteria_lab_3') INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'criteria_lab_3'|| ' client: '|| client_1);
--END IF;

--SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_3 AND ccs.client_id=client_3 AND ccs.indication_id=indication_3 AND ccs.indication_name='indication_3' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='criteria_clinical_3' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='criteria_clinical_3') INTO valueExists;
--IF valueExists IS FALSE THEN
--    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'criteria_clinical_3'|| ' client: '|| client_3);
--END IF;



--REPORT #4
SELECT EXISTS( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.report_id=report_4 AND ccs.client_id=client_4 AND ccs.indication_id=indication_1 AND ccs.indication_name='indication_1' AND ccs.benefit_name='Pharmacy' AND ccs.dim_restriction_type_id=6 AND ccs.criteria_restriction_name='rep_4_group_1' AND ccs.dim_criterion_type_id=3 AND ccs.restriction_name='rep_4_group_1') INTO valueExists;
IF valueExists IS FALSE THEN
    SELECT throw_error('MISSING REPORT CUSTOM GROUP '|| 'rep_4_group_1'|| ' client: '|| client_4);
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;