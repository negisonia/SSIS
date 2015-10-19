CREATE OR REPLACE FUNCTION ana_rpt_create_criteria_report_fe_data(region_names VARCHAR[], health_plan_type_names VARCHAR[], drug_names VARCHAR[], region_type varchar, drug_class_name varchar)
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;
name varchar;
health_plan_type_ids INTEGER[];
drug_ids INTEGER[];
region_ids INTEGER[] := ARRAY[]::INTEGER[];
region_type_id INTEGER;

drug_class_id INTEGER;
BEGIN

  FOREACH name IN ARRAY health_plan_type_names
  LOOP
    health_plan_type_ids = array_append(health_plan_type_ids,common_get_table_id_by_name('health_plan_types', name));
  END LOOP;

  FOREACH name IN ARRAY drug_names
  LOOP
    drug_ids = array_append(drug_ids,common_get_table_id_by_name('drugs', name));
  END LOOP;

  FOREACH name IN ARRAY region_names
  LOOP
    IF region_type = 'State' THEN 
      region_ids = array_append(region_ids,common_get_table_id_by_name('states', name));
    ELSIF region_type = 'County' THEN
      region_ids = array_append(region_ids,common_get_table_id_by_name('counties', name));
    ELSIF region_type = 'MetroStatArea' THEN
      region_ids = array_append(region_ids,common_get_table_id_by_name('metro_stat_areas', name));
    END IF;
  END LOOP;
  
  IF region_type = 'State' THEN 
    region_type_id = 2;

  ELSIF region_type = 'County' THEN
    region_type_id = 1;

  ELSIF region_type = 'MetroStatArea' THEN 
    region_type_id = 3;

  ELSE
    region_type_id = 4;

  END IF;

  SELECT common_get_table_id_by_name('drug_classes', drug_class_name) INTO drug_class_id;

  SELECT create_criteria_report(NULL,0,3,drug_class_id,region_type_id,FALSE,FALSE,FALSE,drug_ids,health_plan_type_ids,region_type,region_ids,NULL,NULL,NULL,NULL,NULL) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
