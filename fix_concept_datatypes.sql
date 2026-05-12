-- Update datatypes for the 12 concepts that were inserted with wrong datatypes

-- Coded concepts (should have datatype_id 2)
UPDATE concept SET datatype_id = 2 WHERE uuid = '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Malaria danger signs
UPDATE concept SET datatype_id = 2 WHERE uuid = '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Plasmodium species
UPDATE concept SET datatype_id = 2 WHERE uuid = '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Malaria classification
UPDATE concept SET datatype_id = 2 WHERE uuid = '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Antimalarial medication prescribed
UPDATE concept SET datatype_id = 2 WHERE uuid = '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- LLIN bednet usage
UPDATE concept SET datatype_id = 2 WHERE uuid = '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Patient disposition

-- N/A concepts (should have datatype_id 4)
UPDATE concept SET datatype_id = 4 WHERE uuid = '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Artemether-Lumefantrine
UPDATE concept SET datatype_id = 4 WHERE uuid = '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Unable to drink or breastfeed
UPDATE concept SET datatype_id = 4 WHERE uuid = '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Artesunate
UPDATE concept SET datatype_id = 4 WHERE uuid = '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Plasmodium vivax
UPDATE concept SET datatype_id = 4 WHERE uuid = '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Discharged
UPDATE concept SET datatype_id = 4 WHERE uuid = '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; -- Severe malaria
