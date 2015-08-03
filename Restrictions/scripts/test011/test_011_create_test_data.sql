CREATE OR REPLACE FUNCTION restrictions_test_011_create_test_data() --DATA ENTRY DB
RETURNS boolean AS $$
DECLARE

indication_1_id INTEGER;
indication_2_id INTEGER;
indication_3_id INTEGER;
indication_4_id INTEGER;
indication_5_id INTEGER;

criteria_1_id INTEGER;
criteria_2_id INTEGER;
criteria_3_id INTEGER;
criteria_4_id INTEGER;
criteria_5_id INTEGER;
criteria_6_id INTEGER;
criteria_7_id INTEGER;
criteria_8_id INTEGER;
criteria_9_id INTEGER;
criteria_10_id INTEGER;
criteria_11_id INTEGER;
criteria_12_id INTEGER;
criteria_13_id INTEGER;

restriction_1_id INTEGER;
restriction_2_id INTEGER;
restriction_3_id INTEGER;
restriction_4_id INTEGER;
restriction_5_id INTEGER;
restriction_6_id INTEGER;
restriction_7_id INTEGER;
restriction_8_id INTEGER;
restriction_9_id INTEGER;
restriction_10_id INTEGER;
restriction_11_id INTEGER;
restriction_12_id INTEGER;
restriction_13_id INTEGER;

BEGIN

--RETRIEVE INDICATIONS IDS
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='restrictions_indication_1' and abbreviation = 'Ind1';
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='restrictions_indication_2' and abbreviation = 'Ind2';
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='restrictions_indication_3' and abbreviation = 'Ind3';
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='restrictions_indication_4' and abbreviation = 'Ind4';
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='restrictions_indication_5' and abbreviation = 'Ind5';


success=true;
return success;
END
$$ LANGUAGE plpgsql;