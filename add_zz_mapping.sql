-- Add concept reference mapping for "ZZ" to Indeterminate concept
-- This allows the system to recognize "ZZ" as a valid value for Indeterminate test results

INSERT INTO concept_reference (concept_id, source_uuid, code, concept_source_id, creator, date_created, uuid)
SELECT 
    c.concept_id,
    (SELECT uuid FROM concept_source WHERE name = 'CIEL'),
    'ZZ',
    (SELECT concept_source_id FROM concept_source WHERE name = 'CIEL'),
    1,
    NOW(),
    'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
FROM concept c
WHERE c.uuid = '1213BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
ON DUPLICATE KEY UPDATE code=code;
