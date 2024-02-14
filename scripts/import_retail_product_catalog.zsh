#!/usr/bin/env zsh

################################################################################
# Environment Variables - Retail API Project
################################################################################

local RETAIL_PROJECT_ID="retail-search-demo-413002"
local RETAIL_PROJECT_NUMBER="355407052573"
local RETAIL_LOCATION="global"
local RETAIL_CATALOG="default_catalog"
local RETAIL_BRANCH="0"
local RETAIL_IMPORT_GCS_BUCKET="gs://fashion-retail-demo/product_catalog"
local RETAIL_BQ_DATASET="fashion"

local RETAIL_TMP_DIR="${0:A:h}/../tmp"
RETAIL_TMP_DIR="${RETAIL_TMP_DIR:A}"


################################################################################
# Import Retail Product Catalog - From BigQuery
#     Reconciliation Mode set to FULL - Insert, Update and Deletes
################################################################################

# Delete Any Files Previously Staged Product Catalog
gsutil -q -m rm -rf "${RETAIL_IMPORT_GCS_BUCKET}/staging"

# Output the Import Product Catalog JSON Request Object
cat <<EOF > "$RETAIL_TMP_DIR/import_product_catalog_request.json"
{
  "reconciliationMode": "FULL",
  "inputConfig": {
    "bigQuerySource": {
      "projectId": "${RETAIL_PROJECT_ID}",
      "datasetId": "${RETAIL_BQ_DATASET}",
      "tableId": "retail_product_catalog",
      "gcsStagingDir": "${RETAIL_IMPORT_GCS_BUCKET}/staging",
      "dataSchema": "product"
    }
  },
  "errorsConfig": {
    "gcsPrefix": "${RETAIL_IMPORT_GCS_BUCKET}/errors"
  }
}
EOF

curl -X POST \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token --project=${RETAIL_PROJECT_ID})" \
-H "x-goog-user-project: ${RETAIL_PROJECT_ID}" \
-H "Content-Type: application/json; charset=utf-8" -d @"$RETAIL_TMP_DIR/import_product_catalog_request.json" \
"https://retail.googleapis.com/v2/projects/${RETAIL_PROJECT_NUMBER}/locations/${RETAIL_LOCATION}/catalogs/${RETAIL_CATALOG}/branches/${RETAIL_BRANCH}/products:import"
