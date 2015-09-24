CREATE OR REPLACE FUNCTION common_create_qualifier_form_drug_class(new_provider_id INTEGER, new_health_plan_type_id INTEGER,new_drug_class_id INTEGER,  new_pa_form_link VARCHAR, new_specialty_enrollment_link VARCHAR, new_pa_policy_link VARCHAR, new_med_policy_link VARCHAR, new_is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
qualifier_form_id INTEGER DEFAULT NULL;
BEGIN

INSERT INTO qualifier_form_landing_pages_drug_class(
            provider_id, health_plan_type_id, health_plan_id, drug_class_id,
            pa_form_link, specialty_enrollment_link, pa_policy_link, med_policy_link,
            updated_at, updated_by_id, updated_by_name, created_at, created_by,
            is_active, super_copy_date, super_copy_by_id, super_copy_by_name)
    VALUES (new_provider_id, new_health_plan_type_id, NULL, new_drug_class_id,
            new_pa_form_link, new_specialty_enrollment_link, new_pa_policy_link, new_med_policy_link,
            current_timestamp, 1, 'tester', current_timestamp, 1,
            new_is_active, current_timestamp, 1, NULL) RETURNING id INTO qualifier_form_id;

	RETURN qualifier_form_id;
END
$$ LANGUAGE plpgsql;

