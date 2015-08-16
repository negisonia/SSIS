CREATE OR REPLACE FUNCTION common_create_mv_active_formularies(new_formulary_id INTEGER, new_drug_id INTEGER, new_tier_id INTEGER, new_has_quantity_limit BOOLEAN, new_has_prior_authorization BOOLEAN, new_has_step_therapy BOOLEAN,new_has_other_restriction BOOLEAN, new_reason_code INTEGER) --FF_NEW DB
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM mv_active_formularies af WHERE af.formulary_id=new_formulary_id and af.drug_id=new_drug_id and af.tier_id=new_tier_id LIMIT 1) INTO valueExists;

--VALIDATE IF THE TIER ALREADY EXISTS
IF valueExists IS FALSE THEN
	--INSERT ACTIVE FORMULARY
	INSERT INTO public.mv_active_formularies(
                formulary_id, drug_id, tier_id, has_quantity_limit, has_prior_authorization,
                has_step_therapy, has_other_restriction, reason_code_id)
        VALUES (new_formulary_id, new_drug_id, new_tier_id, new_has_quantity_limit, new_has_prior_authorization,
                new_has_step_therapy, new_has_other_restriction, new_reason_code);
END IF;

success :=TRUE;
return success;

END
$$ LANGUAGE plpgsql;

