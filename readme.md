# gh-delete-artifacts

Scripts for deleting GitHub Action artifacts.

## Usage

### Just start deleting

```
./run.sh <owner>/<repo>
```

### Get the artifacts as a json

```
./1-get-artifacts.sh <owner>/<repo> > artifacts.json
```

### Get the size of all the artifacts

```
./2-total-size.sh artifacts.json
```

Requires the [human_bytes](https://crates.io/crates/human_bytes/0.4.3) cli to be installed.

### Delete the artifacts

```
./3-delete-artifacts.sh artifacts.json
```
