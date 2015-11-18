--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

CREATE ROLE r2de WITH PASSWORD 'postgres';

--
-- Name: super_copy(integer); Type: FUNCTION; Schema: public; Owner: r2de
--

CREATE FUNCTION super_copy(_copy_log_id integer) RETURNS TABLE(status integer, message text, processed_copy_log_ids text)
    LANGUAGE plpgsql
    AS $$ 
  DECLARE
    _clause_copy_log_id text := '';
    _processed_copy_log_ids text := '';
    _status_code integer;
    _delete_query text;
    _insert_query text;
    _copy_timestamp timestamp;
  BEGIN
    --Copy Log ID clause
    IF _copy_log_id IS NOT NULL
    THEN
      _clause_copy_log_id := ' AND id = '|| _copy_log_id;
    END IF;

    --Check if there is any task to run 
    EXECUTE 'SELECT string_agg(id::text, '','') FROM copy_logs WHERE status = 0'|| _clause_copy_log_id   
    INTO _processed_copy_log_ids;

    IF _processed_copy_log_ids IS NULL
    THEN
      _status_code := 0;
      RETURN QUERY SELECT _status_code AS status, 'No tasks to Run'::text AS message, ''::text AS processed_copy_logs;
      RETURN;      
    END IF;

    --Create active copy log temp table
    EXECUTE '
    DROP TABLE IF EXISTS temp_active_copy_log;
    CREATE TEMP TABLE temp_active_copy_log AS
    SELECT
      * 
    FROM
      copy_logs
    WHERE
      status = 0'|| _clause_copy_log_id ||';';

    --Check if there is any task already running for the same target
    EXECUTE 'SELECT 
              2::integer 
            FROM 
              copy_logs cl 
              INNER JOIN temp_active_copy_log acl ON acl.target_indication_id = cl.target_indication_id AND acl.target_healthplantype_id = cl.target_healthplantype_id
                                                  AND acl.target_provider_id = cl.target_provider_id AND cl.status = 1;'
    INTO _status_code;

    IF _status_code = 2 
    THEN
      RETURN QUERY SELECT _status_code AS status, 'There is already another tasks with same destination running'::text AS message, ''::text AS processed_copy_logs;
      RETURN;      
    END IF;

    --Update active tasks status to in progress 
    UPDATE
      copy_logs
    SET
      status = 1
    WHERE
      id IN
      (
        SELECT 
          id
        FROM
          temp_active_copy_log
      );

    --Update historical Dest Status to DONE
    UPDATE
      copy_logs
    SET
      status = 3
    WHERE
      id IN
      (
        SELECT 
          cl.id
        FROM
          copy_logs cl
          INNER JOIN temp_active_copy_log acl ON acl.target_indication_id = cl.target_indication_id AND acl.target_healthplantype_id = cl.target_healthplantype_id
                                            AND acl.target_provider_id = cl.target_provider_id AND cl.status NOT IN (0, 1, 3)
      );

    --===============================Main Queries=================================
    --Delete destination records
    _delete_query := '
      WITH target_data_entries AS
      ( 
        SELECT
          de.id,
          cl.copy_pa,
          cl.copy_st,
          cl.copy_medical,
          cl.copy_ql
        FROM
          data_entries de
          INNER JOIN temp_active_copy_log cl ON cl.target_indication_id = de.indication_id AND cl.target_healthplantype_id = de.healthplantype_id 
                                                AND cl.target_provider_id = de.provider_id
      ),
      clear_data_entries AS
      (
        UPDATE
          data_entries
        SET
          prior_authorization_id = CASE WHEN target_data_entries.copy_pa = true THEN NULL ELSE prior_authorization_id END,
          step_therapy_id = CASE WHEN target_data_entries.copy_st = true THEN NULL ELSE step_therapy_id END,
          medical_id = CASE WHEN target_data_entries.copy_medical = true THEN NULL ELSE medical_id END,
          quantity_limit_id = CASE WHEN target_data_entries.copy_ql = true THEN NULL ELSE quantity_limit_id END
        FROM
          target_data_entries
        WHERE
          data_entries.id = target_data_entries.id
      ),
      delete_data_entries_details AS
      ( 
        DELETE FROM 
          data_entries_details 
        WHERE
          id IN 
          (
            SELECT
              ded.id
            FROM
              data_entries_details ded
              INNER JOIN temp_active_copy_log cl ON cl.target_indication_id = ded.indication_id AND cl.target_healthplantype_id = ded.healthplantype_id AND cl.target_provider_id = ded.provider_id
          )
      ),
      delete_atomic_steps_notes AS
      (
        DELETE FROM
          atomic_steps_notes
        WHERE
          (
            de_type = ''PA'' 
            AND de_id IN 
                (
                  SELECT
                    id
                  FROM
                    target_data_entries
                  WHERE
                    copy_pa = true
                )
          )
          OR (
            de_type = ''ST'' 
            AND de_id IN 
                (
                  SELECT
                    id
                  FROM
                    target_data_entries
                  WHERE
                    copy_st = true
                )
          )
          OR (
            de_type = ''Medical'' 
            AND de_id IN 
                (
                  SELECT
                    id
                  FROM
                    target_data_entries
                  WHERE
                    copy_medical = true
                )
          ) 
      ),
      delete_pa AS
      ( DELETE FROM
          prior_authorizations
        WHERE 
          id IN
          (
            SELECT
              pa.id
            FROM
              prior_authorizations pa
              INNER JOIN temp_active_copy_log cl ON cl.target_indication_id = pa.indication_id AND cl.target_healthplantype_id = pa.healthplantype_id 
                                            AND cl.target_provider_id = pa.provider_id AND cl.copy_pa = true
          )
        RETURNING id
      ),
      delete_pa_criteria AS 
      (
        DELETE FROM
          prior_authorization_criteria
        WHERE
          id IN
          (
            SELECT
              pac.id
            FROM
              prior_authorization_criteria pac
              INNER JOIN delete_pa dp ON dp.id = pac.prior_authorization_id 
          )
      ),
      delete_st AS
      ( DELETE FROM
          step_therapies
        WHERE 
          id IN
          (
            SELECT
              st.id
            FROM
              step_therapies st
              INNER JOIN temp_active_copy_log cl ON cl.target_indication_id = st.indication_id AND cl.target_healthplantype_id = st.healthplantype_id 
                                            AND cl.target_provider_id = st.provider_id AND cl.copy_st = true
          )
        RETURNING id
      ),
      delete_medical AS
      ( DELETE FROM
          medicals
        WHERE 
          id IN
          (
            SELECT
              med.id
            FROM
              medicals med
              INNER JOIN temp_active_copy_log cl ON cl.target_indication_id = med.indication_id AND cl.target_healthplantype_id = med.healthplantype_id 
                                            AND cl.target_provider_id = med.provider_id AND cl.copy_medical = true
          )
        RETURNING id
      ),
      delete_medical_criteria AS 
      (
        DELETE FROM
          medical_criteria
        WHERE
          id IN
          (
            SELECT
              mac.id
            FROM
              medical_criteria mac
              INNER JOIN delete_medical dm ON dm.id = mac.medical_id 
          )
      ),
      delete_ql AS
      ( DELETE FROM
          quantity_limits
        WHERE 
          id IN
          (
            SELECT
              ql.id
            FROM
              quantity_limits ql
              INNER JOIN temp_active_copy_log cl ON cl.target_indication_id = ql.indication_id AND cl.target_healthplantype_id = ql.healthplantype_id 
                                            AND cl.target_provider_id = ql.provider_id AND cl.copy_ql = true
          )
        RETURNING id
      ),
      delete_ql_criteria AS 
      (
        DELETE FROM
          quantity_limit_criteria
        WHERE
          id IN
          (
            SELECT
              qlc.id
            FROM
              quantity_limit_criteria qlc
              INNER JOIN delete_ql dq ON dq.id = qlc.quantity_limit_id 
          )
      )
      SELECT 1;
    ';

    RAISE INFO 'Query:  EXPLAIN ANALYZE VERBOSE  %', _delete_query;

    EXECUTE _delete_query INTO _status_code;

    IF _status_code != 1
    THEN
      RETURN QUERY SELECT -1 AS status, 'Fail to delete destination records!'::text AS message, ''::text AS processed_copy_log_ids;
      RETURN;      
    END IF;

    --Copy Records Over to destinations
    _copy_timestamp := clock_timestamp();
    
    DROP TABLE IF EXISTS temp_data_entry_restrictions;
    CREATE TEMP TABLE temp_data_entry_restrictions 
    (
      data_entry_id integer,
      prior_authorization_id integer,
      step_therapy_id integer,
      medical_id integer,
      quantity_limit_id integer
    );

    _insert_query := '
    WITH 
      active_copy_task AS
      (
        SELECT
          cl.source_indication_id,
          cl.source_healthplantype_id,
          cl.source_provider_id,
          cl.target_indication_id,
          cl.target_healthplantype_id,
          cl.target_provider_id,
          cl.target_comments,
          bool_or(coalesce(cl.copy_pa, false) AND coalesce(mv.has_prior_authorization, false)) AS copy_pa,
          bool_or(coalesce(cl.copy_st, false) AND coalesce(mv.has_step_therapy, false)) AS copy_st,
          bool_or(coalesce(cl.copy_ql, false) AND coalesce(mv.has_quantity_limit, false)) AS copy_ql,
          bool_or(coalesce(cl.copy_medical, false) AND coalesce(mv.reason_code_id, 0) IN (23, 25, 26)) AS copy_medical,
          di.drug_id
        FROM
          temp_active_copy_log cl
          INNER JOIN drug_indications di ON di.indication_id = cl.target_indication_id
          INNER JOIN ff_new.healthplan hp ON hp.providerfid = cl.target_provider_id AND hp.healthplantypefid = cl.target_healthplantype_id
          INNER JOIN ff_new.mv_active_formularies mv ON mv.formulary_id = hp.formularyfid AND mv.drug_id = di.drug_id 
                                                  AND (
                                                        (cl.copy_pa AND mv.has_prior_authorization) OR (cl.copy_st AND mv.has_step_therapy)
                                                        OR(cl.copy_ql AND mv.has_quantity_limit) OR (cl.copy_medical AND mv.reason_code_id IN (23, 25, 26))
                                                      )
        GROUP BY
          cl.source_indication_id,
          cl.source_healthplantype_id,
          cl.source_provider_id,
          cl.target_indication_id,
          cl.target_healthplantype_id,
          cl.target_provider_id,
          cl.target_comments,
          di.drug_id
      ),
      source_data_entries AS 
      (
        SELECT
          de.id,
          de.indication_id,
          de.provider_id,
          de.healthplantype_id,
          de.coverage_id,
          de.drug_id,
          de.coverage_limit_id,
          de.prior_authorization_id,
          de.quantity_limit_id,
          de.other_restriction_id,
          de.step_therapy_id,
          de.medical_id,
          act.target_indication_id AS new_indication_id,
          act.target_provider_id AS new_provider_id,
          act.target_healthplantype_id AS new_healthplantype_id,
          coalesce(act.copy_pa, false) AND de.prior_authorization_id IS NOT NULL AS copy_pa,
          coalesce(act.copy_st, false) AND de.step_therapy_id IS NOT NULL AS copy_st,
          coalesce(act.copy_ql, false) AND de.quantity_limit_id IS NOT NULL AS copy_ql,
          coalesce(act.copy_medical, false) AND de.medical_id IS NOT NULL AS copy_medical
        FROM
          data_entries de
          INNER JOIN active_copy_task act ON act.source_indication_id = de.indication_id AND act.source_healthplantype_id = de.healthplantype_id 
                                          AND act.source_provider_id = de.provider_id AND act.drug_id = de.drug_id
                                          AND (
                                                (act.copy_pa = true AND de.prior_authorization_id IS NOT NULL) OR (act.copy_st = true AND de.step_therapy_id IS NOT NULL)
                                                OR (act.copy_ql = true AND de.quantity_limit_id IS NOT NULL) OR (act.copy_medical = true AND de.medical_id IS NOT NULL)
                                              )
      ),
      --===Data Entries
      new_data_entries AS
      (
        INSERT INTO
          data_entries (id, indication_id, provider_id, healthplantype_id, drug_id, created_at, updated_at, copiedfromid)
        SELECT
          nextval(''data_entries_id_seq''::regclass) AS id, 
          sde.new_indication_id AS indication_id, 
          sde.new_provider_id AS provider_id, 
          sde.new_healthplantype_id AS healthplantype_id,
          sde.drug_id, 
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at, 
          sde.id AS copiedfromid 
        FROM
          source_data_entries sde
          LEFT JOIN data_entries de ON de.indication_id = sde.new_indication_id AND de.healthplantype_id = sde.new_healthplantype_id 
                                    AND de.provider_id = sde.new_provider_id AND de.drug_id = sde.drug_id
        WHERE
          de.id IS NULL
        RETURNING *
      ),
      update_data_entries AS
      (
        UPDATE
          data_entries
        SET
          copiedfromid = source_data_entries.id,
          updated_at = ''' || _copy_timestamp || '''::timestamp
        FROM
          source_data_entries
        WHERE
          data_entries.indication_id = source_data_entries.new_indication_id AND data_entries.healthplantype_id = source_data_entries.new_healthplantype_id 
                                    AND data_entries.provider_id = source_data_entries.new_provider_id AND data_entries.drug_id = source_data_entries.drug_id
        RETURNING data_entries.*
      ),
      source_data_entries_with_new_id AS
      ( 
        SELECT
          sde.*, 
          nde.id AS new_data_entry_id
        FROM
          source_data_entries sde 
          INNER JOIN new_data_entries nde ON sde.id = nde.copiedfromid AND sde.new_indication_id = nde.indication_id 
                                          AND sde.new_provider_id = nde.provider_id AND sde.new_healthplantype_id = nde.healthplantype_id AND nde.drug_id = sde.drug_id
        UNION
        SELECT
          sde.*,
          ude.id AS new_data_entry_id
        FROM
          source_data_entries sde
          INNER JOIN update_data_entries ude ON ude.indication_id = sde.new_indication_id AND ude.healthplantype_id = sde.new_healthplantype_id 
                                        AND ude.provider_id = sde.new_provider_id AND ude.drug_id = sde.drug_id
      ),
      --===Data Entries Details
      new_data_entries_details AS
      (
        INSERT INTO
          data_entries_details (id, indication_id, provider_id, healthplantype_id, internal_comments, source_comments, display_summary, created_at, updated_at, copiedfromid)
        SELECT
          nextval(''data_entries_details_id_seq''::regclass) AS id,
          cl.target_indication_id AS indication_id,
          cl.target_provider_id AS provider_id,
          cl.target_healthplantype_id AS healthplantype_id,
          NULL AS internal_comments,
          ded.source_comments,
          ded.display_summary,
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at, 
          ded.id AS copiedfromid          
        FROM
          data_entries_details ded
          INNER JOIN temp_active_copy_log cl ON cl.source_indication_id = ded.indication_id AND cl.source_provider_id = ded.provider_id AND cl.source_healthplantype_id = ded.healthplantype_id
      ),
      --== Atomic Steps Notes
      new_atomic_steps_notes AS
      ( INSERT INTO
          atomic_steps_notes (de_id, de_type, step_custom_option_name, position, notes, step_custom_option_id)
        SELECT
          sde.new_data_entry_id AS de_id,
          asn.de_type,
          asn.step_custom_option_name,
          asn.position,
          asn.notes,
          asn.step_custom_option_id
        FROM
          atomic_steps_notes asn
          INNER JOIN source_data_entries_with_new_id sde ON sde.id = asn.de_id AND ((sde.copy_pa = true AND asn.de_type = ''PA'') 
                                                        OR (sde.copy_st = true AND asn.de_type = ''ST'') OR (sde.copy_medical = true AND asn.de_type = ''Medical''))  
      ),
      --== PA
      new_pa AS
      (
        INSERT INTO
          prior_authorizations (id, date_of_policy, pa_duration, drug_id, data_entry_id, created_at, updated_at, indication_id, 
                                provider_id, healthplantype_id, boolean_expression_tree, duration_unit, active, is_active, copiedfromid, atomic_step_id)
        SELECT  
          nextval(''prior_authorizations_id_seq''::regclass) AS id,
          pa.date_of_policy,
          pa.pa_duration,
          pa.drug_id,
          sde.new_data_entry_id AS data_entry_id,
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at, 
          sde.new_indication_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          pa.boolean_expression_tree,
          pa.duration_unit,
          pa.active,
          pa.is_active,
          pa.id AS copiedfromid,
          pa.atomic_step_id
        FROM
          prior_authorizations pa
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = pa.indication_id AND sde.drug_id = pa.drug_id AND sde.healthplantype_id = pa.healthplantype_id 
                                            AND sde.provider_id = pa.provider_id AND pa.is_active = true AND sde.copy_pa = true 
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== PA Criteria
      new_pa_criteria AS
      (
        INSERT INTO
          prior_authorization_criteria (value_upper, value_lower, non_fda_approved, created_at, updated_at, prior_authorization_id, criterium_id, criterium_applicable, active,
                                        is_active, copiedfromid, notes)
        SELECT
          pac.value_upper,
          pac.value_lower,
          pac.non_fda_approved,
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at,          
          np.id AS prior_authorization_id,
          pac.criterium_id,
          pac.criterium_applicable,
          pac.active,
          pac.is_active,
          pac.id AS copiedfromid,
          pac.notes
        FROM
          prior_authorization_criteria pac
          INNER JOIN new_pa np ON np.copiedfromid = pac.prior_authorization_id AND pac.is_active = true
      ),
      --== ST
      new_st AS
      (
        INSERT INTO
          step_therapies (indication_id, drug_id, data_entry_id, provider_id, healthplantype_id, created_at, updated_at, boolean_expression_tree, is_active, copiedfromid, atomic_step_id)
        SELECT
          sde.new_indication_id,
          st.drug_id,
          sde.new_data_entry_id AS data_entry_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at, 
          st.boolean_expression_tree,
          st.is_active,
          st.id AS copiedfromid,
          st.atomic_step_id
        FROM
          step_therapies st
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = st.indication_id AND sde.drug_id = st.drug_id AND sde.healthplantype_id = st.healthplantype_id 
                                            AND sde.provider_id = st.provider_id AND st.is_active = true AND sde.copy_st = true 
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== Medical
      new_medical AS
      (
        INSERT INTO
          Medicals (date_of_policy, medical_duration, drug_id, data_entry_id, created_at, updated_at, indication_id, 
                                provider_id, healthplantype_id, boolean_expression_tree, duration_unit, active, is_active, copiedfromid, atomic_step_id)
        SELECT  
          med.date_of_policy,
          med.medical_duration,
          med.drug_id,
          sde.new_data_entry_id AS data_entry_id,
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at, 
          sde.new_indication_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          med.boolean_expression_tree,
          med.duration_unit,
          med.active,
          med.is_active,
          med.id AS copiedfromid,
          med.atomic_step_id
        FROM
          medicals med
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = med.indication_id AND sde.drug_id = med.drug_id AND sde.healthplantype_id = med.healthplantype_id 
                                            AND sde.provider_id = med.provider_id AND med.is_active = true AND sde.copy_medical = true 
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== Medical Criteria
      new_medical_criteria AS
      (
        INSERT INTO
          medical_criteria (value_upper, value_lower, non_fda_approved, created_at, updated_at, medical_id, criterium_id, criterium_applicable, active,
                                        is_active, copiedfromid, notes)
        SELECT
          mec.value_upper,
          mec.value_lower,
          mec.non_fda_approved,
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at,          
          nm.id AS medical_id,
          mec.criterium_id,
          mec.criterium_applicable,
          mec.active,
          mec.is_active,
          mec.id AS copiedfromid,
          mec.notes
        FROM
          medical_criteria mec
          INNER JOIN new_medical nm ON nm.copiedfromid = mec.medical_id AND mec.is_active = true
      ),
      --== QL
      new_ql AS
      (
        INSERT INTO
          quantity_limits (created_at, updated_at, data_entry_id, drug_id, indication_id, provider_id, healthplantype_id, is_active, copiedfromid) 
        SELECT
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at, 
          sde.new_data_entry_id AS data_entry_id,
          ql.drug_id,
          sde.new_indication_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          ql.is_active,
          ql.id AS copiedfromid
        FROM
          quantity_limits ql
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = ql.indication_id AND sde.drug_id = ql.drug_id AND sde.healthplantype_id = ql.healthplantype_id 
                                            AND sde.provider_id = ql.provider_id AND ql.is_active = true AND sde.copy_ql = true 
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== ql Criteria
      new_ql_criteria AS
      (
        INSERT INTO
          quantity_limit_criteria (created_at, updated_at, criterium_id, quantity_limit_id, active, amount_val, time_val, amount_type, time_type,
                                  is_active, copiedfromid, notes)
        SELECT
          ''' || _copy_timestamp || '''::timestamp AS created_at, 
          ''' || _copy_timestamp || '''::timestamp AS updated_at,          
          qlc.criterium_id,
          nq.id AS quantity_limit_id,
          qlc.active,
          qlc.amount_val,
          qlc.time_val,
          qlc.amount_type,
          qlc.time_type,
          qlc.is_active,
          qlc.id AS copiedfromid,
          qlc.notes
        FROM
          quantity_limit_criteria qlc
          INNER JOIN new_ql nq ON nq.copiedfromid = qlc.quantity_limit_id AND qlc.is_active = true
      )
      INSERT INTO 
        temp_data_entry_restrictions (data_entry_id, prior_authorization_id, step_therapy_id, medical_id, quantity_limit_id)
      SELECT
        dr.data_entry_id, max(dr.prior_authorization_id), max(step_therapy_id), max(medical_id), max(quantity_limit_id)
      FROM
        (
          SELECT
            data_entry_id, id AS prior_authorization_id, NULL::integer AS step_therapy_id, NULL::integer AS medical_id, NULL::integer AS quantity_limit_id
          FROM
            new_pa
          UNION
          SELECT
            data_entry_id, NULL::integer AS prior_authorization_id, id AS step_therapy_id, NULL::integer AS medical_id, NULL::integer AS quantity_limit_id
          FROM 
            new_st
          UNION
          SELECT
            data_entry_id, NULL::integer AS prior_authorization_id, NULL::integer AS step_therapy_id, id AS medical_id, NULL::integer AS quantity_limit_id
          FROM 
            new_medical
          UNION
          SELECT
            data_entry_id, NULL::integer AS prior_authorization_id, NULL::integer AS step_therapy_id, NULL::integer AS medical_id, id AS quantity_limit_id
          FROM 
            new_ql
        ) dr
      GROUP BY
        dr.data_entry_id;
      ;
    ';
    
    RAISE INFO 'Query:  EXPLAIN ANALYZE VERBOSE  %', _insert_query;

    EXECUTE _insert_query;

    --Fill Restriction IDs to DataEntery Records
    UPDATE
      data_entries de
    SET
      prior_authorization_id = CASE WHEN dr.prior_authorization_id IS NOT NULL THEN dr.prior_authorization_id ELSE de.prior_authorization_id END, 
      step_therapy_id = CASE WHEN dr.step_therapy_id IS NOT NULL THEN dr.step_therapy_id ELSE de.step_therapy_id END, 
      medical_id = CASE WHEN dr.medical_id IS NOT NULL THEN dr.medical_id ELSE de.medical_id END, 
      quantity_limit_id = CASE WHEN dr.quantity_limit_id IS NOT NULL THEN dr.quantity_limit_id ELSE de.quantity_limit_id END
    FROM
      temp_data_entry_restrictions dr
    WHERE
      de.id = dr.data_entry_id;

    --Delete DataEntry Records without any Restrictions
    DELETE FROM
      data_entries
    WHERE
      prior_authorization_id IS NULL AND step_therapy_id IS NULL AND medical_id IS NULL AND quantity_limit_id IS NULL;

    --Change log status from 1 in progress to 2 need review or 3 done
    UPDATE 
      copy_logs 
    SET status = 
        CASE 
          WHEN need_review = true THEN 2 
          ELSE 3 
        END 
    WHERE
      id IN 
      (
        SELECT
          id
        FROM
          temp_active_copy_log
      );

    RETURN QUERY SELECT 1 AS status, 'Successful'::text AS message, _processed_copy_log_ids AS processed_copy_log_ids;

  END;
  $$;


ALTER FUNCTION public.super_copy(_copy_log_id integer) OWNER TO r2de;

--
-- Name: super_copy_single(integer, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: r2de
--

CREATE FUNCTION super_copy_single(_copy_log_id integer, _start_timestamp timestamp without time zone, _user_id integer) RETURNS TABLE(status integer, message text, copy_log_status integer)
    LANGUAGE plpgsql
    AS $$
  DECLARE
    --_clause_copy_log_id text := '';
    _processed_copy_log_ids text := '';
    _status_code integer;

    _source_indication_id integer;
    _source_healthplantype_id integer;
    _source_provider_id integer;
    _target_indication_id integer;
    _target_healthplantype_id integer;
    _target_provider_id integer;
    _copy_pa boolean;
    _copy_st boolean;
    _copy_ql boolean;
    _copy_medical boolean;
    _need_review boolean;

    _copy_log_status_code integer;
  BEGIN
    --Check if copy log id is null
    IF _copy_log_id IS NULL
    THEN
      _status_code := -1;
      RETURN QUERY SELECT _status_code AS status, 'Copy Log ID unspecified!'::text AS message, NULL::integer AS copy_log_status;
      RETURN;
    END IF;

    --Retrieve variables Check if there is any task to run
    SELECT INTO _source_indication_id, _source_healthplantype_id, _source_provider_id, _target_indication_id, _target_healthplantype_id, _target_provider_id, _copy_pa, _copy_st, _copy_medical, _copy_ql, _need_review
      source_indication_id, source_healthplantype_id, source_provider_id, target_indication_id, target_healthplantype_id, target_provider_id, copy_pa, copy_st, copy_medical, copy_ql, need_review
    FROM
      copy_logs
    WHERE
      (copy_logs.status = 0 OR (copy_logs.status = 1 AND started_at IS NULL)) AND id = _copy_log_id;

    IF _source_indication_id IS NULL
    THEN
      _status_code := 0;
      RETURN QUERY SELECT _status_code AS status, 'No tasks to Run'::text AS message, NULL::integer AS copy_log_status;
      RETURN;
    END IF;

    --Check if there is any task already running with destination/source conflicts
    IF EXISTS (
        SELECT
          *
        FROM
          copy_logs
        WHERE
          ((target_indication_id = _target_indication_id AND target_healthplantype_id = _target_healthplantype_id AND target_provider_id = _target_provider_id)
          OR (target_indication_id = _source_indication_id AND target_healthplantype_id = _source_healthplantype_id AND target_provider_id = _source_provider_id))
          AND copy_logs.status = 1 AND started_at IS NOT NULL AND id != _copy_log_id
    )
    THEN
      RETURN QUERY SELECT -1 AS status, 'Another tasks with destination or source conflicts are running'::text AS message, NULL::integer AS copy_log_status;
      RETURN;
    END IF;

    --Update active tasks status to in progress
    UPDATE
      copy_logs
    SET
      status = 1,
      started_at = _start_timestamp,
      run_by = _user_id
    WHERE
      id = _copy_log_id;

    --Update historical Dest Status to DONE
    UPDATE
      copy_logs
    SET
      status = 3
    WHERE
      target_indication_id = _target_indication_id AND target_healthplantype_id = _target_healthplantype_id
      AND target_provider_id = _target_provider_id AND copy_logs.status NOT IN (0, 1, 3);

    --===============================Main Queries=================================
    --Delete destination records
    DROP TABLE IF EXISTS temp_target_data_entries;
    CREATE TEMP TABLE temp_target_data_entries
    (
      data_entry_id integer
    );

    WITH target_data_entries AS
    (
      SELECT
        id
      FROM
        data_entries
      WHERE
        indication_id = _target_indication_id AND healthplantype_id = _target_healthplantype_id AND provider_id = _target_provider_id
    ),
    clear_data_entries AS
    (
      UPDATE
        data_entries
      SET
        prior_authorization_id = CASE WHEN _copy_pa = true THEN NULL ELSE prior_authorization_id END,
        step_therapy_id = CASE WHEN _copy_st = true THEN NULL ELSE step_therapy_id END,
        medical_id = CASE WHEN _copy_medical = true THEN NULL ELSE medical_id END,
        quantity_limit_id = CASE WHEN _copy_ql = true THEN NULL ELSE quantity_limit_id END
      FROM
        target_data_entries
      WHERE
        data_entries.id = target_data_entries.id
    ),
    delete_data_entries_details AS
    (
      DELETE FROM
        data_entries_details
      WHERE
        indication_id = _target_indication_id AND healthplantype_id = _target_healthplantype_id AND provider_id = _target_provider_id
    ),
    delete_atomic_steps_notes AS
    (
      DELETE FROM
        atomic_steps_notes
      WHERE
        de_id IN
        (
          SELECT
            id
          FROM
            target_data_entries
        )
        AND
        (
          (de_type = 'PA' AND _copy_pa = true)
          OR (de_type = 'ST' AND _copy_st = true)
          OR (de_type = 'Medical' AND _copy_medical = true)
        )
    )
    INSERT INTO
      temp_target_data_entries
    SELECT
      id
    FROM
      target_data_entries;

    IF _copy_pa = true
    THEN
      WITH delete_pa AS
      ( DELETE FROM
          prior_authorizations
        WHERE
          indication_id = _target_indication_id AND healthplantype_id = _target_healthplantype_id AND provider_id = _target_provider_id
        RETURNING id
      )
      DELETE FROM
        prior_authorization_criteria
      WHERE
        id IN
        (
          SELECT
            pac.id
          FROM
            prior_authorization_criteria pac
            INNER JOIN delete_pa dp ON dp.id = pac.prior_authorization_id
        );
    END IF;


    IF _copy_st = true
    THEN
      DELETE FROM
        step_therapies
      WHERE
        indication_id = _target_indication_id AND healthplantype_id = _target_healthplantype_id AND provider_id = _target_provider_id;
    END IF;

    IF _copy_medical = true
    THEN
      WITH delete_medical AS
      ( DELETE FROM
          medicals
        WHERE
          indication_id = _target_indication_id AND healthplantype_id = _target_healthplantype_id AND provider_id = _target_provider_id
        RETURNING id
      )
      DELETE FROM
        medical_criteria
      WHERE
        id IN
        (
          SELECT
            mac.id
          FROM
            medical_criteria mac
            INNER JOIN delete_medical dm ON dm.id = mac.medical_id
        );
    END IF;

    IF _copy_ql = true
    THEN
      WITH delete_ql AS
      ( DELETE FROM
          quantity_limits
        WHERE
          indication_id = _target_indication_id AND healthplantype_id = _target_healthplantype_id AND provider_id = _target_provider_id
        RETURNING id
      )
      DELETE FROM
        quantity_limit_criteria
      WHERE
        id IN
        (
          SELECT
            qlc.id
          FROM
            quantity_limit_criteria qlc
            INNER JOIN delete_ql dq ON dq.id = qlc.quantity_limit_id
        );
    END IF;

    DROP TABLE IF EXISTS temp_data_entry_restrictions;
    CREATE TEMP TABLE temp_data_entry_restrictions
    (
      data_entry_id integer,
      prior_authorization_id integer,
      step_therapy_id integer,
      medical_id integer,
      quantity_limit_id integer
    );

    --Main Copy query
    WITH
      active_copy_task AS
      (
        SELECT
          di.drug_id,
          bool_or(coalesce(_copy_pa, false) AND (coalesce(mv.has_prior_authorization, false) OR coalesce(mv.reason_code_id, 0) IN (5, 6, 84))) AS copy_pa,
          bool_or(coalesce(_copy_st, false) AND coalesce(mv.has_step_therapy, false)) AS copy_st,
          bool_or(coalesce(_copy_ql, false) AND coalesce(mv.has_quantity_limit, false)) AS copy_ql,
          bool_or(coalesce(_copy_medical, false) AND coalesce(mv.reason_code_id, 0) IN (23, 25, 26)) AS copy_medical
        FROM
          drug_indications di
          INNER JOIN ff_new.healthplan hp ON hp.providerfid = _target_provider_id AND hp.healthplantypefid = _target_healthplantype_id AND di.indication_id = _target_indication_id
          INNER JOIN ff_new.mv_active_formularies mv ON mv.formulary_id = hp.formularyfid AND mv.drug_id = di.drug_id
                                                  AND (
                                                        (_copy_pa AND (mv.has_prior_authorization OR coalesce(mv.reason_code_id, 0) IN (5, 6, 84))) OR (_copy_st AND mv.has_step_therapy)
                                                        OR(_copy_ql AND mv.has_quantity_limit) OR (_copy_medical AND mv.reason_code_id IN (23, 25, 26))
                                                      )
        GROUP BY
          di.drug_id
      ),
      source_data_entries AS
      (
        SELECT
          de.id,
          de.indication_id,
          de.provider_id,
          de.healthplantype_id,
          de.coverage_id,
          de.drug_id,
          de.coverage_limit_id,
          de.prior_authorization_id,
          de.quantity_limit_id,
          de.other_restriction_id,
          de.step_therapy_id,
          de.medical_id,
          _target_indication_id AS new_indication_id,
          _target_provider_id AS new_provider_id,
          _target_healthplantype_id AS new_healthplantype_id,
          coalesce(act.copy_pa, false) AND de.prior_authorization_id IS NOT NULL AS copy_pa,
          coalesce(act.copy_st, false) AND de.step_therapy_id IS NOT NULL AS copy_st,
          coalesce(act.copy_ql, false) AND de.quantity_limit_id IS NOT NULL AS copy_ql,
          coalesce(act.copy_medical, false) AND de.medical_id IS NOT NULL AS copy_medical
        FROM
          data_entries de
          INNER JOIN active_copy_task act ON de.indication_id = _source_indication_id AND de.healthplantype_id = _source_healthplantype_id
                                          AND de.provider_id = _source_provider_id AND act.drug_id = de.drug_id
                                          AND (
                                                (act.copy_pa = true AND de.prior_authorization_id IS NOT NULL) OR (act.copy_st = true AND de.step_therapy_id IS NOT NULL)
                                                OR (act.copy_ql = true AND de.quantity_limit_id IS NOT NULL) OR (act.copy_medical = true AND de.medical_id IS NOT NULL)
                                              )
      ),
      --===Data Entries
      new_data_entries AS
      (
        INSERT INTO
          data_entries (id, indication_id, provider_id, healthplantype_id, drug_id, created_at, updated_at, copiedfromid)
        SELECT
          nextval('data_entries_id_seq'::regclass) AS id,
          sde.new_indication_id AS indication_id,
          sde.new_provider_id AS provider_id,
          sde.new_healthplantype_id AS healthplantype_id,
          sde.drug_id,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          sde.id AS copiedfromid
        FROM
          source_data_entries sde
          LEFT JOIN data_entries de ON de.indication_id = sde.new_indication_id AND de.healthplantype_id = sde.new_healthplantype_id
                                    AND de.provider_id = sde.new_provider_id AND de.drug_id = sde.drug_id
        WHERE
          de.id IS NULL
        RETURNING *
      ),
      update_data_entries AS
      (
        UPDATE
          data_entries
        SET
          copiedfromid = source_data_entries.id,
          updated_at = _start_timestamp::timestamp
        FROM
          source_data_entries
        WHERE
          data_entries.indication_id = source_data_entries.new_indication_id AND data_entries.healthplantype_id = source_data_entries.new_healthplantype_id
                                    AND data_entries.provider_id = source_data_entries.new_provider_id AND data_entries.drug_id = source_data_entries.drug_id
        RETURNING data_entries.*
      ),
      source_data_entries_with_new_id AS
      (
        SELECT
          sde.*,
          nde.id AS new_data_entry_id
        FROM
          source_data_entries sde
          INNER JOIN new_data_entries nde ON sde.id = nde.copiedfromid AND sde.new_indication_id = nde.indication_id
                                          AND sde.new_provider_id = nde.provider_id AND sde.new_healthplantype_id = nde.healthplantype_id AND nde.drug_id = sde.drug_id
        UNION
        SELECT
          sde.*,
          ude.id AS new_data_entry_id
        FROM
          source_data_entries sde
          INNER JOIN update_data_entries ude ON ude.indication_id = sde.new_indication_id AND ude.healthplantype_id = sde.new_healthplantype_id
                                        AND ude.provider_id = sde.new_provider_id AND ude.drug_id = sde.drug_id
      ),
      --===Data Entries Details
      new_data_entries_details AS
      (
        INSERT INTO
          data_entries_details (id, indication_id, provider_id, healthplantype_id, source_comments, display_summary, created_at, updated_at, copiedfromid)
        SELECT
          nextval('data_entries_details_id_seq'::regclass) AS id,
          _target_indication_id AS indication_id,
          _target_provider_id AS provider_id,
          _target_healthplantype_id AS healthplantype_id,
          source_comments,
          display_summary,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          id AS copiedfromid
        FROM
          data_entries_details
        WHERE
          indication_id = _source_indication_id AND healthplantype_id = _source_healthplantype_id AND provider_id = _source_provider_id
      ),
      --== Atomic Steps Notes
      new_atomic_steps_notes AS
      ( INSERT INTO
          atomic_steps_notes (de_id, de_type, step_custom_option_name, position, notes, step_custom_option_id)
        SELECT
          sde.new_data_entry_id AS de_id,
          asn.de_type,
          asn.step_custom_option_name,
          asn.position,
          asn.notes,
          asn.step_custom_option_id
        FROM
          atomic_steps_notes asn
          INNER JOIN source_data_entries_with_new_id sde ON sde.id = asn.de_id AND ((sde.copy_pa = true AND asn.de_type = 'PA')
                                                        OR (sde.copy_st = true AND asn.de_type = 'ST') OR (sde.copy_medical = true AND asn.de_type = 'Medical'))
      ),
      --== PA
      new_pa AS
      (
        INSERT INTO
          prior_authorizations (id, date_of_policy, pa_duration, drug_id, data_entry_id, created_at, updated_at, indication_id,
                                provider_id, healthplantype_id, boolean_expression_tree, duration_unit, active, is_active, copiedfromid, atomic_step_id)
        SELECT
          nextval('prior_authorizations_id_seq'::regclass) AS id,
          pa.date_of_policy,
          pa.pa_duration,
          pa.drug_id,
          sde.new_data_entry_id AS data_entry_id,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          sde.new_indication_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          pa.boolean_expression_tree,
          pa.duration_unit,
          pa.active,
          pa.is_active,
          pa.id AS copiedfromid,
          pa.atomic_step_id
        FROM
          prior_authorizations pa
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = pa.indication_id AND sde.drug_id = pa.drug_id AND sde.healthplantype_id = pa.healthplantype_id
                                            AND sde.provider_id = pa.provider_id AND pa.is_active = true AND sde.copy_pa = true
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== PA Criteria
      new_pa_criteria AS
      (
        INSERT INTO
          prior_authorization_criteria (value_upper, value_lower, non_fda_approved, created_at, updated_at, prior_authorization_id, criterium_id, criterium_applicable, active,
                                        is_active, copiedfromid, notes)
        SELECT
          pac.value_upper,
          pac.value_lower,
          pac.non_fda_approved,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          np.id AS prior_authorization_id,
          pac.criterium_id,
          pac.criterium_applicable,
          pac.active,
          pac.is_active,
          pac.id AS copiedfromid,
          pac.notes
        FROM
          prior_authorization_criteria pac
          INNER JOIN new_pa np ON np.copiedfromid = pac.prior_authorization_id AND pac.is_active = true
      ),
      --== ST
      new_st AS
      (
        INSERT INTO
          step_therapies (indication_id, drug_id, data_entry_id, provider_id, healthplantype_id, created_at, updated_at, boolean_expression_tree, is_active, copiedfromid, atomic_step_id)
        SELECT
          sde.new_indication_id,
          st.drug_id,
          sde.new_data_entry_id AS data_entry_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          st.boolean_expression_tree,
          st.is_active,
          st.id AS copiedfromid,
          st.atomic_step_id
        FROM
          step_therapies st
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = st.indication_id AND sde.drug_id = st.drug_id AND sde.healthplantype_id = st.healthplantype_id
                                            AND sde.provider_id = st.provider_id AND st.is_active = true AND sde.copy_st = true
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== Medical
      new_medical AS
      (
        INSERT INTO
          Medicals (date_of_policy, medical_duration, drug_id, data_entry_id, created_at, updated_at, indication_id,
                                provider_id, healthplantype_id, boolean_expression_tree, duration_unit, active, is_active, copiedfromid, atomic_step_id)
        SELECT
          med.date_of_policy,
          med.medical_duration,
          med.drug_id,
          sde.new_data_entry_id AS data_entry_id,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          sde.new_indication_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          med.boolean_expression_tree,
          med.duration_unit,
          med.active,
          med.is_active,
          med.id AS copiedfromid,
          med.atomic_step_id
        FROM
          medicals med
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = med.indication_id AND sde.drug_id = med.drug_id AND sde.healthplantype_id = med.healthplantype_id
                                            AND sde.provider_id = med.provider_id AND med.is_active = true AND sde.copy_medical = true
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== Medical Criteria
      new_medical_criteria AS
      (
        INSERT INTO
          medical_criteria (value_upper, value_lower, non_fda_approved, created_at, updated_at, medical_id, criterium_id, criterium_applicable, active,
                                        is_active, copiedfromid, notes)
        SELECT
          mec.value_upper,
          mec.value_lower,
          mec.non_fda_approved,
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          nm.id AS medical_id,
          mec.criterium_id,
          mec.criterium_applicable,
          mec.active,
          mec.is_active,
          mec.id AS copiedfromid,
          mec.notes
        FROM
          medical_criteria mec
          INNER JOIN new_medical nm ON nm.copiedfromid = mec.medical_id AND mec.is_active = true
      ),
      --== QL
      new_ql AS
      (
        INSERT INTO
          quantity_limits (created_at, updated_at, data_entry_id, drug_id, indication_id, provider_id, healthplantype_id, is_active, copiedfromid)
        SELECT
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          sde.new_data_entry_id AS data_entry_id,
          ql.drug_id,
          sde.new_indication_id,
          sde.new_provider_id,
          sde.new_healthplantype_id,
          ql.is_active,
          ql.id AS copiedfromid
        FROM
          quantity_limits ql
          INNER JOIN source_data_entries_with_new_id sde ON sde.indication_id = ql.indication_id AND sde.drug_id = ql.drug_id AND sde.healthplantype_id = ql.healthplantype_id
                                            AND sde.provider_id = ql.provider_id AND ql.is_active = true AND sde.copy_ql = true
        RETURNING id, data_entry_id, copiedfromid
      ),
      --== ql Criteria
      new_ql_criteria AS
      (
        INSERT INTO
          quantity_limit_criteria (created_at, updated_at, criterium_id, quantity_limit_id, active, amount_val, time_val, amount_type, time_type,
                                  is_active, copiedfromid, notes)
        SELECT
          _start_timestamp::timestamp AS created_at,
          _start_timestamp::timestamp AS updated_at,
          qlc.criterium_id,
          nq.id AS quantity_limit_id,
          qlc.active,
          qlc.amount_val,
          qlc.time_val,
          qlc.amount_type,
          qlc.time_type,
          qlc.is_active,
          qlc.id AS copiedfromid,
          qlc.notes
        FROM
          quantity_limit_criteria qlc
          INNER JOIN new_ql nq ON nq.copiedfromid = qlc.quantity_limit_id AND qlc.is_active = true
      )
      INSERT INTO
        temp_data_entry_restrictions (data_entry_id, prior_authorization_id, step_therapy_id, medical_id, quantity_limit_id)
      SELECT
        dr.data_entry_id, max(dr.prior_authorization_id), max(dr.step_therapy_id), max(dr.medical_id), max(dr.quantity_limit_id)
      FROM
        (
          SELECT
            data_entry_id, id AS prior_authorization_id, NULL::integer AS step_therapy_id, NULL::integer AS medical_id, NULL::integer AS quantity_limit_id
          FROM
            new_pa
          UNION
          SELECT
            data_entry_id, NULL::integer AS prior_authorization_id, id AS step_therapy_id, NULL::integer AS medical_id, NULL::integer AS quantity_limit_id
          FROM
            new_st
          UNION
          SELECT
            data_entry_id, NULL::integer AS prior_authorization_id, NULL::integer AS step_therapy_id, id AS medical_id, NULL::integer AS quantity_limit_id
          FROM
            new_medical
          UNION
          SELECT
            data_entry_id, NULL::integer AS prior_authorization_id, NULL::integer AS step_therapy_id, NULL::integer AS medical_id, id AS quantity_limit_id
          FROM
            new_ql
        ) dr
      GROUP BY
        dr.data_entry_id;


    --Fill Restriction IDs to DataEntery Records
    UPDATE
      data_entries de
    SET
      prior_authorization_id = CASE WHEN dr.prior_authorization_id IS NOT NULL THEN dr.prior_authorization_id ELSE de.prior_authorization_id END,
      step_therapy_id = CASE WHEN dr.step_therapy_id IS NOT NULL THEN dr.step_therapy_id ELSE de.step_therapy_id END,
      medical_id = CASE WHEN dr.medical_id IS NOT NULL THEN dr.medical_id ELSE de.medical_id END,
      quantity_limit_id = CASE WHEN dr.quantity_limit_id IS NOT NULL THEN dr.quantity_limit_id ELSE de.quantity_limit_id END
    FROM
      temp_data_entry_restrictions dr
    WHERE
      de.id = dr.data_entry_id;

    --Delete DataEntry Records without any Restrictions
    DELETE FROM
      data_entries
    WHERE
      id IN
      (
        SELECT
          data_entry_id
        FROM
          temp_target_data_entries
      )
      AND prior_authorization_id IS NULL AND step_therapy_id IS NULL AND medical_id IS NULL AND quantity_limit_id IS NULL;

    --Change log status from 1 in progress to 2 need review or 3 done
    _copy_log_status_code :=
        CASE
          WHEN _need_review = true THEN 2
          ELSE 3
        END;

    UPDATE
      copy_logs
    SET
      status = _copy_log_status_code,
      finished_at = clock_timestamp()
    WHERE
      id = _copy_log_id;

    RETURN QUERY SELECT 1 AS status, 'Successful'::text AS message, _copy_log_status_code AS copy_log_status;

  END;
  $$;


ALTER FUNCTION public.super_copy_single(_copy_log_id integer, _start_timestamp timestamp without time zone, _user_id integer) OWNER TO r2de;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: copy_configurations; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE copy_configurations (
    id integer NOT NULL,
    source_healthplantype_id integer NOT NULL,
    source_provider_id integer NOT NULL,
    target_healthplantype_id integer NOT NULL,
    target_provider_id integer NOT NULL,
    target_comments text,
    need_review boolean NOT NULL,
    copy_pa boolean NOT NULL,
    copy_st boolean NOT NULL,
    copy_ql boolean NOT NULL,
    copy_medical boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE copy_configurations OWNER TO r2de;

--
-- Name: copy_logs; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE copy_logs (
    id integer NOT NULL,
    source_indication_id integer NOT NULL,
    source_healthplantype_id integer NOT NULL,
    source_provider_id integer NOT NULL,
    target_indication_id integer NOT NULL,
    target_healthplantype_id integer NOT NULL,
    target_provider_id integer NOT NULL,
    target_comments text,
    copy_pa boolean NOT NULL,
    copy_st boolean NOT NULL,
    copy_ql boolean NOT NULL,
    copy_medical boolean NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    need_review boolean DEFAULT false NOT NULL,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    queued_by integer,
    run_by integer
);


ALTER TABLE copy_logs OWNER TO r2de;

--
-- Name: data_entries; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE data_entries (
    id integer NOT NULL,
    indication_id integer,
    provider_id integer,
    healthplantype_id integer,
    coverage_id integer,
    drug_id integer,
    coverage_limit_id integer,
    prior_authorization_id integer,
    quantity_limit_id integer,
    other_restriction_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    step_therapy_id integer,
    medical_id integer,
    copiedfromid integer
);


ALTER TABLE data_entries OWNER TO r2de;

--
-- Name: data_entries_details; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE data_entries_details (
    id integer NOT NULL,
    indication_id integer,
    provider_id integer,
    healthplantype_id integer,
    internal_comments text,
    source_comments text,
    display_summary text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    copiedfromid integer
);


ALTER TABLE data_entries_details OWNER TO r2de;

--
-- Name: drug_indications; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE drug_indications (
    drug_id integer,
    indication_id integer
);


ALTER TABLE drug_indications OWNER TO r2de;

--
-- Name: internal_comments; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE internal_comments (
    id integer NOT NULL,
    healthplantype_id integer NOT NULL,
    provider_id integer NOT NULL,
    internal_comments text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE internal_comments OWNER TO r2de;


--
-- Name: atomic_steps; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE atomic_steps (
    id integer NOT NULL,
    label text,
    key text,
    number_of_steps integer,
    data_entry_type text,
    label_with_seq text
);


ALTER TABLE atomic_steps OWNER TO r2de;

--
-- Name: atomic_steps_back; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE atomic_steps_back (
    id integer,
    label text,
    key text,
    number_of_steps integer,
    data_entry_type text,
    label_with_seq text
);


ALTER TABLE atomic_steps_back OWNER TO r2de;

--
-- Name: atomic_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE atomic_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE atomic_steps_id_seq OWNER TO r2de;

--
-- Name: atomic_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE atomic_steps_id_seq OWNED BY atomic_steps.id;


--
-- Name: atomic_steps_notes; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE atomic_steps_notes (
    de_id integer,
    de_type text,
    step_custom_option_name text,
    "position" integer,
    notes text,
    step_custom_option_id integer
);


ALTER TABLE atomic_steps_notes OWNER TO r2de;

--
-- Name: atomic_steps_notes_back; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE atomic_steps_notes_back (
    de_id integer,
    de_type text,
    step_custom_option_name text,
    "position" integer,
    notes text,
    step_custom_option_id integer
);


ALTER TABLE atomic_steps_notes_back OWNER TO r2de;

--
-- Name: copy_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE copy_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE copy_configurations_id_seq OWNER TO r2de;

--
-- Name: copy_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE copy_configurations_id_seq OWNED BY copy_configurations.id;


--
-- Name: copy_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE copy_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE copy_logs_id_seq OWNER TO r2de;

--
-- Name: copy_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE copy_logs_id_seq OWNED BY copy_logs.id;


--
-- Name: coverage_limits; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE coverage_limits (
    id integer NOT NULL,
    quantity_allowed integer DEFAULT 20,
    per_rx boolean DEFAULT true,
    duration_limit integer DEFAULT 30,
    coverage_limit_vary boolean DEFAULT false,
    data_entry_id integer,
    indication_id integer,
    drug_id integer,
    provider_id integer,
    healthplantype_id integer,
    units character varying(255),
    doc character varying(255),
    is_active boolean DEFAULT true
);


ALTER TABLE coverage_limits OWNER TO r2de;

--
-- Name: coverage_limits_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE coverage_limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coverage_limits_id_seq OWNER TO r2de;

--
-- Name: coverage_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE coverage_limits_id_seq OWNED BY coverage_limits.id;


--
-- Name: coverages; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE coverages (
    id integer NOT NULL,
    specialty_pharmacy_required boolean,
    specialty_pharmacy_name character varying(255),
    indication_id integer,
    drug_id integer,
    data_entry_id integer,
    provider_id integer,
    healthplantype_id integer,
    benefit_coverage character varying(255),
    site_care character varying(255),
    is_active boolean DEFAULT true
);


ALTER TABLE coverages OWNER TO r2de;

--
-- Name: coverages_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE coverages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coverages_id_seq OWNER TO r2de;

--
-- Name: coverages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE coverages_id_seq OWNED BY coverages.id;


--
-- Name: criteria; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE criteria (
    id integer NOT NULL,
    name text,
    value_range boolean,
    active boolean,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text,
    name_no_punc character varying,
    created_by integer,
    updated_by integer
);


ALTER TABLE criteria OWNER TO r2de;

--
-- Name: criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE criteria_id_seq OWNER TO r2de;

--
-- Name: criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE criteria_id_seq OWNED BY criteria.id;


--
-- Name: criteria_indications; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE criteria_indications (
    criterium_id integer,
    indication_id integer
);


ALTER TABLE criteria_indications OWNER TO r2de;

--
-- Name: criteria_other_restrictions; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE criteria_other_restrictions (
    id integer NOT NULL,
    drug_id integer,
    criterium_id integer,
    other_restriction_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE criteria_other_restrictions OWNER TO r2de;

--
-- Name: criteria_other_restrictions_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE criteria_other_restrictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE criteria_other_restrictions_id_seq OWNER TO r2de;

--
-- Name: criteria_other_restrictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE criteria_other_restrictions_id_seq OWNED BY criteria_other_restrictions.id;


--
-- Name: criteria_restrictions; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE criteria_restrictions (
    criterium_id integer,
    restriction_id integer
);


ALTER TABLE criteria_restrictions OWNER TO r2de;

--
-- Name: custom_options_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE custom_options_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE custom_options_id_seq OWNER TO r2de;

--
-- Name: custom_options; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE custom_options (
    id integer DEFAULT nextval('custom_options_id_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE custom_options OWNER TO r2de;

--
-- Name: data_entries_details_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE data_entries_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_entries_details_id_seq OWNER TO r2de;

--
-- Name: data_entries_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE data_entries_details_id_seq OWNED BY data_entries_details.id;


--
-- Name: data_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE data_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_entries_id_seq OWNER TO r2de;

--
-- Name: data_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE data_entries_id_seq OWNED BY data_entries.id;


--
-- Name: drugclass_indications; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE drugclass_indications (
    drug_class_id integer,
    indication_id integer
);


ALTER TABLE drugclass_indications OWNER TO r2de;

--
-- Name: indications; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE indications (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    abbreviation character varying(10),
    name_no_punc character varying
);


ALTER TABLE indications OWNER TO r2de;

--
-- Name: indications_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE indications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indications_id_seq OWNER TO r2de;

--
-- Name: indications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE indications_id_seq OWNED BY indications.id;


--
-- Name: indications_step_custom_options; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE indications_step_custom_options (
    indication_id integer,
    step_custom_option_id integer
);


ALTER TABLE indications_step_custom_options OWNER TO r2de;

--
-- Name: internal_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE internal_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE internal_comments_id_seq OWNER TO r2de;

--
-- Name: internal_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE internal_comments_id_seq OWNED BY internal_comments.id;


--
-- Name: medical_criteria; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE medical_criteria (
    id integer NOT NULL,
    value_upper integer,
    value_lower integer,
    non_fda_approved boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    medical_id integer,
    criterium_id integer,
    criterium_applicable integer,
    active boolean DEFAULT true,
    is_active boolean DEFAULT true,
    copiedfromid integer,
    notes text
);


ALTER TABLE medical_criteria OWNER TO r2de;

--
-- Name: medical_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE medical_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE medical_criteria_id_seq OWNER TO r2de;

--
-- Name: medical_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE medical_criteria_id_seq OWNED BY medical_criteria.id;


--
-- Name: medicals; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE medicals (
    id integer NOT NULL,
    date_of_policy timestamp without time zone,
    medical_duration character varying(255),
    drug_id integer,
    data_entry_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    indication_id integer,
    provider_id integer,
    healthplantype_id integer,
    boolean_expression_tree json,
    duration_unit character varying(10) DEFAULT 'd'::character varying,
    active boolean DEFAULT true,
    is_active boolean DEFAULT true,
    copiedfromid integer,
    atomic_step_id integer
);


ALTER TABLE medicals OWNER TO r2de;

--
-- Name: medicals_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE medicals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE medicals_id_seq OWNER TO r2de;

--
-- Name: medicals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE medicals_id_seq OWNED BY medicals.id;



--
-- Name: other_restrictions; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE other_restrictions (
    id integer NOT NULL,
    upper_limit integer,
    lower_limit integer,
    data_entry_id integer,
    drug_id integer,
    indication_id integer,
    provider_id integer,
    healthplantype_id integer,
    active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE other_restrictions OWNER TO r2de;

--
-- Name: other_restrictions_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE other_restrictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE other_restrictions_id_seq OWNER TO r2de;

--
-- Name: other_restrictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE other_restrictions_id_seq OWNED BY other_restrictions.id;


--
-- Name: prior_authorization_criteria; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE prior_authorization_criteria (
    id integer NOT NULL,
    value_upper integer,
    value_lower integer,
    non_fda_approved boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    prior_authorization_id integer,
    criterium_id integer,
    criterium_applicable integer,
    active boolean DEFAULT true,
    is_active boolean DEFAULT true,
    copiedfromid integer,
    notes text
);


ALTER TABLE prior_authorization_criteria OWNER TO r2de;

--
-- Name: prior_authorization_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE prior_authorization_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prior_authorization_criteria_id_seq OWNER TO r2de;

--
-- Name: prior_authorization_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE prior_authorization_criteria_id_seq OWNED BY prior_authorization_criteria.id;


--
-- Name: prior_authorizations; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE prior_authorizations (
    id integer NOT NULL,
    date_of_policy timestamp without time zone,
    pa_duration character varying(255),
    drug_id integer,
    data_entry_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    indication_id integer,
    provider_id integer,
    healthplantype_id integer,
    boolean_expression_tree json,
    duration_unit character varying(10) DEFAULT 'd'::character varying,
    active boolean DEFAULT true,
    is_active boolean DEFAULT true,
    copiedfromid integer,
    atomic_step_id integer
);


ALTER TABLE prior_authorizations OWNER TO r2de;

--
-- Name: prior_authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE prior_authorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prior_authorizations_id_seq OWNER TO r2de;

--
-- Name: prior_authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE prior_authorizations_id_seq OWNED BY prior_authorizations.id;


--
-- Name: quantity_limit_criteria; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE quantity_limit_criteria (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    criterium_id integer,
    quantity_limit_id integer,
    active boolean DEFAULT true,
    amount_val numeric(12,2),
    time_val integer,
    amount_type character varying(255),
    time_type character varying(255),
    is_active boolean DEFAULT true,
    copiedfromid integer,
    notes text
);


ALTER TABLE quantity_limit_criteria OWNER TO r2de;

--
-- Name: quantity_limit_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE quantity_limit_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE quantity_limit_criteria_id_seq OWNER TO r2de;

--
-- Name: quantity_limit_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE quantity_limit_criteria_id_seq OWNED BY quantity_limit_criteria.id;


--
-- Name: quantity_limits; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE quantity_limits (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_entry_id integer,
    drug_id integer,
    indication_id integer,
    provider_id integer,
    healthplantype_id integer,
    is_active boolean DEFAULT true,
    copiedfromid integer
);


ALTER TABLE quantity_limits OWNER TO r2de;

--
-- Name: quantity_limits_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE quantity_limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE quantity_limits_id_seq OWNER TO r2de;

--
-- Name: quantity_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE quantity_limits_id_seq OWNED BY quantity_limits.id;


--
-- Name: rails_simple_auth_drg_consume_tokens; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE rails_simple_auth_drg_consume_tokens (
    id integer NOT NULL,
    key character varying(255),
    consumed boolean DEFAULT false,
    user_session_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE rails_simple_auth_drg_consume_tokens OWNER TO r2de;

--
-- Name: rails_simple_auth_drg_consume_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE rails_simple_auth_drg_consume_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rails_simple_auth_drg_consume_tokens_id_seq OWNER TO r2de;

--
-- Name: rails_simple_auth_drg_consume_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE rails_simple_auth_drg_consume_tokens_id_seq OWNED BY rails_simple_auth_drg_consume_tokens.id;


--
-- Name: rails_simple_auth_drg_user_sessions; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE rails_simple_auth_drg_user_sessions (
    id integer NOT NULL,
    user_id integer,
    key character varying(255),
    ip character varying(255),
    user_agent character varying(255),
    accessed_at timestamp without time zone,
    revoked_at timestamp without time zone,
    username character varying(255)
);


ALTER TABLE rails_simple_auth_drg_user_sessions OWNER TO r2de;

--
-- Name: rails_simple_auth_drg_user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE rails_simple_auth_drg_user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rails_simple_auth_drg_user_sessions_id_seq OWNER TO r2de;

--
-- Name: rails_simple_auth_drg_user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE rails_simple_auth_drg_user_sessions_id_seq OWNED BY rails_simple_auth_drg_user_sessions.id;


--
-- Name: rails_simple_auth_drg_users; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE rails_simple_auth_drg_users (
    id integer NOT NULL,
    username character varying(255),
    email character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE rails_simple_auth_drg_users OWNER TO r2de;

--
-- Name: restrictions; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE restrictions (
    id integer NOT NULL,
    name character varying(255),
    category character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE restrictions OWNER TO r2de;

--
-- Name: restrictions_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE restrictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE restrictions_id_seq OWNER TO r2de;

--
-- Name: restrictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE restrictions_id_seq OWNED BY restrictions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE schema_migrations OWNER TO r2de;

--
-- Name: step_custom_options; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE step_custom_options (
    id integer NOT NULL,
    customizable_id integer NOT NULL,
    customizable_type character varying NOT NULL
);


ALTER TABLE step_custom_options OWNER TO r2de;

--
-- Name: step_custom_options_back; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE step_custom_options_back (
    id integer,
    customizable_id integer,
    customizable_type character varying
);


ALTER TABLE step_custom_options_back OWNER TO r2de;

--
-- Name: step_custom_options_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE step_custom_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE step_custom_options_id_seq OWNER TO r2de;

--
-- Name: step_custom_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE step_custom_options_id_seq OWNED BY step_custom_options.id;


--
-- Name: step_therapies; Type: TABLE; Schema: public; Owner: r2de; Tablespace: 
--

CREATE TABLE step_therapies (
    id integer NOT NULL,
    indication_id integer,
    drug_id integer,
    health_plan_id integer,
    data_entry_id integer,
    provider_id integer,
    healthplantype_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    boolean_expression_tree json,
    is_active boolean DEFAULT true,
    copiedfromid integer,
    atomic_step_id integer
);


ALTER TABLE step_therapies OWNER TO r2de;

--
-- Name: step_therapies_id_seq; Type: SEQUENCE; Schema: public; Owner: r2de
--

CREATE SEQUENCE step_therapies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE step_therapies_id_seq OWNER TO r2de;

--
-- Name: step_therapies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: r2de
--

ALTER SEQUENCE step_therapies_id_seq OWNED BY step_therapies.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY atomic_steps ALTER COLUMN id SET DEFAULT nextval('atomic_steps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY copy_configurations ALTER COLUMN id SET DEFAULT nextval('copy_configurations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY copy_logs ALTER COLUMN id SET DEFAULT nextval('copy_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY coverage_limits ALTER COLUMN id SET DEFAULT nextval('coverage_limits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY coverages ALTER COLUMN id SET DEFAULT nextval('coverages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY criteria ALTER COLUMN id SET DEFAULT nextval('criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY criteria_other_restrictions ALTER COLUMN id SET DEFAULT nextval('criteria_other_restrictions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY data_entries ALTER COLUMN id SET DEFAULT nextval('data_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY data_entries_details ALTER COLUMN id SET DEFAULT nextval('data_entries_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY indications ALTER COLUMN id SET DEFAULT nextval('indications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY internal_comments ALTER COLUMN id SET DEFAULT nextval('internal_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY medical_criteria ALTER COLUMN id SET DEFAULT nextval('medical_criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY medicals ALTER COLUMN id SET DEFAULT nextval('medicals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY other_restrictions ALTER COLUMN id SET DEFAULT nextval('other_restrictions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY prior_authorization_criteria ALTER COLUMN id SET DEFAULT nextval('prior_authorization_criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY prior_authorizations ALTER COLUMN id SET DEFAULT nextval('prior_authorizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY quantity_limit_criteria ALTER COLUMN id SET DEFAULT nextval('quantity_limit_criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY quantity_limits ALTER COLUMN id SET DEFAULT nextval('quantity_limits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY rails_simple_auth_drg_consume_tokens ALTER COLUMN id SET DEFAULT nextval('rails_simple_auth_drg_consume_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY rails_simple_auth_drg_user_sessions ALTER COLUMN id SET DEFAULT nextval('rails_simple_auth_drg_user_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY restrictions ALTER COLUMN id SET DEFAULT nextval('restrictions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY step_custom_options ALTER COLUMN id SET DEFAULT nextval('step_custom_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: r2de
--

ALTER TABLE ONLY step_therapies ALTER COLUMN id SET DEFAULT nextval('step_therapies_id_seq'::regclass);


--
-- Name: atomic_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY atomic_steps
    ADD CONSTRAINT atomic_steps_pkey PRIMARY KEY (id);


--
-- Name: copy_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY copy_configurations
    ADD CONSTRAINT copy_configurations_pkey PRIMARY KEY (id);


--
-- Name: copy_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY copy_logs
    ADD CONSTRAINT copy_logs_pkey PRIMARY KEY (id);


--
-- Name: coverage_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY coverage_limits
    ADD CONSTRAINT coverage_limits_pkey PRIMARY KEY (id);


--
-- Name: coverages_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY coverages
    ADD CONSTRAINT coverages_pkey PRIMARY KEY (id);


--
-- Name: criteria_other_restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY criteria_other_restrictions
    ADD CONSTRAINT criteria_other_restrictions_pkey PRIMARY KEY (id);


--
-- Name: criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY criteria
    ADD CONSTRAINT criteria_pkey PRIMARY KEY (id);


--
-- Name: custom_options_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY custom_options
    ADD CONSTRAINT custom_options_pkey PRIMARY KEY (id);


--
-- Name: data_entries_details_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY data_entries_details
    ADD CONSTRAINT data_entries_details_pkey PRIMARY KEY (id);


--
-- Name: data_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY data_entries
    ADD CONSTRAINT data_entries_pkey PRIMARY KEY (id);


--
-- Name: indications_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY indications
    ADD CONSTRAINT indications_pkey PRIMARY KEY (id);


--
-- Name: internal_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY internal_comments
    ADD CONSTRAINT internal_comments_pkey PRIMARY KEY (id);


--
-- Name: medical_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY medical_criteria
    ADD CONSTRAINT medical_criteria_pkey PRIMARY KEY (id);


--
-- Name: medicals_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY medicals
    ADD CONSTRAINT medicals_pkey PRIMARY KEY (id);


--
-- Name: other_restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY other_restrictions
    ADD CONSTRAINT other_restrictions_pkey PRIMARY KEY (id);


--
-- Name: prior_authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY prior_authorization_criteria
    ADD CONSTRAINT prior_authorizations_pkey PRIMARY KEY (id);


--
-- Name: prior_authorizations_pkey1; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY prior_authorizations
    ADD CONSTRAINT prior_authorizations_pkey1 PRIMARY KEY (id);


--
-- Name: quantity_limit_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY quantity_limit_criteria
    ADD CONSTRAINT quantity_limit_criteria_pkey PRIMARY KEY (id);


--
-- Name: quantity_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY quantity_limits
    ADD CONSTRAINT quantity_limits_pkey PRIMARY KEY (id);


--
-- Name: rails_simple_auth_drg_consume_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY rails_simple_auth_drg_consume_tokens
    ADD CONSTRAINT rails_simple_auth_drg_consume_tokens_pkey PRIMARY KEY (id);


--
-- Name: rails_simple_auth_drg_user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY rails_simple_auth_drg_user_sessions
    ADD CONSTRAINT rails_simple_auth_drg_user_sessions_pkey PRIMARY KEY (id);


--
-- Name: restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY restrictions
    ADD CONSTRAINT restrictions_pkey PRIMARY KEY (id);


--
-- Name: step_custom_options_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY step_custom_options
    ADD CONSTRAINT step_custom_options_pkey PRIMARY KEY (id);


--
-- Name: step_therapies_pkey; Type: CONSTRAINT; Schema: public; Owner: r2de; Tablespace: 
--

ALTER TABLE ONLY step_therapies
    ADD CONSTRAINT step_therapies_pkey PRIMARY KEY (id);


--
-- Name: criteria_indications_index; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX criteria_indications_index ON criteria_indications USING btree (criterium_id, indication_id);


--
-- Name: criteria_restrictions_index; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX criteria_restrictions_index ON criteria_restrictions USING btree (criterium_id, restriction_id);


--
-- Name: data_entry_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX data_entry_idx ON prior_authorizations USING btree (data_entry_id) WHERE (is_active IS TRUE);


--
-- Name: drug_indications_index; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX drug_indications_index ON drug_indications USING btree (drug_id, indication_id);


--
-- Name: drugclass_indications_index; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX drugclass_indications_index ON drugclass_indications USING btree (drug_class_id, indication_id);


--
-- Name: idx_copy_configurations_on_src_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX idx_copy_configurations_on_src_keys ON copy_configurations USING btree (source_healthplantype_id, source_provider_id);


--
-- Name: idx_copy_logs_on_target_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX idx_copy_logs_on_target_keys ON copy_logs USING btree (status, target_indication_id, target_healthplantype_id, target_provider_id);


--
-- Name: idx_simple_auth_drg_consume_tokens_on_key_and_consumed; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX idx_simple_auth_drg_consume_tokens_on_key_and_consumed ON rails_simple_auth_drg_consume_tokens USING btree (key, consumed);


--
-- Name: idx_simple_auth_drg_user_sessions_on_accessed_and_revoked_at; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX idx_simple_auth_drg_user_sessions_on_accessed_and_revoked_at ON rails_simple_auth_drg_user_sessions USING btree (accessed_at, revoked_at);


--
-- Name: idx_unique_internal_comments_on_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX idx_unique_internal_comments_on_keys ON internal_comments USING btree (healthplantype_id, provider_id);


--
-- Name: idx_unique_medicals_on_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX idx_unique_medicals_on_keys ON medicals USING btree (drug_id, indication_id, provider_id, healthplantype_id);


--
-- Name: idx_unique_prior_authorizations_on_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX idx_unique_prior_authorizations_on_keys ON prior_authorizations USING btree (drug_id, indication_id, provider_id, healthplantype_id);


--
-- Name: idx_unique_quantity_limits_on_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX idx_unique_quantity_limits_on_keys ON quantity_limits USING btree (drug_id, indication_id, provider_id, healthplantype_id);


--
-- Name: idx_unique_step_therapies_on_keys; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX idx_unique_step_therapies_on_keys ON step_therapies USING btree (drug_id, indication_id, provider_id, healthplantype_id);


--
-- Name: index_atomic_steps_notes_on_de_id; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_atomic_steps_notes_on_de_id ON atomic_steps_notes USING btree (de_id);


--
-- Name: index_atomic_steps_on_key; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_atomic_steps_on_key ON atomic_steps USING btree (key);


--
-- Name: index_atomic_steps_on_number_of_steps; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_atomic_steps_on_number_of_steps ON atomic_steps USING btree (number_of_steps);


--
-- Name: index_custom_options_on_name; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX index_custom_options_on_name ON custom_options USING btree (name);


--
-- Name: index_indications_on_id_and_name; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_indications_on_id_and_name ON indications USING btree (id, name);


--
-- Name: index_medicals_on_atomic_step_id; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_medicals_on_atomic_step_id ON medicals USING btree (atomic_step_id);


--
-- Name: index_prior_authorizations_on_atomic_step_id; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_prior_authorizations_on_atomic_step_id ON prior_authorizations USING btree (atomic_step_id);


--
-- Name: index_rails_simple_auth_drg_consume_tokens_on_consumed; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_rails_simple_auth_drg_consume_tokens_on_consumed ON rails_simple_auth_drg_consume_tokens USING btree (consumed);


--
-- Name: index_rails_simple_auth_drg_consume_tokens_on_key; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX index_rails_simple_auth_drg_consume_tokens_on_key ON rails_simple_auth_drg_consume_tokens USING btree (key);


--
-- Name: index_rails_simple_auth_drg_consume_tokens_on_user_session_id; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_rails_simple_auth_drg_consume_tokens_on_user_session_id ON rails_simple_auth_drg_consume_tokens USING btree (user_session_id);


--
-- Name: index_rails_simple_auth_drg_user_sessions_on_accessed_at; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_rails_simple_auth_drg_user_sessions_on_accessed_at ON rails_simple_auth_drg_user_sessions USING btree (accessed_at);


--
-- Name: index_rails_simple_auth_drg_user_sessions_on_key; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX index_rails_simple_auth_drg_user_sessions_on_key ON rails_simple_auth_drg_user_sessions USING btree (key);


--
-- Name: index_rails_simple_auth_drg_user_sessions_on_revoked_at; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_rails_simple_auth_drg_user_sessions_on_revoked_at ON rails_simple_auth_drg_user_sessions USING btree (revoked_at);


--
-- Name: index_rails_simple_auth_drg_users_on_id; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX index_rails_simple_auth_drg_users_on_id ON rails_simple_auth_drg_users USING btree (id);


--
-- Name: index_step_therapies_on_atomic_step_id; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX index_step_therapies_on_atomic_step_id ON step_therapies USING btree (atomic_step_id);


--
-- Name: indication_provider_healthplantype_drug_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX indication_provider_healthplantype_drug_idx ON data_entries USING btree (indication_id, provider_id, healthplantype_id, drug_id);


--
-- Name: indication_provider_healthplantype_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE INDEX indication_provider_healthplantype_idx ON data_entries_details USING btree (indication_id, provider_id, healthplantype_id);


--
-- Name: medical_criterium_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX medical_criterium_idx ON medical_criteria USING btree (medical_id, criterium_id, is_active);


--
-- Name: medical_data_entry_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX medical_data_entry_idx ON medicals USING btree (data_entry_id) WHERE (is_active IS TRUE);


--
-- Name: prior_authorization_criterium_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX prior_authorization_criterium_idx ON prior_authorization_criteria USING btree (prior_authorization_id, criterium_id);


--
-- Name: quantity_limit_criteria_data_entry_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX quantity_limit_criteria_data_entry_idx ON quantity_limit_criteria USING btree (quantity_limit_id, criterium_id, is_active);


--
-- Name: quantity_limit_data_entry_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX quantity_limit_data_entry_idx ON quantity_limits USING btree (data_entry_id, is_active);


--
-- Name: sco_index; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX sco_index ON step_custom_options USING btree (customizable_id, customizable_type);


--
-- Name: step_therapy_data_entry_idx; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX step_therapy_data_entry_idx ON step_therapies USING btree (data_entry_id, is_active);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: r2de; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO r2de;


--
-- PostgreSQL database dump complete
--

