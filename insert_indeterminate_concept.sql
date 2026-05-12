-- Insert Indeterminate concept for test results
-- This concept is used when test results are indeterminate

INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4266, '1213BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, locale_preferred, uuid)
VALUES (2022, 4266, 'Indeterminate', 'en', 'FULLY_SPECIFIED', 1, NOW(), 1, '1213BBBBBBBBBBBBBBBBBBBBBBBBBBBBBC')
ON DUPLICATE KEY UPDATE name=name;
