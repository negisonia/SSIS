CREATE OR REPLACE FUNCTION restrictions_test_009_validate_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_1' and di.indication_name='restrictions_indication_1' and di.indication_abbr='Ind1' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_indication_1 AND  DRUG restrictions_drug_1 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_1' and di.indication_name='restrictions_indication_3' and di.indication_abbr='Ind3' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_indication_1 AND  DRUG restrictions_indication_3 ASSOCIATION IS MISSING');
END IF;


SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_2' and di.indication_name='restrictions_indication_1' and di.indication_abbr='Ind1' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_2 AND  DRUG restrictions_indication_1 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_2' and di.indication_name='restrictions_indication_3' and di.indication_abbr='Ind3' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_2 AND  DRUG restrictions_indication_3 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_3' and di.indication_name='restrictions_indication_1' and di.indication_abbr='Ind1' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_3 AND  DRUG restrictions_indication_1 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_4' and di.indication_name='restrictions_indication_1' and di.indication_abbr='Ind1' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_4 AND  DRUG restrictions_indication_1 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_5' and di.indication_name='restrictions_indication_2' and di.indication_abbr='Ind2' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_5 AND  DRUG restrictions_indication_2 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_6' and di.indication_name='restrictions_indication_2' and di.indication_abbr='Ind2' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_6 AND  DRUG restrictions_indication_2 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_7' and di.indication_name='restrictions_indication_2' and di.indication_abbr='Ind2' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_7 AND  DRUG restrictions_indication_2 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.drug_name='restrictions_drug_9' and di.indication_name='restrictions_indication_3' and di.indication_abbr='Ind3' ) INTO valueExists;
IF valueExists IS FALSE THEN
  SELECT throw_error('INDICATION restrictions_drug_9 AND  DRUG restrictions_indication_3 ASSOCIATION IS MISSING');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.indication_name='restrictions_indication_4' and di.indication_abbr='Ind4' ) INTO valueExists;
IF valueExists IS TRUE THEN
  SELECT throw_error('INDICATION DRUG ASSOCIATION SHOULD NOT EXISTS');
END IF;

SELECT EXISTS(SELECT 1 FROM drug_indications di WHERE di.indication_name='restrictions_indication_5' and di.indication_abbr='Ind5' ) INTO valueExists;
IF valueExists IS TRUE THEN
  SELECT throw_error('INDICATION DRUG ASSOCIATION SHOULD NOT EXISTS');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;