DO
$$
BEGIN
  CREATE SEQUENCE health_plan_display_id_seq;
  CREATE SEQUENCE health_plan_county_lives_id_seq;
  CREATE SEQUENCE drug_display_id_seq;
  CREATE SEQUENCE tier_order_index_id_seq;
EXCEPTION WHEN duplicate_table THEN
  RAISE NOTICE 'Skipping SQL Script: Sequences already created';
END
$$ LANGUAGE plpgsql;

