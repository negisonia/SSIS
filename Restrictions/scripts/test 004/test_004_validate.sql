CREATE OR REPLACE FUNCTION restrictions_test_004_validate_test_data() --DATA WAREHOUSE
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  jcode1 INTEGER DEFAULT NULL;
  jcode2 INTEGER DEFAULT NULL;
  
  
  textValue VARCHAR;
  drug_names VARCHAR[] := ARRAY['restrictions_drug_1','restrictions_drug_2','restrictions_drug_3','restrictions_drug_4','restrictions_drug_5','restrictions_drug_6','restrictions_drug_7','restrictions_drug_8','restrictions_drug_9','restrictions_drug_10','restrictions_drug_11']; 
  intValue INTEGER DEFAULT NULL;
  intValue2 INTEGER DEFAULT NULL;
BEGIN

--VALIDATE JCODES
SELECT j.id INTO jcode1 FROM ff.jcodes j WHERE j.name='J9678' LIMIT 1;
SELECT j.id INTO jcode2 FROM ff.jcodes j WHERE j.name='J675' LIMIT 1;

--VALIDATE JCODE1
IF jcode1 IS NULL THEN
	SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING JCODE J9678');
END IF;

--VALIDATE JCODE2
IF jcode2 IS NULL THEN
	SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING JCODE J675');
END IF;


--VALIDATE DRUGS
FOREACH textValue IN ARRAY drug_names
LOOP
		--IF DRUG #2 VALIDATE DRUG JCODE
		IF textValue = 'restrictions_drug_2' THEN			
			SELECT d.id INTO intValue FROM ff.drugs d where d.name=textValue and d.is_active IS TRUE;			
			IF intValue IS NULL THEN
				SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING DRUG '|| textValue);	
			ELSE
				--VERIFY DRUG JCODE
				SELECT djc.id INTO intValue2 FROM ff.drugs_jcodes djc WHERE djc.drug_id=intValue and djc.jcode_id=jcode1;				
				IF intValue2 IS NULL THEN
					SELECT throw_error('MISSING JCODE DRUG ASSOCIATION');
				END IF;
			END IF;

		--IF DRUG #6 VALIDATE DRUG JCODE
		ELSIF textValue = 'restrictions_drug_6' THEN
			SELECT d.id INTO intValue FROM ff.drugs d where d.name=textValue and d.is_active IS TRUE;			
			IF intValue IS NULL THEN
				SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING DRUG '|| textValue);	
			ELSE
				--VERIFY DRUG JCODE
				SELECT djc.id INTO intValue2 FROM ff.drugs_jcodes djc WHERE djc.drug_id=intValue and djc.jcode_id=jcode2;				
				IF intValue2 IS NULL THEN
					SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING JCODE DRUG ASSOCIATION');
				END IF;
			END IF;
		--VALIDATE DRUG
		ELSE
			IF textValue = 'restrictions_drug_10' THEN				
				SELECT d.id INTO intValue FROM ff.drugs d where d.name=textValue and d.is_active IS TRUE;				
				IF intValue IS NOT NULL THEN
					SELECT throw_error('restrictions_test_003_validate_test_data ERROR: DRUG  SHOULD NOT EXISTS'|| textValue);	
				END IF;
			ELSIF textValue = 'restrictions_drug_11' THEN				
				SELECT d.id INTO intValue FROM ff.drugs d where d.name=textValue and d.is_active IS TRUE;				
				IF intValue IS NOT NULL THEN
					SELECT throw_error('restrictions_test_003_validate_test_data ERROR: DRUG  SHOULD NOT EXISTS'|| textValue);	
				END IF;
			ELSE				
				SELECT d.id INTO intValue FROM ff.drugs d where d.name=textValue and d.is_active IS TRUE;				
				IF intValue IS NULL THEN
					SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING DRUG '|| textValue);			
				END IF;
			END IF;			
			
		END IF;
	
END LOOP;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;