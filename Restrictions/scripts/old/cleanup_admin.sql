CREATE OR REPLACE FUNCTION clear_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

--TEST 001
reportBussinesId_test_001 varchar DEFAULT 'TEST REPORT 001';
reportName_test_001 varchar DEFAULT 'TEST REPORT NAME 001';
groupNames_test_001 varchar[]:=ARRAY['TEST_001_GROUP_1','TEST_001_GROUP_2'];

--TEST 002
reportBussinesId_test_002 varchar DEFAULT 'TEST REPORT 002';
reportName_test_002 varchar DEFAULT 'TEST REPORT NAME 002';
groupNames_test_002 varchar[] :=ARRAY['TEST_002_GROUP_1','TEST_002_GROUP_2','TEST_002_GROUP_3','TEST_002_GROUP_4','TEST_002_GROUP_5','TEST_002_GROUP_6','TEST_002_GROUP_7','TEST_002_GROUP_8'];

--TEST 003
reportBussinesId_test_003 varchar DEFAULT 'TEST REPORT 003';
reportName_test_003 varchar DEFAULT 'TEST REPORT NAME 003';
groupNames_test_003 varchar[] :=ARRAY['TEST_003_GROUP_1','TEST_003_GROUP_2','TEST_003_GROUP_3','TEST_003_GROUP_4','TEST_003_GROUP_5'];

--TEST 004
reportBussinesId_test_004 varchar DEFAULT 'TEST REPORT 004';
reportName_test_004 varchar DEFAULT 'TEST REPORT NAME 004';
groupNames_test_004 varchar[] :=ARRAY['TEST_004_GROUP_1','TEST_004_GROUP_2','TEST_004_GROUP_3','TEST_004_GROUP_4','TEST_004_GROUP_5','TEST_004_GROUP_6','TEST_004_GROUP_7','TEST_004_GROUP_8'];

--TEST 005
reportBussinesId_test_005 varchar DEFAULT 'TEST REPORT 005';
reportName_test_005 varchar DEFAULT 'TEST REPORT NAME 005';
groupNames_test_005 varchar[] :=ARRAY['TEST_005_GROUP_1','TEST_005_GROUP_2','TEST_005_GROUP_3'];

--TEST 006
reportBussinesId_test_006 varchar DEFAULT 'TEST REPORT 006';
reportName_test_006 varchar DEFAULT 'TEST REPORT NAME 006';
groupNames_test_006 varchar[] :=ARRAY['TEST_006_GROUP_1','TEST_006_GROUP_2','TEST_006_GROUP_3'];
BEGIN

--CLEAR DATA
perform clear_test_data(reportBussinesId_test_001,reportName_test_001,groupNames_test_001);
perform clear_test_data(reportBussinesId_test_002,reportName_test_002,groupNames_test_002);
perform clear_test_data(reportBussinesId_test_003,reportName_test_003,groupNames_test_003);
perform clear_test_data(reportBussinesId_test_004,reportName_test_004,groupNames_test_004);
perform clear_test_data(reportBussinesId_test_005,reportName_test_005,groupNames_test_005);
perform clear_test_data(reportBussinesId_test_006,reportName_test_006,groupNames_test_006);

SUCCESS:=true;
return SUCCESS;
END
$$ LANGUAGE plpgsql;