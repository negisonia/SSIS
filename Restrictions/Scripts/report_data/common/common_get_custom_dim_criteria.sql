CREATE OR REPLACE FUNCTION common_get_custom_dim_criteria(query_indication_id INTEGER, query_benefit_name VARCHAR, query_restriction_name VARCHAR, query_restriction_short_name VARCHAR,query_dim_restriction_type INTEGER,query_dim_criterion_type INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
dim_criteria_restriction_id INTEGER DEFAULT NULL;
BEGIN

   SELECT  dc.id INTO dim_criteria_restriction_id FROM dim_criteria_restriction dc WHERE dc.indication_id = query_indication_id AND dc.benefit_name=query_benefit_name AND dc.restriction_name=query_restriction_name  AND dc.criteria_restriction_short_name=query_restriction_short_name AND dc.dim_restriction_type_id=query_dim_restriction_type AND dc.dim_criterion_type_id=query_dim_criterion_type LIMIT 1;

   IF dim_criteria_restriction_id IS NULL THEN
        SELECT throw_error(format('CANNOT FIND DIM CRITERIA FOR INDICATION %s  BENEFIT NAME %s  RESTRICTION NAME %s AND RESTRICTION SHORT NAME %s', query_indication_id, query_benefit_name, query_restriction_name,query_restriction_short_name));
   ELSE
        RETURN dim_criteria_restriction_id;
   END IF;

END
$$ LANGUAGE plpgsql;
