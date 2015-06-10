CREATE OR REPLACE FUNCTION test002validateformularydetails()
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
DW_FORMULARY_DETAILS_COUNT INTEGER;
DW_MERGED_FORMULARY_DETAILS_COUNT INTEGER;
BEGIN

SELECT COUNT(*) INTO DW_FORMULARY_DETAILS_COUNT FROM  ff.mv_active_formularies_import ffaf where ffaf.formulary_id > 0;
SELECT COUNT(*) INTO DW_ACTIVE_FORMULARIES_COUNT FROM ff.formulary_entry  fffe;

IF FF_ACTIVE_FORMULARIES_COUNT = DW_ACTIVE_FORMULARIES_COUNT THEN
	SELECT COUNT(*) INTO FF_DW_MERGED_FORMULARY_COUNT FROM ff.mv_active_formularies_import ffaf JOIN ff.formulary_entry  fffe ON ffaf.formulary_id=fffe.formulary_id AND ffaf.drug_id=fffe.drug_id AND ffaf.tier_id=fffe.tier_id AND ffaf.has_quantity_limit=fffe.has_quantity_limit AND ffaf.has_prior_authorization=fffe.has_prior_authorization AND fffa.has_step_therapy=fffe.has_step_therapy AND fffa.has_other_restriction=fffe.has_other_restriction AND fffa.reason_code_id=fffe.reason_code_id;
	IF FF_ACTIVE_FORMULARIES_COUNT = FF_DW_MERGED_FORMULARY_COUNT THEN
		SUCCESS:=TRUE;
	ELSE
		RAISE EXCEPTION 'FF SOURCE DATA AND DATAWAREHOUSE CONTAINS DIFFERENT ACTIVE FORMULARIES';
	END IF;
ELSE

END IF;
 
RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;