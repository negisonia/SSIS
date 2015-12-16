CREATE OR REPLACE FUNCTION common_get_dim_criteria_restriction(query_indication_id INTEGER, query_benefit_name VARCHAR, query_dim_criterion_type_id INTEGER, query_dim_restriction_type_id INTEGER, query_criteria_restriction_name VARCHAR, query_criteria_restriction_short_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
dim_criteria_restriction_id INTEGER DEFAULT NULL;
BEGIN

   select d.id from dim_criteria_restriction d where d.indication_id=query_indication_id and d.benefit_name=query_benefit_name and d.dim_criterion_type_id=query_dim_criterion_type_id and d.dim_restriction_type_id=query_dim_restriction_type_id and d.criteria_restriction_name=query_criteria_restriction_name and d.criteria_restriction_short_name = query_criteria_restriction_short_name INTO dim_criteria_restriction_id;

   IF dim_criteria_restriction_id IS NULL THEN
        SELECT throw_error(format('CANNOT FIND DIM CRITERIA FOR INDICATION %s  BENEFIT NAME %s  RESTRICTION NAME %s AND RESTRICTION SHORT NAME %s', query_indication_id, query_benefit_name, query_restriction_name,query_restriction_short_name));
   ELSE
        RETURN dim_criteria_restriction_id;
   END IF;

END
$$ LANGUAGE plpgsql;
