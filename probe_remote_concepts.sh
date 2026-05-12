#!/bin/bash
# Run this on the remote machine with your actual OpenMRS credentials
# Usage: ./probe_remote_concepts.sh <username> <password>

BASE_URL="${BASE_URL:-http://demo-emr4all.org/openmrs/ws/rest/v1}"
USERNAME="${1:-admin}"
PASSWORD="${2:-Admin123}"

echo "Probing concepts from malaria consultation form against $BASE_URL"
echo "========================================"

# All concept UUIDs from the form
declare -A CONCEPT_NAMES=(
  ["5089AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Weight (kg)"
  ["5088AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Temperature (°C)"
  ["162568AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Danger Signs"
  ["113054AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Convulsions"
  ["143050AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Lethargy/Unconsciousness"
  ["152761AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Unable to Drink/Breastfeed"
  ["122496AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Respiratory Distress"
  ["135595AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Persistent Vomiting"
  ["1643AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Test Performed"
  ["32AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Microscopy/Blood Smear"
  ["1138AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Test Result"
  ["703AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Positive"
  ["664AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Negative"
  ["887AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Parasite Density"
  ["160101AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Plasmodium Species"
  ["116125AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="P. falciparum"
  ["116124AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="P. vivax"
  ["160108AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Final Classification"
  ["116128AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Uncomplicated Malaria"
  ["116126AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Severe Malaria"
  ["1282AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Antimalarial Drug"
  ["161350AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="AL (Artemether-Lumefantrine)"
  ["160515AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="ASAQ (Artesunate-Amodiaquine)"
  ["71100AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="IV Artesunate"
  ["160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="LLIN Bednet Usage"
  ["1065AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Yes"
  ["1066AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="No"
  ["160430AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Disposition"
  ["159492AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Discharged Home"
  ["160523AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Admitted"
  ["159AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]="Referred"
)

MISSING=()
FOUND=()

for uuid in "${!CONCEPT_NAMES[@]}"; do
  name="${CONCEPT_NAMES[$uuid]}"
  response=$(curl -s -w "%{http_code}" -u "$USERNAME:$PASSWORD" "$BASE_URL/concept/$uuid?v=full")
  http_code="${response: -3}"
  
  if [ "$http_code" = "200" ]; then
    FOUND+=("$uuid - $name")
  else
    MISSING+=("$uuid - $name (HTTP $http_code)")
  fi
done

echo ""
echo "FOUND CONCEPTS (${#FOUND[@]}):"
for c in "${FOUND[@]}"; do
  echo "  ✓ $c"
done

echo ""
echo "MISSING CONCEPTS (${#MISSING[@]}):"
if [ ${#MISSING[@]} -eq 0 ]; then
  echo "  None - all concepts exist in database"
else
  for c in "${MISSING[@]}"; do
    echo "  ✗ $c"
  done
fi

echo ""
echo "========================================"
echo "Total: ${#CONCEPT_NAMES[@]} concepts, ${#FOUND[@]} found, ${#MISSING[@]} missing"

if [ ${#MISSING[@]} -gt 0 ]; then
  echo ""
  echo "To fix: Add missing concepts to distro/configuration/concepts/malaria_concepts.csv"
  echo "Then rebuild the backend container."
fi
