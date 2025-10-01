REPO="$1"

gh api --paginate repos/$REPO/actions/artifacts
