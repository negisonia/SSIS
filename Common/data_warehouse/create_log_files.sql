CREATE TABLE log_etl_validation_process
  (
    id serial NOT NULL,
    process_started_at timestamp without time zone,
    data_insertion_ended_at timestamp without time zone,
    etl_execution_ended_at timestamp without time zone,
    second_etl_execution_ended_at timestamp without time zone,
    second_data_insertion_ended_at timestamp without time zone,
    analytics_validation_ended_at timestamp without time zone,
    restrictions_validation_ended_at timestamp without time zone,
    process_ended_at timestamp without time zone,
    status character varying(255)
  );

CREATE TABLE log_etl_validation_process_errors
  (
    id serial NOT NULL,
    log_etl_validation_process_id integer NOT NULL,
    error_log text,
    created_at timestamp without time zone
  );

CREATE OR REPLACE FUNCTION pre_etl_validation_checks()
  RETURNS void AS $$
  BEGIN
      IF EXISTS (SELECT * FROM log_etl_validation_process WHERE process_ended_at IS NULL AND id in (SELECT MAX(id) FROM log_etl_validation_process)) THEN
        PERFORM throw_error('Error: Another etl validation process is still running. ');
      ELSE
        PERFORM ' Passed Pre-ETL Check';
      END IF;
  END;
  $$ LANGUAGE plpgsql;