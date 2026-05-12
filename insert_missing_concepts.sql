-- SQL script to insert missing concepts directly into OpenMRS database
-- Run this in the MySQL database: docker compose exec db mysql -u openmrs -p openmrs < insert_missing_concepts.sql

-- First, get the CIEL concept source UUID (usually exists in standard OpenMRS installations)
-- If CIEL source doesn't exist, we need to create it first
INSERT IGNORE INTO concept_reference_source (concept_reference_source_id, name, description, hl7_code, creator, date_created, retired, uuid)
VALUES (1, 'CIEL', 'CIEL Concept Dictionary', 'CIEL', 1, NOW(), 0, 'c0a55327-695f-4893-8f39-0812509132ef')
ON DUPLICATE KEY UPDATE name=name;

-- Get the required datatype and class UUIDs
-- Numeric: 8d4f4cba-c2cc-11de-8d13-0010c6dffd0f
-- Text: 8d4f72f0-c2cc-11de-8d13-0010c6dffd0f
-- Finding (class): d013be2a-8377-4c5f-b341-43d28c94d2fe
-- Diagnosis (class): d013be2a-8377-4c5f-b341-43d28c94d2fe
-- Question (class): d013be2a-8377-4c5f-b341-43d28c94d2fe
-- Drug (class): d013be2a-8377-4c5f-b341-43d28c94d2fe
-- Misc (class): d013be2a-8377-4c5f-b341-43d28c94d2fe

-- Insert the 12 missing concepts
-- 1. Artemether-Lumefantrine (161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1001, '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2001, 1001, 'Artemether-Lumefantrine', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2002, 1001, 'AL', 'en', 'SHORT', 1, NOW(), 0, '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3001, 1001, 'Artemether-Lumefantrine combination (ACT) for uncomplicated malaria', 'en', 1, NOW(), 0, '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4001, 1001, 1, '161350', 1, NOW(), '161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 2. Malaria danger signs (162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1002, '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2003, 1002, 'Malaria danger signs', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2004, 1002, 'Danger signs', 'en', 'SHORT', 1, NOW(), 0, '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3002, 1002, 'Danger signs observed during malaria consultation (multi-select)', 'en', 1, NOW(), 0, '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4002, 1002, 1, '162568', 1, NOW(), '162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 3. Malaria classification (160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1003, '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2005, 1003, 'Malaria classification', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2006, 1003, 'Classification', 'en', 'SHORT', 1, NOW(), 0, '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3003, 1003, 'Final malaria classification (uncomplicated vs severe)', 'en', 1, NOW(), 0, '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4003, 1003, 1, '160108', 1, NOW(), '160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 4. Unable to drink or breastfeed (152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1004, '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2007, 1004, 'Unable to drink or breastfeed', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2008, 1004, 'Cannot drink/breastfeed', 'en', 'SHORT', 1, NOW(), 0, '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3004, 1004, 'Patient is unable to drink or breastfeed (IMCI danger sign)', 'en', 1, NOW(), 0, '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4004, 1004, 1, '152761', 1, NOW(), '152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 5. Plasmodium species (160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1005, '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2009, 1005, 'Plasmodium species', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2010, 1005, 'Species', 'en', 'SHORT', 1, NOW(), 0, '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3005, 1005, 'Plasmodium species identified on microscopy/RDT', 'en', 1, NOW(), 0, '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4005, 1005, 1, '160101', 1, NOW(), '160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 6. Artesunate (71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1006, '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2011, 1006, 'Artesunate', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3006, 1006, 'Artesunate (IV or parenteral) used for severe malaria', 'en', 1, NOW(), 0, '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4006, 1006, 1, '71100', 1, NOW(), '71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 7. Plasmodium vivax (116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1007, '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2012, 1007, 'Plasmodium vivax', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2013, 1007, 'P. vivax', 'en', 'SHORT', 1, NOW(), 0, '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3007, 1007, 'Malaria parasite species Plasmodium vivax', 'en', 1, NOW(), 0, '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4007, 1007, 1, '116124', 1, NOW(), '116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 8. LLIN bednet usage (160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1008, '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2014, 1008, 'LLIN bednet usage', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2015, 1008, 'LLIN usage', 'en', 'SHORT', 1, NOW(), 0, '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3008, 1008, 'Whether the patient uses a Long-Lasting Insecticidal Net (MILDA)', 'en', 1, NOW(), 0, '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4008, 1008, 1, '160428', 1, NOW(), '160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 9. Antimalarial medication prescribed (1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1009, '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2016, 1009, 'Antimalarial medication prescribed', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2017, 1009, 'Antimalarial', 'en', 'SHORT', 1, NOW(), 0, '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3009, 1009, 'Antimalarial medication selected for this consultation', 'en', 1, NOW(), 0, '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4009, 1009, 1, '1282', 1, NOW(), '1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 10. Discharged (159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1010, '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2018, 1010, 'Discharged', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3010, 1010, 'Patient discharged home after consultation', 'en', 1, NOW(), 0, '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4010, 1010, 1, '159492', 1, NOW(), '159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 11. Severe malaria (116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1011, '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2019, 1011, 'Severe malaria', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3011, 1011, 'Severe (complicated) malaria per WHO classification', 'en', 1, NOW(), 0, '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4011, 1011, 1, '116126', 1, NOW(), '116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;

-- 12. Patient disposition (160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
INSERT INTO concept (concept_id, uuid, retired, datatype_id, class_id, creator, date_created, changed_by, date_changed)
VALUES (1012, '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 0, 8, 10, 1, NOW(), 1, NOW())
ON DUPLICATE KEY UPDATE retired=0;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2020, 1012, 'Patient disposition', 'en', 'FULLY_SPECIFIED', 1, NOW(), 0, '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAB')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_name (concept_name_id, concept_id, name, locale, concept_name_type, creator, date_created, voided, uuid)
VALUES (2021, 1012, 'Disposition', 'en', 'SHORT', 1, NOW(), 0, '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAC')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO concept_description (concept_description_id, concept_id, description, locale, creator, date_created, voided, uuid)
VALUES (3012, 1012, 'Disposition at end of consultation (discharged / admitted / referred)', 'en', 1, NOW(), 0, '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAD')
ON DUPLICATE KEY UPDATE description=description;

INSERT INTO concept_reference_map (concept_reference_map_id, concept_id, concept_reference_source_id, source_code, creator, date_created, uuid)
VALUES (4012, 1012, 1, '160430', 1, NOW(), '160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
ON DUPLICATE KEY UPDATE source_code=source_code;
