CREATE OR REPLACE FUNCTION test_data_states() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
country_001_id INTEGER;
BEGIN
    SELECT c.id into country_001_id FROM country c WHERE c.name='COUNTRY_001';


    PERFORM common_create_state (59, true, 'Alberta', 'AB', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (60, true, 'British Columbia', 'BC', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (61, true, 'Manitoba', 'MB', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (62, true, 'New Brunswick', 'NB', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (63, true, 'Newfoundland and Labrador', 'NL', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (64, true, 'Northwest Territories', 'NT', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (65, true, 'Nova Scotia', 'NS', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (66, true, 'Nunavut', 'NU', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (67, true, 'Ontario', 'ON', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (68, true, 'Prince Edward Island', 'PE', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (69, true, 'Quebec', 'QC', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (70, true, 'Sakatchewan', 'SK', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (71, true, 'Yukon Territory', 'YT', 2, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (5, false, 'American', 'AS', 1, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (11, false, 'Fed. States of Micronesia', 'FM', 1, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (14, false, 'Guam', 'GU', 1, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (25, false, 'Marshall Islands Marshall Is.', 'MH', 1, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (40, false, 'Northern Marianas', 'MP', 1, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (54, false, 'U.S. Virgin Islands', 'VI', 1, '', NULL, NULL, NULL, NULL, NULL);
    PERFORM common_create_state (45, true, 'Puerto Rico', 'PR', 1, 'pr', 4, 3912054, true, NULL, NULL);
    PERFORM common_create_state (32, true, 'Nebraska', 'NE', 1, 'ne', 6, 1758787, true, 31, 44273);
    PERFORM common_create_state (33, true, 'Nevada', 'NV', 1, 'nv', 5, 2414807, true, 32, 48652);
    PERFORM common_create_state (34, true, 'New Hampshire', 'NH', 1, 'nh', 3, 1309940, true, 33, 32695);
    PERFORM common_create_state (35, true, 'New Jersey', 'NJ', 1, 'nj', 3, 8717925, true, 34, 225005);
    PERFORM common_create_state (36, true, 'New Mexico', 'NM', 1, 'nm', 5, 1928384, true, 35, 69214);
    PERFORM common_create_state (37, true, 'New York', 'NY', 1, 'ny', 3, 19254630, true, 36, 735184);
    PERFORM common_create_state (38, true, 'North Carolina', 'NC', 1, 'nc', 2, 8683242, true, 37, 345546);
    PERFORM common_create_state (39, true, 'North Dakota', 'ND', 1, 'nd', 6, 636677, true, 38, 17310);
    PERFORM common_create_state (41, true, 'Ohio', 'OH', 1, 'oh', 1, 11464042, true, 39, 327995);
    PERFORM common_create_state (42, true, 'Oklahoma', 'OK', 1, 'ok', 6, 3547884, true, 40, 124833);
    PERFORM common_create_state (43, true, 'Oregon', 'OR', 1, 'og', 5, 3641056, true, 41, 97992);
    PERFORM common_create_state (44, true, 'Pennsylvania', 'PA', 1, 'pa', 2, 12429616, true, 42, 407325);
    PERFORM common_create_state (46, true, 'Rhode Island', 'RI', 1, 'ri', 3, 1076189, true, 44, 6387);
    PERFORM common_create_state (47, true, 'South Carolina', 'SC', 1, 'sc', 2, 4255083, true, 45, 172353);
    PERFORM common_create_state (48, true, 'South Dakota', 'SD', 1, 'sd', 6, 775933, true, 46, 22015);
    PERFORM common_create_state (49, true, 'Tennessee', 'TN', 1, 'tn', 4, 5962959, true, 47, 289609);
    PERFORM common_create_state (50, true, 'Texas', 'TX', 1, 'tx', 6, 22859968, true, 48, 700502);
    PERFORM common_create_state (51, true, 'Utah', 'UT', 1, 'ut', 5, 2469585, true, 49, 35199);
    PERFORM common_create_state (52, true, 'Vermont', 'VT', 1, 'vt', 3, 623050, true, 50, 26793);
    PERFORM common_create_state (53, true, 'Virginia', 'VA', 1, 'va', 2, 7567465, true, 51, 203904);
    PERFORM common_create_state (55, true, 'Washington', 'WA', 1, 'wa', 5, 6287759, true, 53, 154307);
    PERFORM common_create_state (56, true, 'West Virginia', 'WV', 1, 'wv', 2, 1816856, true, 54, 88861);
    PERFORM common_create_state (57, true, 'Wisconsin', 'WI', 1, 'wi', 6, 5536201, true, 55, 141781);
    PERFORM common_create_state (58, true, 'Wyoming', 'WY', 1, 'wy', 5, 509294, true, 56, 11026);
    PERFORM common_create_state (1, true, 'Alabama', 'AL', 1, 'al', 4, 4557808, true, 1, 226670);
    PERFORM common_create_state (2, true, 'Alaska', 'AK', 1, 'ak', 5, 663661, true, 2, 14337);
    PERFORM common_create_state (3, true, 'Arizona', 'AZ', 1, 'az', 5, 5939292, true, 4, 157348);
    PERFORM common_create_state (4, true, 'Arkansas', 'AR', 1, 'ar', 6, 2779154, true, 5, 134647);
    PERFORM common_create_state (6, true, 'California', 'CA', 1, 'ca', 5, 36132147, true, 6, 1191551);
    PERFORM common_create_state (7, true, 'Colorado', 'CO', 1, 'co', 5, 4665177, true, 8, 94864);
    PERFORM common_create_state (8, true, 'Connecticut', 'CT', 1, 'ct', 3, 3510297, true, 9, 102936);
    PERFORM common_create_state (9, true, 'Delaware', 'DE', 1, 'de', 2, 843524, true, 10, 24931);
    PERFORM common_create_state (10, true, 'District of Columbia', 'DC', 1, 'dc', 2, 550521, true, 11, 21399);
    PERFORM common_create_state (12, true, 'Florida', 'FL', 1, 'fl', 4, 17789864, true, 12, 615697);
    PERFORM common_create_state (13, true, 'Georgia', 'GA', 1, 'ga', 4, 9072576, true, 13, 296245);
    PERFORM common_create_state (15, true, 'Hawaii', 'HI', 1, 'hi', 5, 1275194, true, 15, 36101);
    PERFORM common_create_state (16, true, 'Idaho', 'ID', 1, 'id', 5, 1429096, true, 16, 36138);
    PERFORM common_create_state (17, true, 'Illinois', 'IL', 1, 'il', 1, 12763371, true, 17, 348969);
    PERFORM common_create_state (18, true, 'Indiana', 'IN', 1, 'ii', 1, 6271973, true, 18, 173645);
    PERFORM common_create_state (19, true, 'Iowa', 'IA', 1, 'ia', 6, 2966334, true, 19, 83703);
    PERFORM common_create_state (20, true, 'Kansas', 'KS', 1, 'ks', 6, 2744687, true, 20, 69345);
    PERFORM common_create_state (21, true, 'Kentucky', 'KY', 1, 'ky', 1, 4173405, true, 21, 195280);
    PERFORM common_create_state (22, true, 'Louisiana', 'LA', 1, 'la', 4, 4523628, true, 22, 193205);
    PERFORM common_create_state (23, true, 'Maine', 'ME', 1, 'me', 3, 1321505, true, 23, 85897);
    PERFORM common_create_state (24, true, 'Maryland', 'MD', 1, 'md', 2, 5600388, true, 24, 124622);
    PERFORM common_create_state (26, true, 'Massachusetts', 'MA', 1, 'ma', 3, 6398743, true, 25, 250934);
    PERFORM common_create_state (27, true, 'Michigan', 'MI', 1, 'mi', 1, 10120860, true, 26, 277466);
    PERFORM common_create_state (28, true, 'Minnesota', 'MN', 1, 'mn', 6, 5132799, true, 27, 129305);
    PERFORM common_create_state (29, true, 'Mississippi', 'MS', 1, 'ms', 4, 2921088, true, 28, 161909);
    PERFORM common_create_state (30, true, 'Missouri', 'MO', 1, 'mo', 6, 5800310, true, 29, 198433);
    PERFORM common_create_state (31, true, 'Montana', 'MT', 1, 'mt', 5, 935670, true, 30, 25934);

    PERFORM common_create_state(72,TRUE,'STATE_001','S_001',country_001_id,NULL,NULL,NULL,NULL,NULL,NULL);
    PERFORM common_create_state(73,TRUE,'STATE_002','S_002',country_001_id,NULL,NULL,NULL,NULL,NULL,NULL);
    PERFORM common_create_state(74,TRUE,'STATE_003','S_003',country_001_id,NULL,NULL,NULL,NULL,NULL,NULL);
    
success=true;
return success;
END
$$ LANGUAGE plpgsql;