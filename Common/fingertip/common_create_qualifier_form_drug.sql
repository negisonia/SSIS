CREATE OR REPLACE FUNCTION common_create_qualifier_form_drug(new_provider_id INTEGER, new_health_plan_type_id INTEGER, new_drug_class_id INTEGER, new_drug_id INTEGER, new_pa_form_link VARCHAR, new_specialty_enrollment_link VARCHAR, new_pa_policy_link VARCHAR, new_med_policy_link VARCHAR, new_is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
qualifier_form_id INTEGER DEFAULT NULL;
BEGIN
	INSERT INTO qualifier_form_landing_pages_drug(
                provider_id, health_plan_type_id, health_plan_id, drug_class_id,
                drug_id, pa_form_link, pa_form_link_dc_chk, specialty_enrollment_link,
                specialty_enrollment_link_dc_chk, pa_policy_link, pa_policy_link_dc_chk,
                med_policy_link, med_policy_link_dc_chk, updated_at, updated_by_id,
                updated_by_name, created_at, created_by, is_active, super_copy_date,
                super_copy_by_id, super_copy_by_name)
        VALUES (new_provider_id, new_health_plan_type_id, null, new_drug_class_id,
                new_drug_id, new_pa_form_link, CASE WHEN new_pa_form_link IS NOT NULL THEN TRUE ELSE FALSE END, new_specialty_enrollment_link,
                CASE WHEN new_specialty_enrollment_link IS NOT NULL THEN TRUE ELSE FALSE END, new_pa_policy_link, CASE WHEN new_pa_policy_link IS NOT NULL THEN TRUE ELSE FALSE END,
                new_med_policy_link, CASE WHEN new_med_policy_link IS NOT NULL THEN TRUE ELSE FALSE END, current_timestamp, 1,
                'restriction_tester', current_timestamp, 'restriction_tester', new_is_active, current_timestamp,
                null, null) RETURNING id INTO qualifier_form_id;

	RETURN qualifier_form_id;
END
$$ LANGUAGE plpgsql;

