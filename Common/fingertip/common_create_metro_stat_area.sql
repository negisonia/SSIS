CREATE OR REPLACE FUNCTION common_create_metro_stat_area(msa_name VARCHAR, msa_ff_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
msa_id INTEGER DEFAULT NULL;
BEGIN

SELECT msa.id INTO msa_id FROM metrostatarea msa WHERE msa.name=msa_name AND msa.ff_name=msa_ff_name LIMIT 1;

--VALIDATE IF THE METRO STAT AREA ALREADY EXISTS
IF msa_id IS NULL THEN
  --INSERT METRO STAT AREA RECORD
  INSERT INTO metrostatarea(
            name, cbsa, population, ff_name, image_file_name)
    VALUES (msa_name, NULL, NULL, msa_ff_name, NULL);

  RETURN msa_id;
ELSE
  RETURN msa_id;
END IF;

END
$$ LANGUAGE plpgsql;
