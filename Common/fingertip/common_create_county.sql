CREATE OR REPLACE FUNCTION common_create_county(new_id INTEGER, new_name VARCHAR, new_fipsid INTEGER, new_state_id INTEGER, new_msa_id INTEGER, new_population INTEGER, new_fusionmapsid VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
county_id INTEGER DEFAULT NULL;
BEGIN

SELECT c.id INTO county_id FROM county c WHERE c.name=new_name AND c.statefid=new_state_id AND c.msafid = new_msa_id LIMIT 1;

--VALIDATE IF THE COUNTY ALREADY EXISTS
IF county_id IS NULL THEN
  --INSERT COUNTY RECORD
 INSERT INTO public.county(
             id, name, fipsid, statefid, msafid, population, fusionmapsid)
     VALUES (new_id, new_name, new_fipsid, new_state_id, new_msa_id, new_population, new_fusionmapsid) RETURNING id INTO county_id;

  RETURN county_id;
ELSE
  RETURN county_id;
END IF;

END
$$ LANGUAGE plpgsql;
