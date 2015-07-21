CREATE OR REPLACE FUNCTION common_create_formulary_entry_qualifier(formulary_entry_id INTEGER, qualifier_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
formulary_entry_qualifier_id INTEGER DEFAULT NULL;
BEGIN

SELECT feq.id INTO formulary_entry_qualifier_id FROM formularyentryqualifier feq WHERE feq.formularyentryfid=formulary_entry_id and feq.qualifierfid=qualifier_id LIMIT 1;

--VALIDATE IF THE FORMULARY ENTRY QUALIFIER ALREADY EXISTS
IF formulary_entry_qualifier_id IS NULL THEN
	--INSERT FORMULARY ENTRY QUALIFIER RECORD
	 INSERT INTO formularyentryqualifier(
                 formularyentryfid, qualifierfid, updated_at, updated_by,
                 legacyfid)
         VALUES ( formulary_entry_id, qualifier_id, current_timestamp, NULL,
                 NULL) RETURNING id INTO formulary_entry_qualifier_id;

	RETURN formulary_entry_qualifier_id;
ELSE
	RETURN formulary_entry_qualifier_id;
END IF;

END
$$ LANGUAGE plpgsql;

