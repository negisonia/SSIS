CREATE OR REPLACE FUNCTION test002createtestdata() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

reportBussinesId varchar DEFAULT 'TEST REPORT 002';
reportName varchar DEFAULT 'TEST REPORT NAME 002';
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 01';
indicationId integer:=7; --Acute Lymphoblastic Leukemia
drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
restrictionsIds INTEGER[]:= ARRAY[775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,1860,1861,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1885,2105,2106,2107,2108,2109,2110,2111,2172,2174,2175];--ALL RESTRICTIONS

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

group1Name varchar DEFAULT 'TEST_002_GROUP_TYPE_1';
group1Restrictions INTEGER[] :=ARRAY[775,776,777,787,788,789,809,810,811,812,813,821,822,823,846];--only type 1 dim_criterion_types restrictions

group2Name varchar DEFAULT 'TEST_002_GROUP_TYPE_2';
group2Restrictions INTEGER[] :=ARRAY[840,841,842,847,848,1860,1861,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1885,2105,2106,2107,2108,2109,2110,2111,2172,2174,2175];--all type 2 dim_criterion_types restrictions

group3Name varchar DEFAULT 'TEST_002_GROUP_TYPE_1_2';
group3Restrictions INTEGER[] :=ARRAY[775,776,777,787,788,789,809,810,811,840,841,842,847,848,1860,1861,1864,1865,1866];--type 1 and type 2 dim_criterion_types restrictions

BEGIN

  --CREATE REPORT
  select createreport(reportBussinesId,reportName) INTO reportId;

  --CREATE REPORT CLIENT
  SELECT createReportClient(reportId,reportClientName) into reportClientId;

  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  SELECT createreportdrugsreportId,drugIds,indicationId);

  --CREATE REPORT RESTRICTIONS
  SELECT createreportrestrictions(reportId,restrictionsIds);
  
  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #1 DIM CRITERION TYPE
  SELECT createreportcriteriagroups(reportId,reportClientId,group1Restrictions,group1Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #2 DIM CRITERION TYPE
  SELECT createreportcriteriagroups(reportId,reportClientId,group2Restrictions,group2Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #3 DIM CRITERION TYPE
  SELECT createreportcriteriagroups(reportId,reportClientId,group3Restrictions,group3Name,userEmail);
 
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;