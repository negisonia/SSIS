CREATE OR REPLACE FUNCTION restrictions_test_011_validate_test_data() --ADMIN
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN


--VALIDATE STEP RESTRICTIONS
    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
               and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=2 and cr.restriction_name='ST - Single'
               and cr.criteria_restriction_name='ST - Single - custom_option_2' and cr.criteria_restriction_short_name='custom_option_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
        SELECT throw_error('Criteria Restriction ST - Single - custom_option_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
               and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=2 and cr.restriction_name='PA/ST - Single'
               and cr.criteria_restriction_name='PA/ST - Single - custom_option_1' and cr.criteria_restriction_short_name='custom_option_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
        SELECT throw_error('Criteria Restriction PA/ST - Single - custom_option_1 is missing');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
            and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=2 and cr.restriction_name='PA/ST - Single'
            and cr.criteria_restriction_name='PA/ST - Single - Fail any one: custom_option_1, custom_option_2' and cr.criteria_restriction_short_name='Fail any one: custom_option_1, custom_option_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
        SELECT throw_error('Criteria Restriction PA/ST - Single - Fail any one: custom_option_1, custom_option_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=3 and cr.dim_criterion_type_id=2 and cr.restriction_name='ST - Double'
                  and cr.criteria_restriction_name='ST - Double - custom_option_1 AND  custom_option_2' and cr.criteria_restriction_short_name='custom_option_1 AND  custom_option_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction ST - Double - custom_option_1 AND  custom_option_2 is missing');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=3 and cr.dim_criterion_type_id=2 and cr.restriction_name='ST - Single'
                  and cr.criteria_restriction_name='ST - Single - custom_option_1' and cr.criteria_restriction_short_name='custom_option_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction ST - Single - custom_option_1 is missing');
    END IF;

    --VALIDATE ATOMIC CRITERIA RESTRICTIONS
    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Unspecified'
                  and cr.criteria_restriction_name='Unspecified - Criteria Unspecified' and cr.criteria_restriction_short_name='Criteria Unspecified' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Unspecified - Criteria Unspecified is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Unspecified'
                  and cr.criteria_restriction_name='PA - Unspecified - Criteria Unspecified' and cr.criteria_restriction_short_name='Criteria Unspecified' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Unspecified - Criteria Unspecified is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Age'
                  and cr.criteria_restriction_name='Age - criteria_age_1' and cr.criteria_restriction_short_name='criteria_age_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Age - criteria_age_1 is missing');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Diagnosis'
                  and cr.criteria_restriction_name='Diagnosis - criteria_diagnosis_3' and cr.criteria_restriction_short_name='criteria_diagnosis_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Diagnosis - criteria_diagnosis_3 is missing');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Age'
                  and cr.criteria_restriction_name='PA - Age - criteria_age_1' and cr.criteria_restriction_short_name='criteria_age_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Age - criteria_age_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Clinical'
                  and cr.criteria_restriction_name='PA - Clinical - criteria_clinical_1' and cr.criteria_restriction_short_name='criteria_clinical_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Clinical - criteria_clinical_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Diagnosis'
                  and cr.criteria_restriction_name='PA - Diagnosis - criteria_diagnosis_1' and cr.criteria_restriction_short_name='criteria_diagnosis_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Diagnosis - criteria_diagnosis_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Diagnosis'
                  and cr.criteria_restriction_name='PA - Diagnosis - criteria_diagnosis_3' and cr.criteria_restriction_short_name='criteria_diagnosis_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Diagnosis - criteria_diagnosis_3 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=4 and cr.dim_criterion_type_id=1 and cr.restriction_name='QL'
                  and cr.criteria_restriction_name='QL - criteria_ql_1' and cr.criteria_restriction_short_name='criteria_ql_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction QL - criteria_ql_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Age'
                  and cr.criteria_restriction_name='Age - criteria_age_1' and cr.criteria_restriction_short_name='criteria_age_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Age - criteria_age_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Clinical'
                  and cr.criteria_restriction_name='Clinical - criteria_clinical_2' and cr.criteria_restriction_short_name='criteria_clinical_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Clinical - criteria_clinical_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Clinical'
                  and cr.criteria_restriction_name='Clinical - criteria_clinical_3' and cr.criteria_restriction_short_name='criteria_clinical_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Clinical - criteria_clinical_3 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Exclusion'
                  and cr.criteria_restriction_name='Exclusion - criteria_exclusion_1' and cr.criteria_restriction_short_name='criteria_exclusion_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Exclusion - criteria_exclusion_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Labs'
                  and cr.criteria_restriction_name='Labs - criteria_lab_1' and cr.criteria_restriction_short_name='criteria_lab_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Labs - criteria_lab_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Age'
                  and cr.criteria_restriction_name='PA - Age - criteria_age_1' and cr.criteria_restriction_short_name='criteria_age_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Age - criteria_age_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Clinical'
                  and cr.criteria_restriction_name='PA - Clinical - criteria_clinical_3' and cr.criteria_restriction_short_name='criteria_clinical_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Clinical - criteria_clinical_3 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Exclusion'
                  and cr.criteria_restriction_name='PA - Exclusion - criteria_exclusion_1' and cr.criteria_restriction_short_name='criteria_exclusion_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Exclusion - criteria_exclusion_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Labs'
                  and cr.criteria_restriction_name='PA - Labs - criteria_lab_1' and cr.criteria_restriction_short_name='criteria_lab_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Labs - criteria_lab_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=4 and cr.dim_criterion_type_id=1 and cr.restriction_name='QL'
                  and cr.criteria_restriction_name='QL - criteria_ql_1' and cr.criteria_restriction_short_name='criteria_ql_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction QL - criteria_ql_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Clinical'
                  and cr.criteria_restriction_name='Clinical - criteria_clinical_3' and cr.criteria_restriction_short_name='criteria_clinical_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Clinical - criteria_clinical_3 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Labs'
                  and cr.criteria_restriction_name='Labs - criteria_lab_3' and cr.criteria_restriction_short_name='criteria_lab_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Labs - criteria_lab_3 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Clinical'
                  and cr.criteria_restriction_name='PA - Clinical - criteria_clinical_3' and cr.criteria_restriction_short_name='criteria_clinical_3' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Clinical - criteria_clinical_3 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Diagnosis'
                  and cr.criteria_restriction_name='PA - Diagnosis - criteria_diagnosis_1' and cr.criteria_restriction_short_name='criteria_diagnosis_1' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Diagnosis - criteria_diagnosis_1 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Diagnosis'
                  and cr.criteria_restriction_name='Diagnosis - criteria_diagnosis_2' and cr.criteria_restriction_short_name='criteria_diagnosis_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Diagnosis - criteria_diagnosis_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Diagnosis'
                  and cr.criteria_restriction_name='PA - Diagnosis - criteria_diagnosis_2' and cr.criteria_restriction_short_name='criteria_diagnosis_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Diagnosis - criteria_diagnosis_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Diagnosis'
                  and cr.criteria_restriction_name='Diagnosis - criteria_diagnosis_2' and cr.criteria_restriction_short_name='criteria_diagnosis_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Diagnosis - criteria_diagnosis_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Diagnosis'
                  and cr.criteria_restriction_name='PA - Diagnosis - criteria_diagnosis_2' and cr.criteria_restriction_short_name='criteria_diagnosis_2' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Diagnosis - criteria_diagnosis_2 is missing');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Medical' and cr.dim_restriction_type_id=2 and cr.dim_criterion_type_id=1 and cr.restriction_name='Unspecified'
                  and cr.criteria_restriction_name='Unspecified - Criteria Unspecified' and cr.criteria_restriction_short_name='Criteria Unspecified' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction Unspecified - Criteria Unspecified is missing');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind1'
                  and cr.benefit_name='Pharmacy' and cr.dim_restriction_type_id=1 and cr.dim_criterion_type_id=1 and cr.restriction_name='PA - Unspecified'
                  and cr.criteria_restriction_name='PA - Unspecified - Criteria Unspecified' and cr.criteria_restriction_short_name='Criteria Unspecified' and is_active=true) INTO valueExists;
    IF valueExists IS FALSE THEN
       SELECT throw_error('Criteria Restriction PA - Unspecified - Criteria Unspecified is missing');
    END IF;


    --VALIDATE INACTIVE CRITERIAS DOES NOT EXISTS
    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                  and cr.benefit_name='Medical' and cr.criteria_restriction_short_name='criteria_lab_2') INTO valueExists;
    IF valueExists IS TRUE THEN
       SELECT throw_error('Criteria Restriction criteria_lab_2 Should not exists');
    END IF;


    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind2'
                and cr.benefit_name='Pharmacy' and cr.criteria_restriction_short_name='criteria_lab_2') INTO valueExists;
    IF valueExists IS TRUE THEN
     SELECT throw_error('Criteria Restriction criteria_lab_2 Should not exists');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                and cr.benefit_name='Medical' and cr.criteria_restriction_short_name='criteria_lab_2') INTO valueExists;
    IF valueExists IS TRUE THEN
     SELECT throw_error('Criteria Restriction criteria_lab_2 Should not exists');
    END IF;

    SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr. indication_name='Ind3'
                and cr.benefit_name='Pharmacy' and cr.criteria_restriction_short_name='criteria_lab_2') INTO valueExists;
    IF valueExists IS TRUE THEN
     SELECT throw_error('Criteria Restriction criteria_lab_2 Should not exists');
    END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;