CREATE OR REPLACE FUNCTION common_create_note(new_arname VARCHAR ,  new_arid INTEGER, note_text VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
note_id INTEGER DEFAULT NULL;
BEGIN

SELECT n.id INTO note_id FROM notes n WHERE n.arname=new_arname and n.arid = new_arid and n.text=note_text LIMIT 1;

--VALIDATE IF THE NOTE ALREADY EXISTS
IF note_id IS NULL THEN
  --INSERT CRITERIA RECORD
  INSERT INTO notes( arname, arid, text, created_at, updated_at, title, copiedfromid)
      VALUES ( new_arname, new_arid, note_text, current_timestamp, current_timestamp, null,null) RETURNING id INTO note_id;
  RETURN note_id;
ELSE
  RETURN note_id;
END IF;

END
$$ LANGUAGE plpgsql;
