CREATE OR REPLACE FUNCTION common_create_data_entry_details(new_indication_id INTEGER, new_provider_id INTEGER, new_health_plan_type INTEGER, new_internal_comment VARCHAR, new_source_comments VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
data_entry_details_id INTEGER DEFAULT NULL;
BEGIN

INSERT INTO data_entries_details(
            indication_id, provider_id, healthplantype_id, internal_comments,
            source_comments, display_summary, created_at, updated_at, copiedfromid)
    VALUES (new_indication_id, new_provider_id, new_health_plan_type, new_internal_comment,
            new_source_comments, NULL, current_timestamp, current_timestamp, NULL) RETURNING id INTO data_entry_details_id;

RETURN data_entry_details_id;
END
$$ LANGUAGE plpgsql;
