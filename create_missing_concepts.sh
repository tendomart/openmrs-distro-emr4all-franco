#!/bin/bash
# Create missing concepts via OpenMRS REST API
# Usage: ./create_missing_concepts.sh <username> <password>

BASE_URL="${BASE_URL:-http://demo-emr4all.org/openmrs/ws/rest/v1}"
USERNAME="${1:-admin}"
PASSWORD="${2:-Admin123}"

echo "Creating missing concepts via REST API..."
echo "========================================"

# Function to create a concept
create_concept() {
  local uuid="$1"
  local name="$2"
  local short_name="$3"
  local description="$4"
  local datatype="$5"
  local class="$6"
  local ciel_mapping="$7"
  
  # Map datatype names to OpenMRS datatype UUIDs
  case "$datatype" in
    "Numeric") datatype_uuid="8d4f4cba-c2cc-11de-8d13-0010c6dffd0f" ;;
    "Coded") datatype_uuid="8d4f4cba-c2cc-11de-8d13-0010c6dffd0f" ;;
    "N/A") datatype_uuid="8d4f4cba-c2cc-11de-8d13-0010c6dffd0f" ;;
    *) datatype_uuid="8d4f4cba-c2cc-11de-8d13-0010c6dffd0f" ;;
  esac
  
  # Map class names to OpenMRS class UUIDs
  case "$class" in
    "Finding") class_uuid="d013be2a-8377-4c5f-b341-43d28c94d2fe" ;;
    "Diagnosis") class_uuid="d013be2a-8377-4c5f-b341-43d28c94d2fe" ;;
    "Question") class_uuid="d013be2a-8377-4c5f-b341-43d28c94d2fe" ;;
    "Drug") class_uuid="d013be2a-8377-4c5f-b341-43d28c94d2fe" ;;
    "Misc") class_uuid="d013be2a-8377-4c5f-b341-43d28c94d2fe" ;;
    *) class_uuid="d013be2a-8377-4c5f-b341-43d28c94d2fe" ;;
  esac
  
  # Build JSON payload
  json_payload=$(cat <<EOF
{
  "uuid": "$uuid",
  "names": [
    {
      "name": "$name",
      "locale": "en",
      "conceptNameType": "FULLY_SPECIFIED"
    },
    {
      "name": "$short_name",
      "locale": "en",
      "conceptNameType": "SHORT"
    }
  ],
  "descriptions": [
    {
      "description": "$description",
      "locale": "en"
    }
  ],
  "datatype": "$datatype_uuid",
  "class": "$class_uuid",
  "mappings": [
    {
      "source": "CIEL",
      "code": "${ciel_mapping#CIEL:}",
      "uuid": "${uuid}0001"
    }
  ]
}
EOF
)

  echo "Creating concept: $name ($uuid)"
  response=$(curl -s -w "\n%{http_code}" -X POST \
    -H "Content-Type: application/json" \
    -u "$USERNAME:$PASSWORD" \
    -d "$json_payload" \
    "$BASE_URL/concept")
  
  http_code="${response##*$'\n'}"
  body="${response%$'\n'*}"
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    echo "  ✓ Created successfully"
  else
    echo "  ✗ Failed (HTTP $http_code): $body"
  fi
}

# Create the 12 missing concepts
create_concept "161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Artemether-Lumefantrine" "AL" "Artemether-Lumefantrine combination (ACT) for uncomplicated malaria" "N/A" "Drug" "CIEL:161350"

create_concept "162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Malaria danger signs" "Danger signs" "Danger signs observed during malaria consultation (multi-select)" "Coded" "Finding" "CIEL:162568"

create_concept "160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Malaria classification" "Classification" "Final malaria classification (uncomplicated vs severe)" "Coded" "Question" "CIEL:160108"

create_concept "152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Unable to drink or breastfeed" "Cannot drink/breastfeed" "Patient is unable to drink or breastfeed (IMCI danger sign)" "N/A" "Finding" "CIEL:152761"

create_concept "160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Plasmodium species" "Species" "Plasmodium species identified on microscopy/RDT" "Coded" "Question" "CIEL:160101"

create_concept "71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Artesunate" "Artesunate" "Artesunate (IV or parenteral) used for severe malaria" "N/A" "Drug" "CIEL:71100"

create_concept "116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Plasmodium vivax" "P. vivax" "Malaria parasite species Plasmodium vivax" "N/A" "Diagnosis" "CIEL:116124"

create_concept "160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "LLIN bednet usage" "LLIN usage" "Whether the patient uses a Long-Lasting Insecticidal Net (MILDA)" "Coded" "Question" "CIEL:160428"

create_concept "1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Antimalarial medication prescribed" "Antimalarial" "Antimalarial medication selected for this consultation" "Coded" "Question" "CIEL:1282"

create_concept "159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Discharged" "Discharged" "Patient discharged home after consultation" "N/A" "Misc" "CIEL:159492"

create_concept "116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Severe malaria" "Severe malaria" "Severe (complicated) malaria per WHO classification" "N/A" "Diagnosis" "CIEL:116126"

create_concept "160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "Patient disposition" "Disposition" "Disposition at end of consultation (discharged / admitted / referred)" "Coded" "Question" "CIEL:160430"

echo ""
echo "========================================"
echo "Done. Verify with: ./probe_remote_concepts.sh $USERNAME $PASSWORD"
