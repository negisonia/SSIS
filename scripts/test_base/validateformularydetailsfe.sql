CREATE OR REPLACE FUNCTION validateformularydetails()
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
FE_FORMULARY_DETAILS_COUNT INTEGER;
DW_FORMULARY_DETAILS_COUNT INTEGER;
FE_DW_MERGED_FORMULARY_DETAILS_COUNT INTEGER;
BEGIN

SELECT COUNT(*) INTO DW_FORMULARY_DETAILS_COUNT FROM  dw.formulary_detail_source_import dwfd;
SELECT COUNT(*) INTO FE_FORMULARY_DETAILS_COUNT FROM formulary_detail  fefd;

IF FE_FORMULARY_DETAILS_COUNT = DW_FORMULARY_DETAILS_COUNT THEN
	SELECT count(*) INTO FE_DW_MERGED_FORMULARY_DETAILS_COUNT FROM dw.formulary_detail_source_import fd inner JOIN formulary_detail fefd  ON  fd.provider_id=fefd.provider_id 
		AND fd.provider_name=fefd.provider_name 
		AND fd.health_plan_id=fefd.health_plan_id 
		AND fd.health_plan_name=fefd.health_plan_name 
		AND fd.formulary_url=fefd.formulary_url 
		AND fd.drug_id=fefd.drug_id 
		AND fd.drug_name=fefd.drug_name 
		AND fd.health_plan_type_id =fefd.health_plan_type_id
		AND fd.health_plan_type_name=fefd.health_plan_type_name
		AND fd.tier_id=fefd.tier_id			
		AND (CASE WHEN fd.preferred_brand_tier_id != null THEN fd.preferred_brand_tier_id ELSE 0 END ) = (CASE WHEN fefd.preferred_brand_tier_id != null THEN fefd.preferred_brand_tier_id ELSE 0 END ) 
		AND fd.has_quantity_limit=fefd.has_quantity_limit
		AND fd.has_prior_authorization=fefd.has_prior_authorization
		AND fd.has_step_therapy=fefd.has_step_therapy
		AND fd.has_other_restriction=fefd.has_other_restriction
		AND fd.has_pharmacy=fefd.has_pharmacy
		AND fd.has_medical=fefd.has_medical
		AND (CASE WHEN fd.reason_code_id != null THEN fd.reason_code_id ELSE 0 END ) = (CASE WHEN fefd.reason_code_id != null THEN fefd.reason_code_id ELSE 0 END ) 
		AND (CASE WHEN fd.reason_code_code != null THEN fd.reason_code_code ELSE '' END ) = (CASE WHEN fefd.reason_code_code != null THEN fefd.reason_code_code ELSE '' END ) 
		AND (CASE WHEN fd.reason_code_desc != null THEN fd.reason_code_desc ELSE '' END ) = (CASE WHEN fefd.reason_code_desc != null THEN fefd.reason_code_desc ELSE '' END ); 

	IF FE_FORMULARY_DETAILS_COUNT = FE_DW_MERGED_FORMULARY_DETAILS_COUNT THEN
		SUCCESS:=TRUE;
	ELSE
		select throw_error('FE.FORMULARY_DETAIL AND DW.FORMULARY_DETAIL CONTAINS DIFFERENT FORMULARIES');
	END IF;
ELSE
	select throw_error('FE.FORMULARY_DETAIL AND DW.FORMULARY_DETAIL CONTAINS DIFFERENT FORMULARIES');
END IF;
 
RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;