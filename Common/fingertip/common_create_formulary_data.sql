CREATE OR REPLACE FUNCTION common_create_formulary_data(formulary_id INTEGER,drug_id INTEGER, tier_id INTEGER, reason_code_id INTEGER, specialty_copay BOOLEAN, has_pa BOOLEAN, has_st BOOLEAN, has_ql BOOLEAN, has_or BOOLEAN) --FF_NEW DB
RETURNS BOOLEAN AS $$
DECLARE

formulary_entry_id INTEGER;

ql_qualifier INTEGER;
pa_qualifier INTEGER;
st_qualifier INTEGER;
or_qualifier INTEGER;

qualifier VARCHAR:='qualifier';

success BOOLEAN DEFAULT FALSE;
BEGIN

  --RETRIEVE QUALIFIERS
  SELECT common_get_table_id_by_name(qualifier, 'Quantity Limits') INTO ql_qualifier;
  SELECT common_get_table_id_by_name(qualifier, 'Prior Authorization') INTO pa_qualifier;
  SELECT common_get_table_id_by_name(qualifier, 'Step Therapy') INTO st_qualifier;
  SELECT common_get_table_id_by_name(qualifier, 'Other Restrictions') INTO or_qualifier;

  SELECT common_create_formulary_entry(formulary_id, drug_id, tier_id, reason_code_id, specialty_copay) INTO formulary_entry_id;
  IF has_pa IS TRUE THEN
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
  END IF;
  IF has_st IS TRUE THEN
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, st_qualifier);
  END IF;
  IF has_ql IS TRUE THEN
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, ql_qualifier);
  END IF;
  IF has_or IS TRUE THEN
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, or_qualifier);
  END IF;

  success := TRUE;
  RETURN success;

END
$$ LANGUAGE plpgsql;

