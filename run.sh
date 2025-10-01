REPO="$1"

./1-get-artifacts.sh $REPO > artifacts.json
./2-total-size.sh artifacts.json
./3-delete-artifacts.sh artifacts.json
