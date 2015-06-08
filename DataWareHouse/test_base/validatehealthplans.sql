﻿CREATE OR REPLACE FUNCTION validatehealthplansdata()
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
FF_HEALTH_PLANS_COUNT INTEGER;-- FF  SCHEMA HEALTH PLANS COUNT
FE_HEALTH_PLANS_COUNT INTEGER;-- FE SCHEMA HEALTH PLANS COUNT 
FF_FE_MERGED_HEALTH_PLANS_COUNT INTEGER;-- FE FF SCHEMAS MERGED HEALTH PLANS COUNT
BEGIN
--COUNT HEALTH PLANS IN FF SCHEMA
SELECT COUNT(*) INTO FF_HEALTH_PLANS_COUNT FROM ff.health_plans_import  hpi WHERE hpi.is_active=TRUE;

--COUNT HEALTH PLANS IN FE SCHEMA
SELECT COUNT(*) INTO FE_HEALTH_PLANS_COUNT FROM fe.health_plans fehp;

--IF FE AND FF SCHEMAS HAVE EQUAL COUNTS
IF FF_HEALTH_PLANS_COUNT = FE_HEALTH_PLANS_COUNT THEN
	SELECT COUNT(*) INTO FF_FE_MERGED_HEALTH_PLANS_COUNT FROM ff.health_plans_import hpi JOIN fe.health_plans fehp ON hpi.id=fehp.id AND hpi.health_plan_type_id = fe.health_plan_type_id and hpi.name=fehp.name and hpi.formulary_url = fehp.formulary_url and hpi.formulary_id = fehp.formulary_id and hpi.provider_id = fehp.provider_id and hpi.qualifier_url = fehp.qualifier_url;
	--VALIDATE IF FF AND FE SCHEMAS HAVE THE SAME RECORDS
	IF FF_HEALTH_PLANS_COUNT = FF_FE_MERGED_HEALTH_PLANS_COUNT THEN
		SUCCESS :=TRUE;
	ELSE
		RAISE EXCEPTION 'FF AND FE SCHEMAS CONTAINS DIFFERENT HEALTHPLANS';
		SUCCESS:=FALSE; 	
	END IF;
END IF;

RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;