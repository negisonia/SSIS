CREATE SERVER foreign_ff_new FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com', dbname 'sandbox_ff_new', port '5432');
CREATE USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (user 'postgres', password 'VsOCWIozIelwQcRgR4w3'); 

CREATE FOREIGN TABLE health_plan_import
(
  id integer NOT NULL,
  health_plan_type_id integer OPTIONS (column_name 'healthplantypefid'),
  is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
  -- name character varying(255) NOT NULL ,
  name character varying(255) OPTIONS (column_name 'webname') NOT NULL,
  -- rewritename character varying(255) NOT NULL,
  -- bookname character varying(255),
  formulary_url character varying(500) OPTIONS (column_name 'formularyurl'),
  formulary_id integer OPTIONS (column_name 'formularyfid'),
  -- comingsoon boolean NOT NULL DEFAULT false,
  -- legacyfid integer,
  provider_id integer OPTIONS (column_name 'providerfid'),
  -- createtimestamp timestamp without time zone,
  -- modifytimestamp timestamp without time zone,
  -- pbmhealthplanfid integer,
  -- displayid integer NOT NULL DEFAULT 0,
  qualifier_url character varying(500)  OPTIONS (column_name 'qualifierurl')
  -- comingformularyfid integer,
  -- comingformularydate timestamp without time zone,
  -- pbmlastupdated timestamp without time zone,
  -- comingformularynote character varying(250),
  -- formularycopy integer NOT NULL DEFAULT 0,
  -- assignment_comment text,
  -- formularyname character varying(255),
  -- tiers integer,
  -- tierstructure character varying(255),
  -- ptdates character varying(255),
  -- ptmembers character varying(255),
  -- ptcomments character varying(255),
  -- corporatestructure integer,
  -- county_url character varying(500),
  -- county_comment text,
  -- existing_formularyfid integer,
  -- existing_comingformularyfid integer
)
SERVER foreign_ff_new
OPTIONS (schema_name 'public', table_name 'healthplan');

CREATE FOREIGN TABLE provider_import
(
  id integer NOT NULL ,
  is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
  --name character varying(255) NOT NULL,
  name character varying(255)  OPTIONS (column_name 'webname') NOT NULL
  -- suppressrollup integer NOT NULL DEFAULT 0,
  -- altwebname character varying(255) NOT NULL,
  -- parentsfid integer,
  -- corporatestructure integer,
  -- ptdates character varying(1000),
  -- ptmembers character varying(1000),
  -- ptcomments character varying(1000),
  -- top_provider boolean DEFAULT false,
  -- is_medical_benefits boolean DEFAULT false
)
SERVER foreign_ff_new
OPTIONS (schema_name 'public', table_name 'provider');
