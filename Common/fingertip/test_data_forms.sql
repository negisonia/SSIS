CREATE OR REPLACE FUNCTION test_data_forms() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
drug_1 INTEGER;
drug_2 INTEGER;
provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;
drug_class_1 INTEGER;

BEGIN

  SELECT common_get_table_id_by_name(drug, 'drug_1') INTO drug_1;
  SELECT common_get_table_id_by_name(drug, 'drug_2') INTO drug_2;
  SELECT common_get_table_id_by_name(provider, 'provider_1') INTO provider_1;
  SELECT common_get_table_id_by_name(healthplantype, 'commercial') INTO commercial_hpt;
  SELECT common_get_table_id_by_name(healthplantype, 'hix') INTO hix_hpt;
  SELECT common_get_table_id_by_name(drugclass, 'drug_class_1') INTO drug_class_1;

  --INSERT DRUG FORMS
  PERFORM common_create_qualifier_form_drug(provider_1, commercial_hpt,NULL, drug_1, 'https://www.provider_1.com/drug_1PAform1.pdf, https://www.provider_1.com/drug_1PAform2.pdf', NULL, NULL, 'https://www.provider_1.com/drug_1Medicalform1.pdf,https://www.provider_1.com/drug_1Medicalform2.pdf', TRUE);
  PERFORM common_create_qualifier_form_drug(provider_1, commercial_hpt,NULL, drug_2, NULL, NULL, NULL, NULL, TRUE);
  PERFORM common_create_qualifier_form_drug(provider_1, hix_hpt, NULL, drug_1, NULL, NULL, NULL, NULL, TRUE);
  PERFORM common_create_qualifier_form_drug(provider_1, hix_hpt, NULL, drug_2, 'https://www.provider_1.com/drug_2PAform1hix.pdf', NULL, NULL, 'https://www.provider_1.com/drug_2hixMedicalform1.pdf', TRUE);

  --INSERT DRUG CLASS FORMS
  PERFORM common_create_qualifier_form_drug_class(provider_1, commercial_hpt, drug_class_1, 'https://www.provider_1.com/providerLevelPAform.pdf', NULL, NULL, 'https://www.provider_1.com/providerLevelMedicalform.pdf', TRUE);
  PERFORM common_create_qualifier_form_drug_class(provider_1, hix_hpt, drug_class_1, NULL, NULL, NULL, NULL, TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;