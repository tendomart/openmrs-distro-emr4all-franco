-- Add concept reference mapping for "ZZ" to Indeterminate concept
-- This allows the system to recognize "ZZ" as a valid value for Indeterminate test results

-- First, insert the reference term for "ZZ" if it doesn't exist
INSERT INTO concept_reference_term (concept_reference_term_id, code, concept_source_id, creator, date_created, uuid)
SELECT 
    (SELECT COALESCE(MAX(concept_reference_term_id), 0) + 1 FROM concept_reference_term),
    'ZZ',
    (SELECT concept_source_id FROM concept_reference_source WHERE name = 'CIEL'),
    1,
    NOW(),
    'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
WHERE NOT EXISTS (
    SELECT 1 FROM concept_reference_term WHERE code = 'ZZ'
    AND concept_source_id = (SELECT concept_source_id FROM concept_reference_source WHERE name = 'CIEL')
);

-- Then, insert the mapping
INSERT INTO concept_reference_map (concept_reference_term_id, concept_id, creator, date_created, uuid)
SELECT 
    crt.concept_reference_term_id,
    c.concept_id,
    1,
    NOW(),
    'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM'
FROM concept c, concept_reference_term crt
WHERE c.uuid = '1213BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
AND crt.code = 'ZZ'
AND crt.concept_source_id = (SELECT concept_source_id FROM concept_reference_source WHERE name = 'CIEL')
ON DUPLICATE KEY UPDATE concept_id=c.concept_id;
