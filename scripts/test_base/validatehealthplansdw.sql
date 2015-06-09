﻿CREATE OR REPLACE FUNCTION validatehealthplansdata()-- DATA WAREHOUSE
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
FF_HEALTH_PLANS_COUNT INTEGER;-- FF SOURCE DATA HEALTH PLANS COUNT
FE_HEALTH_PLANS_COUNT INTEGER;-- FE SCHEMA HEALTH PLANS COUNT 
DW_FF_HEALTH_PLANS_COUNT INTEGER;-- HEALTHPLANS MATERIALIZED VIEW HEALTH PLANS COUNT 
FF_FE_MERGED_HEALTH_PLANS_COUNT INTEGER;-- FE FF SOURCE DATA MERGED HEALTH PLANS COUNT
FF_DW_MERGED_HEALTH_PLANS_COUNT INTEGER;-- HEALTHPLANS MATERIALIZED VIEW AND FF SOURCE DATA MERGED HEALTH PLANS COUNT
BEGIN
--COUNT HEALTH PLANS IN FF SOURCE DATABASE
SELECT COUNT(*) INTO FF_HEALTH_PLANS_COUNT FROM ff.health_plans_import  hpi WHERE hpi.is_active=TRUE;

--COUNT HEALTH PLANS IN FE SCHEMA
SELECT COUNT(*) INTO FE_HEALTH_PLANS_COUNT FROM fe.health_plans fehp;

--COUNT HEALTH PLANS IN HEALTHPLANS MATERIALIZED VIEW
SELECT COUNT(*) INTO DW_FF_HEALTH_PLANS_COUNT FROM ff.health_plans hp;

--IF FE SCHEMA AND FF SOURCE DATA HAVE EQUAL COUNTS
IF FF_HEALTH_PLANS_COUNT = FE_HEALTH_PLANS_COUNT THEN
	SELECT COUNT(*) INTO FF_FE_MERGED_HEALTH_PLANS_COUNT FROM ff.health_plans_import ffhp JOIN fe.health_plans fehp ON ffhp.id=fehp.id AND ffhp.health_plan_type_id = fehp.health_plan_type_id and ffhp.name=fehp.name and ffhp.formulary_url = fehp.formulary_url and ffhp.formulary_id = fehp.formulary_id and ffhp.provider_id = fehp.provider_id and ffhp.qualifier_url = fehp.qualifier_url;
	--VALIDATE IF FF SOURCE DATA AND FE SCHEMAS HAVE THE SAME RECORDS
	IF FF_HEALTH_PLANS_COUNT = FF_FE_MERGED_HEALTH_PLANS_COUNT THEN
		SUCCESS :=TRUE;
	ELSE
		RAISE EXCEPTION 'FF AND FE SCHEMAS CONTAINS DIFFERENT HEALTHPLANS';
		SUCCESS:=FALSE; 	
	END IF;
ELSE
	RAISE EXCEPTION 'FF AND FE SCHEMAS CONTAINS DIFFERENT HEALTHPLANS';
	SUCCESS:=FALSE; 
END IF;

--IF FF SOURCE DATA AND HEALTHPLANS MATERIALIZED VIEW HAVE EQUAL COUNTS
IF FF_HEALTH_PLANS_COUNT = DW_FF_HEALTH_PLANS_COUNT THEN
	SELECT COUNT(*) INTO FF_DW_MERGED_HEALTH_PLANS_COUNT FROM ff.health_plans_import ffhp JOIN ff.health_plans hp ON ffhp.id=hp.id AND ffhp.health_plan_type_id = hp.health_plan_type_id and ffhp.name=hp.name and ffhp.formulary_url = hp.formulary_url and ffhp.formulary_id = hp.formulary_id and ffhp.provider_id = hp.provider_id and ffhp.qualifier_url = hp.qualifier_url;
	--VALIDATE IF FF SOURCE DATA AND HEALTHPLANS MATERIALIZED VIEW HAVE THE SAME RECORDS
	IF FF_HEALTH_PLANS_COUNT = FF_DW_MERGED_HEALTH_PLANS_COUNT THEN
		SUCCESS :=TRUE;
	ELSE
		RAISE EXCEPTION 'FF AND DW SCHEMAS CONTAINS DIFFERENT HEALTHPLANS';
		SUCCESS:=FALSE; 	
	END IF;
ELSE
	RAISE EXCEPTION 'FF AND DW SCHEMAS CONTAINS DIFFERENT HEALTHPLANS';
	SUCCESS:=FALSE;
END IF;

RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;