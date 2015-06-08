﻿CREATE OR REPLACE FUNCTION validatehealthplansdata()-- FRONT END
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
FE_HEALTH_PLANS_COUNT INTEGER;-- FE  SCHEMA HEALTH PLANS COUNT
DW_HEALTH_PLANS_COUNT INTEGER;-- DW SCHEMA HEALTH PLANS COUNT 
DW_FE_MERGED_HEALTH_PLANS_COUNT INTEGER;-- FE DW SCHEMAS MERGED HEALTH PLANS COUNT

BEGIN
--COUNT HEALTH PLANS IN DW SCHEMA
SELECT COUNT(*) INTO DW_HEALTH_PLANS_COUNT FROM dw.health_plans_import  dwhp;

--COUNT HEALTH PLANS IN FE SCHEMA
SELECT COUNT(*) INTO FE_HEALTH_PLANS_COUNT FROM health_plans fehp;

--IF FE AND DW SCHEMAS HAVE EQUAL COUNTS
IF DW_HEALTH_PLANS_COUNT = FE_HEALTH_PLANS_COUNT THEN
	SELECT COUNT(*) INTO DW_FE_MERGED_HEALTH_PLANS_COUNT FROM dw.health_plans_import dwhp JOIN health_plans fehp ON dwhp.id=fehp.id AND dwhp.health_plan_type_id = fehp.health_plan_type_id and dwhp.name=fehp.name and dwhp.formulary_url = fehp.formulary_url and dwhp.formulary_id = fehp.formulary_id and ffhp.provider_id = fehp.provider_id and ffhp.qualifier_url = fehp.qualifier_url;
	--VALIDATE IF FF AND FE SCHEMAS HAVE THE SAME RECORDS
	IF DW_HEALTH_PLANS_COUNT = DW_FE_MERGED_HEALTH_PLANS_COUNT THEN
		SUCCESS :=TRUE;
	ELSE
		RAISE EXCEPTION 'DW AND FE SCHEMAS CONTAINS DIFFERENT HEALTHPLANS';
		SUCCESS:=FALSE; 	
	END IF;
END IF;

RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;