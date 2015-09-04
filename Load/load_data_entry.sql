-- Run from root of project
-- psql -d sandbox_data_entry -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W < Load/load_data_entry.sql
-- VsOCWIozIelwQcRgR4w3

-- Common
\i 'Common/call_functions_from_table.sql'
\i 'Common/common_create_test_data_functions.sql'
\i 'Common/common_get_table_id_by_name.sql'

-- Common Data Entry
--\i 'Common/data_entry/common.sql'
\i 'Common/data_entry/common_cleanup.sql'
\i 'Common/data_entry/common_create_atomic_step_notes.sql'
\i 'Common/data_entry/common_create_atomic_steps.sql'
\i 'Common/data_entry/common_create_criteria.sql'
\i 'Common/data_entry/common_create_criteria_indication.sql'
\i 'Common/data_entry/common_create_criteria_restriction.sql'
\i 'Common/data_entry/common_create_custom_option.sql'
\i 'Common/data_entry/common_create_data_entry.sql'
\i 'Common/data_entry/common_create_data_entry_details.sql'
\i 'Common/data_entry/common_create_drug_class_indication.sql'
\i 'Common/data_entry/common_create_drug_indication.sql'
\i 'Common/data_entry/common_create_indication.sql'
\i 'Common/data_entry/common_create_indication_step_custom_option.sql'
\i 'Common/data_entry/common_create_medical.sql'
\i 'Common/data_entry/common_create_medical_criteria.sql'
\i 'Common/data_entry/common_create_note.sql'
\i 'Common/data_entry/common_create_prior_authorization.sql'
\i 'Common/data_entry/common_create_prior_authorization_criteria.sql'
\i 'Common/data_entry/common_create_quantity_limit.sql'
\i 'Common/data_entry/common_create_quantity_limit_criteria.sql'
\i 'Common/data_entry/common_create_restriction.sql'
\i 'Common/data_entry/common_create_step_custom_option.sql'
\i 'Common/data_entry/common_create_step_therapies.sql'
\i 'Common/data_entry/common_insert_test_data_functions_table.sql'
\i 'Common/data_entry/common_update_data_entry.sql'
\i 'Common/data_entry/test_data_atomic_step_notes.sql'
\i 'Common/data_entry/test_data_criteria.sql'
\i 'Common/data_entry/test_data_criteria_indications.sql'
\i 'Common/data_entry/test_data_criteria_restriction.sql'
\i 'Common/data_entry/test_data_custom_options.sql'
\i 'Common/data_entry/test_data_drug_class_indication.sql'
\i 'Common/data_entry/test_data_drug_indications.sql'
\i 'Common/data_entry/test_data_indications.sql'
\i 'Common/data_entry/test_data_indications_step_custom_options.sql'
\i 'Common/data_entry/test_data_medicals.sql'
\i 'Common/data_entry/test_data_prior_authorizations.sql'
\i 'Common/data_entry/test_data_quantity_limits.sql'
\i 'Common/data_entry/test_data_restrictions.sql'
\i 'Common/data_entry/test_data_step_custom_options.sql'
\i 'Common/data_entry/test_data_step_therapies.sql'
\i 'Common/data_entry/throw_error.sql'
