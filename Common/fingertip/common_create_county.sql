CREATE OR REPLACE FUNCTION common_create_county(name VARCHAR, fips_id INTEGER, state_id INTEGER, msa_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
county_id INTEGER DEFAULT NULL;
BEGIN

SELECT c.id INTO county_id FROM county c WHERE c.name=name AND c.statefid=state_id AND c.msafid = msa_id LIMIT 1;

--VALIDATE IF THE COUNTY ALREADY EXISTS
IF county_id IS NULL THEN
  --INSERT COUNTY RECORD
  INSERT INTO county(name, fipsid, statefid, msafid, population, fusionmapsid)
  VALUES (name, fips_id, state_id, msa_id, 0, NULL);

  RETURN county_id;
ELSE
  RETURN county_id;
END IF;

END
$$ LANGUAGE plpgsql;
