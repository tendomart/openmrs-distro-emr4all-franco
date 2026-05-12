-- SQL script to insert missing concepts directly into OpenMRS database
-- Run this in the MySQL database: docker compose exec db mysql -u openmrs -p openmrs < insert_missing_concepts.sql
-- Note: This inserts concepts without CIEL mappings (mappings are optional for form to work)

-- Get the required datatype and class IDs (not UUIDs)
-- Numeric datatype: 8, Text datatype: 4
-- Finding class: 10, Diagnosis class: 10, Question class: 10, Drug class: 10, Misc class: 10

-- Insert the 12 missing concepts
-- 1. Artemether-Lumefantrine (161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - N/A datatype
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4254, '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 4, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2001, 4254, 'Artemether-Lumefantrine', 'en', 'FULLY_SPECIFIED', 1, NOW(), '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2002, 4254, 'AL', 'en', 'SHORT', 1, NOW(), '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3001, 4254, 'Artemether-Lumefantrine combination (ACT) for uncomplicated malaria', 'en', 1, NOW(), '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 2. Malaria danger signs (162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - Coded datatype (has answers)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4255, '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2003, 4255, 'Malaria danger signs', 'en', 'FULLY_SPECIFIED', 1, NOW(), '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2004, 4255, 'Danger signs', 'en', 'SHORT', 1, NOW(), '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3002, 4255, 'Danger signs observed during malaria consultation (multi-select)', 'en', 1, NOW(), '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 3. Malaria classification (160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - Coded datatype (has answers)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4256, '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2005, 4256, 'Malaria classification', 'en', 'FULLY_SPECIFIED', 1, NOW(), '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2006, 4256, 'Classification', 'en', 'SHORT', 1, NOW(), '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3003, 4256, 'Final malaria classification (uncomplicated vs severe)', 'en', 1, NOW(), '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 4. Unable to drink or breastfeed (152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - N/A datatype
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4257, '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 4, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2007, 4257, 'Unable to drink or breastfeed', 'en', 'FULLY_SPECIFIED', 1, NOW(), '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2008, 4257, 'Cannot drink/breastfeed', 'en', 'SHORT', 1, NOW(), '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3004, 4257, 'Patient is unable to drink or breastfeed (IMCI danger sign)', 'en', 1, NOW(), '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 5. Plasmodium species (160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - Coded datatype (has answers)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4258, '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2009, 4258, 'Plasmodium species', 'en', 'FULLY_SPECIFIED', 1, NOW(), '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2010, 4258, 'Species', 'en', 'SHORT', 1, NOW(), '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3005, 4258, 'Plasmodium species identified on microscopy/RDT', 'en', 1, NOW(), '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 6. Artesunate (71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - N/A datatype
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4259, '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 4, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2011, 4259, 'Artesunate', 'en', 'FULLY_SPECIFIED', 1, NOW(), '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3006, 4259, 'Artesunate (IV or parenteral) used for severe malaria', 'en', 1, NOW(), '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE description=description;

-- 7. Plasmodium vivax (116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - N/A datatype
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4260, '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 4, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2012, 4260, 'Plasmodium vivax', 'en', 'FULLY_SPECIFIED', 1, NOW(), '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2013, 4260, 'P. vivax', 'en', 'SHORT', 1, NOW(), '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3007, 4260, 'Malaria parasite species Plasmodium vivax', 'en', 1, NOW(), '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 8. LLIN bednet usage (160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - Coded datatype (has answers)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4261, '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2014, 4261, 'LLIN bednet usage', 'en', 'FULLY_SPECIFIED', 1, NOW(), '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2015, 4261, 'LLIN usage', 'en', 'SHORT', 1, NOW(), '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3008, 4261, 'Whether the patient uses a Long-Lasting Insecticidal Net (MILDA)', 'en', 1, NOW(), '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 9. Antimalarial medication prescribed (1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - Coded datatype (has answers)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4262, '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2016, 4262, 'Antimalarial medication prescribed', 'en', 'FULLY_SPECIFIED', 1, NOW(), '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2017, 4262, 'Antimalarial', 'en', 'SHORT', 1, NOW(), '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3009, 4262, 'Antimalarial medication selected for this consultation', 'en', 1, NOW(), '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

-- 10. Discharged (159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - N/A datatype
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4263, '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 4, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2018, 4263, 'Discharged', 'en', 'FULLY_SPECIFIED', 1, NOW(), '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3010, 4263, 'Patient discharged home after consultation', 'en', 1, NOW(), '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE description=description;

-- 11. Severe malaria (116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - N/A datatype
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4264, '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 4, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2019, 4264, 'Severe malaria', 'en', 'FULLY_SPECIFIED', 1, NOW(), '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3011, 4264, 'Severe (complicated) malaria per WHO classification', 'en', 1, NOW(), '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE description=description;

-- 12. Patient disposition (160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA) - Coded datatype (has answers)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (4265, '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 2, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2020, 4265, 'Patient disposition', 'en', 'FULLY_SPECIFIED', 1, NOW(), '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, uuid)
VALUES (2021, 4265, 'Disposition', 'en', 'SHORT', 1, NOW(), '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, uuid)
VALUES (3012, 4265, 'Disposition at end of consultation (discharged / admitted / referred)', 'en', 1, NOW(), '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;
