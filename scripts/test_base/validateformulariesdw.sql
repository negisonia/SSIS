﻿CREATE OR REPLACE FUNCTION validateformularydata()
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
FF_FORMULARY_COUNT INTEGER;-- FF SOURCE DATA DRUGS COUNT
MVFORMULARY_COUNT INTEGER;-- FE SCHEMA DRUGS COUNT 
FF_MV_MERGED_FORMULARY_COUNT INTEGER;-- FE FF SOURCE DATA MERGED DRUGS COUNT
BEGIN
--COUNT FORMULARY IN FF SOURCE DATABASE
SELECT COUNT(*) INTO FF_FORMULARY_COUNT FROM ff.formulary_import  fi WHERE fi.isactive=TRUE;

--COUNT FORMULARY IN MATERIALIZED VIEW
SELECT COUNT(*) INTO MVFORMULARY_COUNT FROM ff.formulary ;


--IF SOURCE DATA END MATERIALIZED VIEW HAVE EQUAL COUNTS
IF FF_FORMULARY_COUNT = MVFORMULARY_COUNT THEN
	SELECT COUNT(*) INTO FF_MV_MERGED_FORMULARY_COUNT FROM ff.formulary_import fi JOIN ff.formulary f ON fi.id=f.id AND fi.isactive=TRUE AND fi.isactive=f.isactive AND fi.preferred_brand_tier_id=f.preferred_brand_tier_id;
	--VALIDATE IF FF SOURCE DATA AND FRONT END HEALTH PLANS MATERIALIZED VIEW HAVE THE SAME RECORDS
	IF FF_FORMULARY_COUNT = FF_MV_MERGED_FORMULARY_COUNT THEN
		SUCCESS :=TRUE;
	ELSE
		select throw_error('FF SOURCE DATA AND FORMULARY MATERIALIZED VIEW CONTAINS DIFFERENT FORMULARIES');
		SUCCESS:=FALSE; 	
	END IF;
ELSE
	select throw_error('FF SOURCE DATA AND FORMULARY MATERIALIZED VIEW CONTAINS DIFFERENT FORMULARIES');
	SUCCESS:=FALSE;
END IF;

RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;