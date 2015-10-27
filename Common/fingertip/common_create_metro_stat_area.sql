CREATE OR REPLACE FUNCTION common_create_metro_stat_area(new_id INTEGER, new_name VARCHAR, new_cbsa INTEGER,new_population integer, new_ff_name VARCHAR, new_image_file_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
msa_id INTEGER DEFAULT NULL;
BEGIN

SELECT msa.id INTO msa_id FROM metrostatarea msa WHERE msa.name=new_name AND msa.ff_name=new_ff_name LIMIT 1;

--VALIDATE IF THE METRO STAT AREA ALREADY EXISTS
IF msa_id IS NULL THEN
  --INSERT METRO STAT AREA RECORD
  INSERT INTO metrostatarea(
            id, name, cbsa, population, ff_name, image_file_name)
    VALUES (new_id, new_name, new_cbsa, new_population, new_ff_name, new_image_file_name) RETURNING id INTO msa_id;

  RETURN msa_id;
ELSE
  RETURN msa_id;
END IF;

END
$$ LANGUAGE plpgsql;
