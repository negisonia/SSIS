DROP TABLE IF EXISTS log_etl_validation_process;
DROP TABLE IF EXISTS log_etl_validation_process_test_execution;
DROP TABLE IF EXISTS log_etl_validation_process_errors;

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
    total_succeded_test_cases integer,
    total_failed_test_cases integer,
    status character varying(255)
  );

CREATE TABLE log_etl_validation_process_test_execution
  (
    id serial NOT NULL,
    log_etl_validation_process_id integer NOT NULL,
    test_case_name varchar NOT NULL,
    project_name varchar NOT NULL,
    status varchar NOT NULL,
    error_log text,
    created_at timestamp without time zone
  );

CREATE TABLE log_etl_validation_process_errors
(
   id serial NOT NULL,
   log_etl_validation_process_id integer NOT NULL,
   error_log text,
   created_at timestamp without time zone
);
