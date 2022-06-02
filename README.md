# Hub of Hubs E2E

[![Build](https://img.shields.io/badge/build-Prow-informational)](https://prow.ci.openshift.org/?repo=stolostron%2F${hub-of-hubs-e2e})

## Setup E2E Testing Environment
  
  Install hub-of-hubs from ACM 2.5+


## Running E2E Testing

1. Before you run the E2E, make sure [ginkgo](https://github.com/onsi/ginkgo) is installed:

```
go get -u github.com/onsi/ginkgo/ginkgo
```
2. Set the following environment variables for the testing
```
# hub-of-hubs config
KUBECONFIG=
CONTEXT=

# managedcluster1 config
IMPORTED1_LEAF_HUB_NAME=
IMPORTED1_NAME=
IMPORTED1_KUBECONFIG=
IMPORTED1_CONTEXT=
IMPORTED1_LEAF_HUB_NAME=

# managedcluster2 config
IMPORTED2_LEAF_HUB_NAME=
IMPORTED2_NAME=
IMPORTED2_KUBECONFIG=
IMPORTED2_CONTEXT=
```

3. Then, then test components with make CLI. You can also use the verbose to trace more detail, e.g. `make connenction verbose=6`
```
make connection
make label
make policy
make app
```

4. The tests result is located in the <project_root>/resources/result