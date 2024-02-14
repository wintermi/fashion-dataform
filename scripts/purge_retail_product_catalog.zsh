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
# Purge Retail Product Catalog
################################################################################

# Output the Purge Product Catalog JSON Request Object
cat <<EOF > "$RETAIL_TMP_DIR/purge_product_catalog_request.json"
{
  "filter": "*",
  "force": true
}
EOF

curl -X POST \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token --project=${RETAIL_PROJECT_ID})" \
-H "x-goog-user-project: ${RETAIL_PROJECT_ID}" \
-H "Content-Type: application/json; charset=utf-8" -d @"$RETAIL_TMP_DIR/purge_product_catalog_request.json" \
"https://retail.googleapis.com/v2/projects/${RETAIL_PROJECT_NUMBER}/locations/${RETAIL_LOCATION}/catalogs/${RETAIL_CATALOG}/branches/${RETAIL_BRANCH}/products:purge"
