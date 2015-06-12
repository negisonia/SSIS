CREATE OR REPLACE FUNCTION validatereasoncodesdata()
RETURNS BOOLEAN AS $$
DECLARE
SUCCESS BOOLEAN DEFAULT FALSE;
FF_REASON_COUNT INTEGER;
DW_REASON_COUNT INTEGER;
FF_DW_MERGED_REASON_COUNT INTEGER;
BEGIN

  SELECT COUNT(*) INTO FF_REASON_COUNT  FROM ff.reason_code_import  ffrci where ffrci.is_active=1 AND id <> 0;
  SELECT COUNT(*) INTO DW_REASON_COUNT FROM ff.reason_code;
  
  IF FF_REASON_COUNT = DW_REASON_COUNT THEN
     SELECT COUNT(*) INTO FF_DW_MERGED_REASON_COUNT FROM ff.reason_code_import ffri JOIN ff.reason_code ffr ON ffri.id=ffr.id AND ffri.is_active=1 AND ffri.id <>0 AND ffri.is_active=ffr.is_active AND ffri.code=ffr.code AND ffri.description = ffr.description;
     IF FF_REASON_COUNT = FF_DW_MERGED_REASON_COUNT THEN
	SUCCESS:=TRUE;
     ELSE
        select throw_error('FF SOURCE REASONS AND DATAWAREHOUSE REASONS DONT MATCH');    
     END IF;
  ELSE
     select throw_error('FF SOURCE REASONS AND DATAWAREHOUSE REASONS DONT MATCH');
  END IF;
RETURN SUCCESS;
END
$$ LANGUAGE plpgsql;
