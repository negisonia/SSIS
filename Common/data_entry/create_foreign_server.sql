CREATE SCHEMA ff; -- Foreign ff_new

CREATE EXTENSION postgres_fdw;

DROP USER MAPPING IF EXISTS FOR postgres SERVER foreign_ff_new;
DROP SERVER IF EXISTS foreign_ff_new;

CREATE SERVER foreign_ff_new FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com', dbname 'sandbox_ff_new', port '5432');
CREATE USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (user 'postgres', password 'VsOCWIozIelwQcRgR4w3');

--CREATE SERVER foreign_ff_new FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'sandbox_ff_new', port '5432');
--CREATE USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (user 'postgres', password 'clarodeluna');


CREATE FOREIGN TABLE ff.drugs_import
    (
      id integer NOT NULL ,
      is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
      name character varying(255)  OPTIONS (column_name 'webname')
    )
    SERVER foreign_ff_new
    OPTIONS (schema_name 'public', table_name 'drug');


CREATE FOREIGN TABLE ff.health_plan_types_import
        (
          id integer NOT NULL ,
          is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
          name character varying(255)  OPTIONS (column_name 'webname') NOT NULL
        )
        SERVER foreign_ff_new
        OPTIONS (schema_name 'public', table_name 'healthplantype');


CREATE FOREIGN TABLE ff.providers_import
        (
          id integer NOT NULL ,
          is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
          name character varying(255)  OPTIONS (column_name 'webname') NOT NULL
        )
        SERVER foreign_ff_new
        OPTIONS (schema_name 'public', table_name 'provider');

CREATE FOREIGN TABLE ff.drug_classes_import
        (
          id integer NOT NULL ,
          is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
          name character varying(255)  OPTIONS (column_name 'webname') NOT NULL
        )
        SERVER foreign_ff_new
        OPTIONS (schema_name 'public', table_name 'drugclass');

CREATE FOREIGN TABLE ff.drug_classes_drugs_import
    (
      id integer NOT NULL,
      drug_id integer OPTIONS (column_name 'drugfid') NOT NULL,
      drug_class_id integer  OPTIONS (column_name 'drugclassfid') NOT NULL
    )
    SERVER foreign_ff_new
    OPTIONS (schema_name 'public', table_name 'drugdrugclass');