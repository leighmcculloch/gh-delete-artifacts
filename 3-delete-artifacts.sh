#!/bin/bash

# Script to delete GitHub Actions artifacts based on IDs from artifacts.json
# Usage: ./delete_artifacts.sh [start_index]
#   start_index: Optional. Number of artifacts to skip before starting (default: 0)
# Requires GitHub CLI (gh) to be installed and authenticated

set -e

FILE="$1"
REPO="$(jq -s -r '[.[].artifacts[0].url | split("/")[4] + "/" + split("/")[5]][0]' artifacts.json)"

# Get the starting index from the first argument, default to 0
START_INDEX=${2:-0}

# Extract artifact IDs from all JSON objects in the file
# The file contains multiple JSON objects concatenated together
ARTIFACT_IDS=$(jq -s '.[].artifacts[].id' $FILE | sort | uniq)

TOTAL=$(echo "$ARTIFACT_IDS" | wc -l)
echo "Found $TOTAL unique artifacts to delete"
echo "Starting from index: $START_INDEX (skipping first $START_INDEX artifacts)"

# GitHub API rate limit is 5000 requests per hour for authenticated users
# We'll add a small delay between requests to be safe
COUNT=0
for ID in $ARTIFACT_IDS; do
    COUNT=$((COUNT + 1))
    
    # Skip artifacts before the start index
    if [ $COUNT -le $START_INDEX ]; then
        echo "Skipping artifact $COUNT/$TOTAL: ID $ID"
        continue
    fi
    
    echo "Deleting artifact $COUNT/$TOTAL: ID $ID"

    # Use gh CLI to delete the artifact
    if gh api repos/$REPO/actions/artifacts/$ID -X DELETE --silent; then
        echo "✓ Successfully deleted artifact $ID"
    else
        STATUS=$?
        echo "✗ Failed to delete artifact $ID (exit code: $STATUS)"
    fi

    sleep 0.3
done

echo "Finished processing $TOTAL artifacts"
