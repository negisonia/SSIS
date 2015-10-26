CREATE OR REPLACE FUNCTION test_data_states() --FF NEW
RETURNS boolean AS $$
DECLARE

country_001_id INTEGER;
country_us_id INTEGER;

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE COUNTRIES
    SELECT c.id into country_001_id FROM country c WHERE c.name='COUNTRY_001';
    SELECT c.id into country_us_id FROM country c WHERE c.name='United States';


    PERFORM common_create_state('Alabama','AL',country_us_id,TRUE);
    PERFORM common_create_state('Alaska','AK',country_us_id,TRUE);
    PERFORM common_create_state('Arizona','AZ',country_us_id,TRUE);
    PERFORM common_create_state('Arkansas','AR',country_us_id,TRUE);
    PERFORM common_create_state('California','CA',country_us_id,TRUE);
    PERFORM common_create_state('Colorado','CO',country_us_id,TRUE);
    PERFORM common_create_state('Delaware','AL',country_us_id,TRUE);
    PERFORM common_create_state('District of Columbia','DC',country_us_id,TRUE);
    PERFORM common_create_state('Florida','FL',country_us_id,TRUE);
    PERFORM common_create_state('Georgia','GA',country_us_id,TRUE);
    PERFORM common_create_state('Hawaii','HI',country_us_id,TRUE);
    PERFORM common_create_state('Idaho','ID',country_us_id,TRUE);
    PERFORM common_create_state('Illinois','IL',country_us_id,TRUE);
    PERFORM common_create_state('Indiana','IN',country_us_id,TRUE);
    PERFORM common_create_state('Iowa','IA',country_us_id,TRUE);
    PERFORM common_create_state('Kansas','KS',country_us_id,TRUE);
    PERFORM common_create_state('Kentucky','KY',country_us_id,TRUE);
    PERFORM common_create_state('Louisiana','LA',country_us_id,TRUE);
    PERFORM common_create_state('Maine','ME',country_us_id,TRUE);
    PERFORM common_create_state('Maryland','MD',country_us_id,TRUE);
    PERFORM common_create_state('Massachusetts','MA',country_us_id,TRUE);
    PERFORM common_create_state('Connecticut','CT',country_us_id,TRUE);
    PERFORM common_create_state('Michigan','MI',country_us_id,TRUE);
    PERFORM common_create_state('Minnesota','MN',country_us_id,TRUE);
    PERFORM common_create_state('Mississippi','MS',country_us_id,TRUE);
    PERFORM common_create_state('Missouri','MO',country_us_id,TRUE);
    PERFORM common_create_state('Montana','MT',country_us_id,TRUE);
    PERFORM common_create_state('Nebraska','NE',country_us_id,TRUE);
    PERFORM common_create_state('Nevada','NV',country_us_id,TRUE);
    PERFORM common_create_state('New Hampshire','NH',country_us_id,TRUE);
    PERFORM common_create_state('New Jersey','NJ',country_us_id,TRUE);
    PERFORM common_create_state('New Mexico','NM',country_us_id,TRUE);
    PERFORM common_create_state('New York','NY',country_us_id,TRUE);
    PERFORM common_create_state('North Carolina','NC',country_us_id,TRUE);
    PERFORM common_create_state('Ohio','OH',country_us_id,TRUE);
    PERFORM common_create_state('Oklahoma','OK',country_us_id,TRUE);
    PERFORM common_create_state('Oregon','OR',country_us_id,TRUE);
    PERFORM common_create_state('Pennsylvania','PA',country_us_id,TRUE);
    PERFORM common_create_state('Puerto Rico','PR',country_us_id,TRUE);
    PERFORM common_create_state('Rhode Island','RI',country_us_id,TRUE);
    PERFORM common_create_state('South Carolina','SC',country_us_id,TRUE);
    PERFORM common_create_state('South Dakota','SD',country_us_id,TRUE);
    PERFORM common_create_state('Tennessee','TN',country_us_id,TRUE);
    PERFORM common_create_state('Texas','TX',country_us_id,TRUE);
    PERFORM common_create_state('Utah','UT',country_us_id,TRUE);
    PERFORM common_create_state('Vermont','VT',country_us_id,TRUE);
    PERFORM common_create_state('Virginia','VA',country_us_id,TRUE);
    PERFORM common_create_state('Washington','WA',country_us_id,TRUE);
    PERFORM common_create_state('West Virginia','WV',country_us_id,TRUE);
    PERFORM common_create_state('Wisconsin','WI',country_us_id,TRUE);
    PERFORM common_create_state('Wyoming','WY',country_us_id,TRUE);
    PERFORM common_create_state('Alberta','AB',country_us_id,TRUE);
    PERFORM common_create_state('British Columbia','BC',country_us_id,TRUE);
    PERFORM common_create_state('Manitoba','MB',country_us_id,TRUE);
    PERFORM common_create_state('New Brunswick','NB',country_us_id,TRUE);
    PERFORM common_create_state('Ohio','OH',country_us_id,TRUE);
    PERFORM common_create_state('Newfoundland and Labrador','NL',country_us_id,TRUE);
    PERFORM common_create_state('Northwest Territories','NT',country_us_id,TRUE);
    PERFORM common_create_state('Nova Scotia','NS',country_us_id,TRUE);
    PERFORM common_create_state('Nunavut','NU',country_us_id,TRUE);
    PERFORM common_create_state('Ontario','ON',country_us_id,TRUE);
    PERFORM common_create_state('Prince Edward Island','PE',country_us_id,TRUE);
    PERFORM common_create_state('Quebec','QC',country_us_id,TRUE);
    PERFORM common_create_state('Sakatchewan','SK',country_us_id,TRUE);
    PERFORM common_create_state('Yukon Territory','YT',country_us_id,TRUE);
    PERFORM common_create_state('STATE_001','S_001',country_001_id,TRUE);
    PERFORM common_create_state('STATE_002','S_002',country_001_id,TRUE);
    PERFORM common_create_state('STATE_003','S_003',country_001_id,TRUE);
    
success=true;
return success;
END
$$ LANGUAGE plpgsql;