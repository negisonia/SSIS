CREATE OR REPLACE FUNCTION test_data_reason_codes() --FF NEW
RETURNS boolean AS $$
DECLARE
ql_qualifier INTEGER;
pa_qualifier INTEGER;
st_qualifier INTEGER;
or_qualifier INTEGER;

success BOOLEAN:=FALSE;
BEGIN

--RETRIEVE QUALIFIERS
SELECT q.id INTO ql_qualifier FROM qualifier q WHERE q.name='Quantity Limits';
SELECT q.id INTO pa_qualifier FROM qualifier q WHERE q.name='Prior Authorization';
SELECT q.id INTO st_qualifier FROM qualifier q WHERE q.name='Step Therapy';
SELECT q.id INTO or_qualifier FROM qualifier q WHERE q.name='Other Restrictions';



--CREATE REASON CODES
PERFORM common_create_reason_codes(1,'92','PA required if recommended dose duration exceeded.',pa_qualifier);
PERFORM common_create_reason_codes(1,'40','Covered under medical benefit.',NULL);
PERFORM common_create_reason_codes(1,'42','Non-preferred under medical benefit.',NULL);
PERFORM common_create_reason_codes(1,'90','PA not required on initial fill.',pa_qualifier);
PERFORM common_create_reason_codes(1,'41','Preferred under medical benefit',NULL);
PERFORM common_create_reason_codes(1,'60','Age restriction, PA may be required.',NULL);

success=true;
return success;
END
$$ LANGUAGE plpgsql;