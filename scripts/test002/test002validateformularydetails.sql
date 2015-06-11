CREATE OR REPLACE FUNCTION test002validateformularydetails()
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
DW_FORMULARY_DETAILS_COUNT INTEGER;
DW_MERGED_FORMULARY_DETAILS_COUNT INTEGER;
BEGIN

SELECT COUNT(*) INTO DW_FORMULARY_DETAILS_COUNT FROM dw.formulary_detail;

SELECT COUNT(fd.*) INTO DW_MERGED_FORMULARY_DETAILS_COUNT from dw.formulary_detail fd inner join ff.formulary_entry fe
on fd.formulary_id=fe.formulary_id
and fd.tier_id=fe.tier_id
and fd.drug_id=fe.drug_id
left outer join ff.reason_code rc on rc.id= fd.reason_code_id 
and fd.has_quantity_limit = CASE  WHEN fd.tier_id=10 AND rc.code IN ('40', '41', '42') THEN false ELSE fe.has_quantity_limit END
and fd.has_prior_authorization = CASE WHEN fd.tier_id = 10 AND rc.code IN ('40','41','42') THEN FALSE ELSE fe.has_prior_authorization END
and fd.has_step_therapy= CASE WHEN fd.tier_id = 10 AND rc.code IN ('40','41','42') THEN FALSE ELSE fe.has_step_therapy END 
and fd.has_other_restriction=CASE WHEN fd.tier_id = 10 AND rc.code IN ('40','41','42') THEN FALSE ELSE fe.has_other_restriction END;

 IF DW_FORMULARY_DETAILS_COUNT = DW_MERGED_FORMULARY_DETAILS_COUNT THEN 
	SUCCESS:=TRUE;
 ELSE
	RAISE EXCEPTION 'FORMULARY DETAILS DATA MISMATCH';
 END IF;

RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;