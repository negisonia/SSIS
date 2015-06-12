﻿--===================SETUP SCHEMA===========================
CREATE SCHEMA IF NOT EXISTS ff; -- Foreign ff_new

--===================SETUP FOREIGN DATA WRAPPER===========================
DROP USER MAPPING IF EXISTS FOR postgres SERVER foreign_ff_new;
DROP SERVER IF EXISTS  foreign_ff_new CASCADE;

--===================CREATE SERVER===========================

CREATE SERVER foreign_ff_new FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '172.17.66.124', dbname 'ff_new', port '5432');
CREATE USER MAPPING FOR postgres SERVER foreign_ff_new OPTIONS (user 'restrictions20', password 'ooJaGhee6Rahxeb0fiez'); 


--===================LINK FF_NEW TABLES===========================

--health_plans
CREATE FOREIGN TABLE IF NOT EXISTS ff.health_plans_import
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


--health_plan_types
		CREATE FOREIGN TABLE ff.health_plan_types_import
		(
		  id integer NOT NULL ,
		  is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
		  --name character varying(255) NOT NULL,
		  name character varying(255)  OPTIONS (column_name 'webname') NOT NULL
		  -- explanationtext text,
		  -- iscommercial boolean NOT NULL,
		  -- ismedicare boolean NOT NULL,
		  -- health_plan_type_group_id integer,
		  -- health_plan_type_aggregate_id integer
		)
		SERVER foreign_ff_new
		OPTIONS (schema_name 'public', table_name 'healthplantype');  


--drugs
CREATE FOREIGN TABLE IF NOT EXISTS ff.drugs_import
	(
	  id integer NOT NULL ,
	  is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
	  -- isgeneric boolean NOT NULL,
	  -- name character varying(255) NOT NULL ,
	  -- chemicalname character varying(255) NOT NULL,
	  name character varying(255)  OPTIONS (column_name 'webname')
	  -- rewritename character varying(255) NOT NULL,
	  -- bookname character varying(255),
	  -- manufacturerfid integer,
	  -- genericdrugfid integer,
	  -- informationurl character varying(255),
	  -- fdaverifydate timestamp without time zone,
	  -- legacyfid integer,
	  -- createtimestamp timestamp without time zone NOT NULL DEFAULT now(),
	  -- lastupdate timestamp without time zone,
	  -- lastupdateffuserfid integer,
	  -- displayid integer NOT NULL DEFAULT 0,
	  -- druglabelfid integer,
	  -- isfeatured integer NOT NULL DEFAULT 0,
	  -- is_multi_source integer NOT NULL DEFAULT 0,
	  -- strengths text,
	  -- notes text,
	  -- global_na_default boolean DEFAULT false,
	  -- is_medical_benefits boolean DEFAULT false,
	  -- is_injectable boolean DEFAULT false,
	  -- global_nc_rc_40_default boolean NOT NULL DEFAULT false,
	  -- is_pa_form boolean NOT NULL DEFAULT false
	)
SERVER foreign_ff_new
OPTIONS (schema_name 'public', table_name 'drug');  


--formularies

CREATE FOREIGN TABLE IF NOT EXISTS ff.formulary_import
	(
	  id integer NOT NULL ,
	  isactive boolean NOT NULL,
	  --defaultbrandtierfid integer,
	  --defaultgenerictierfid integer,
	  --updatefrequencymonths integer,
	  --lastupdate timestamp without time zone,
	  --lastupdateffuserfid integer,
	  --ppdapplies boolean NOT NULL DEFAULT false,
	  --publishuserfid integer,
	  --createtimestamp timestamp without time zone,
	  --modifytimestamp timestamp without time zone,
	  --t3_preferred integer DEFAULT 0,
	  preferred_brand_tier_id integer
	)
	SERVER foreign_ff_new
	OPTIONS (schema_name 'public', table_name 'formulary');  


	--tier
CREATE FOREIGN TABLE IF NOT EXISTS ff.tier_import
	(
	  id integer NOT NULL,
	  is_active boolean OPTIONS (column_name 'isactive') NOT NULL,
	  name character varying(255) NOT NULL,
	  abbreviation character varying(20) OPTIONS (column_name 'codename') NOT NULL,
	  explanation_text text OPTIONS (column_name 'explanationtext'),
	  ordering_index integer  OPTIONS (column_name 'orderindex') NOT NULL
	  -- legacyvalue integer
	)
	SERVER foreign_ff_new
	OPTIONS (schema_name 'public', table_name 'tier');  


--providers
		CREATE FOREIGN TABLE ff.providers_import
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

--formulary_details
CREATE FOREIGN TABLE dw.formulary_detail_source_import
		(
		  provider_id integer,
		  provider_name character varying(255),
		  health_plan_id integer,
		  health_plan_name character varying(255),
		  formulary_url character varying(500),
		  drug_id integer,
		  drug_name character varying(255),
		  health_plan_type_id integer,
		  health_plan_type_name character varying(255),
		  tier_id integer,
		  preferred_brand_tier_id integer,
		  has_quantity_limit boolean,
		  has_prior_authorization boolean,
		  has_step_therapy boolean,
		  has_other_restriction boolean,
		  has_pharmacy boolean,
		  has_medical boolean,
		  reason_code_id integer,
		  reason_code_code character varying(10),
		  reason_code_desc character varying(500)
		)
		SERVER foreign_data_warehouse
		OPTIONS (schema_name 'dw', table_name 'formulary_detail');  