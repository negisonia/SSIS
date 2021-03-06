﻿CREATE OR REPLACE FUNCTION res_general_test_003_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  jcode1 INTEGER DEFAULT NULL;
  jcode2 INTEGER DEFAULT NULL;
  
  
  textValue VARCHAR;
  drug_names VARCHAR[] := ARRAY['drug_1','drug_2','drug_3','drug_4','drug_5','drug_6','drug_7','drug_8','drug_9','drug_10_inactive','drug_11_inactive'];
  intValue INTEGER DEFAULT NULL;
  intValue2 INTEGER DEFAULT NULL;
BEGIN

--VALIDATE JCODES
SELECT j.id INTO jcode1 FROM jcodes j WHERE j.name='J9678' LIMIT 1;
SELECT j.id INTO jcode2 FROM jcodes j WHERE j.name='J675' LIMIT 1;

--VALIDATE JCODE1
IF jcode1 IS NULL THEN
	SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING JCODE J9678');
END IF;

--VALIDATE JCODE2
IF jcode2 IS NULL THEN
	SELECT throw_error('restrictions_test_003 MISSING JCODE J675');
END IF;


--VALIDATE DRUGS
FOREACH textValue IN ARRAY drug_names
LOOP
		--IF DRUG #2 VALIDATE DRUG JCODE
		IF textValue = 'drug_2' THEN
			SELECT d.id INTO intValue FROM drugs d where d.name=textValue and d.is_active IS TRUE;			
			IF intValue IS NULL THEN
				SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING DRUG '|| textValue);	
			ELSE
				--VERIFY DRUG JCODE
				SELECT djc.id INTO intValue2 FROM drugs_jcodes djc WHERE djc.drug_id=intValue and djc.jcode_id=jcode1;				
				IF intValue2 IS NULL THEN
					SELECT throw_error('restrictions_test_003 MISSING JCODE DRUG ASSOCIATION');
				END IF;
			END IF;

		--IF DRUG #6 VALIDATE DRUG JCODE
		ELSIF textValue = 'drug_6' THEN
			SELECT d.id INTO intValue FROM drugs d where d.name=textValue and d.is_active IS TRUE;			
			IF intValue IS NULL THEN
				SELECT throw_error('restrictions_test_003_validate_test_data ERROR: MISSING DRUG '|| textValue);	
			ELSE
				--VERIFY DRUG JCODE
				SELECT djc.id INTO intValue2 FROM drugs_jcodes djc WHERE djc.drug_id=intValue and djc.jcode_id=jcode2;				
				IF intValue2 IS NULL THEN
					SELECT throw_error('restrictions_test_003 MISSING JCODE DRUG ASSOCIATION');
				END IF;
			END IF;
		--VALIDATE DRUG
		ELSE
			IF textValue = 'drug_10_inactive' THEN
				SELECT d.id INTO intValue FROM drugs d where d.name=textValue and d.is_active IS TRUE;				
				IF intValue IS NOT NULL THEN
					SELECT throw_error('restrictions_test_003_validate_test_data ERROR: DRUG  SHOULD NOT EXISTS'|| textValue);	
				END IF;
			ELSIF textValue = 'drug_11_inactive' THEN
				SELECT d.id INTO intValue FROM drugs d where d.name=textValue and d.is_active IS TRUE;				
				IF intValue IS NOT NULL THEN
					SELECT throw_error('restrictions_test_003_validate_test_data ERROR: DRUG  SHOULD NOT EXISTS'|| textValue);	
				END IF;
			ELSE				
				SELECT d.id INTO intValue FROM drugs d where d.name=textValue and d.is_active IS TRUE;				
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