-- Set locale_preferred = 1 for fully specified names of the 12 inserted concepts

UPDATE concept_name SET locale_preferred = 1 WHERE concept_name_type = 'FULLY_SPECIFIED' AND concept_id IN (4254, 4255, 4256, 4257, 4258, 4259, 4260, 4261, 4262, 4263, 4264, 4265);
