set -e

ROOTDIR="$(cd "$(dirname "$0")/.." ; pwd -P)"

echo $KUBECONFIG
if [[ -z "${KUBECONFIG}" ]]; then
  echo "Error: environment variable KUBECONFIG must be specified!"
  exit 1
fi

if [[ -z "${CONTEXT}" ]]; then
  echo "Error: environment variable KUBECONFIG must be specified!"
  exit 1
fi

if [[ -z "${IMPORTED1_KUBECONFIG}" ]]; then
  echo "Error: environment variable IMPORTED1_KUBECONFIG must be specified!"
  exit 1
fi

if [[ -z "${IMPORTED1_CONTEXT}" ]]; then
  echo "Error: environment variable IMPORTED1_CONTEXT must be specified!"
  exit 1
fi

if [[ -z "${IMPORTED2_KUBECONFIG}" ]]; then
  echo "Error: environment variable IMPORTED2_KUBECONFIG must be specified!"
  exit 1
fi

if [[ -z "${IMPORTED2_CONTEXT}" ]]; then
  echo "Error: environment variable IMPORTED2_CONTEXT must be specified!"
  exit 1
fi

# hub cluster
hub_cluster_name="hub-of-hub-cluster"
hub_kubeconfig="${ROOTDIR}/resources/kubeconfig/kubeconfig-hub"
kubectl config view --raw --minify --kubeconfig ${KUBECONFIG} --context ${CONTEXT} > ${hub_kubeconfig}

hub_app_domain=$(kubectl -n openshift-ingress-operator get ingresscontrollers default -ojsonpath='{.status.domain}'  --kubeconfig ${KUBECONFIG} --context ${CONTEXT})
hub_base_domain="${hub_app_domain#apps.}"
hub_kubeMasterURL=$(kubectl config view -o jsonpath="{.clusters[0].cluster.server}" --kubeconfig ${KUBECONFIG} --context ${CONTEXT} )
hub_kubecontext=$(kubectl config current-context --kubeconfig ${hub_kubeconfig})
hub_database_secret="hub-of-hubs-database-secret"
hub_namespace="open-cluster-management"

# leaf hub name
leaf_hub_name="kind-hub1"

# imported managedcluster1
managed1_cluster_name="kind-hub1-cluster1"
managed1_kubeconfig="${ROOTDIR}/resources/kubeconfig/kubeconfig-managed1"
kubectl config view --raw --minify --kubeconfig ${IMPORTED1_KUBECONFIG} --context ${IMPORTED1_CONTEXT} > ${managed1_kubeconfig}
managed1_kubecontext=$(kubectl config current-context --kubeconfig ${managed1_kubeconfig})

# imported managedcluster2
managed2_cluster_name="kind-hub1-cluster2"
managed2_kubeconfig="${ROOTDIR}/resources/kubeconfig/kubeconfig-managed2"
kubectl config view --raw --minify --kubeconfig ${IMPORTED2_KUBECONFIG} --context ${IMPORTED2_CONTEXT} > ${managed2_kubeconfig}
managed2_kubecontext=$(kubectl config current-context --kubeconfig ${managed2_kubeconfig})

# remove the options file if it exists
rm -f resources/options.yaml

printf "options:" >> resources/options.yaml
printf "\n  hub:" >> resources/options.yaml
printf "\n    name: ${hub_cluster_name}" >> resources/options.yaml
printf "\n    namespace: ${hub_namespace}" >> resources/options.yaml
printf "\n    masterURL: ${hub_kubeMasterURL}" >> resources/options.yaml
printf "\n    kubeconfig: ${hub_kubeconfig}" >> resources/options.yaml
printf "\n    kubecontext: ${hub_kubecontext}" >> resources/options.yaml
printf "\n    baseDomain: ${hub_base_domain}" >> resources/options.yaml
printf "\n    databaseSecret: ${hub_database_secret}" >> resources/options.yaml
printf "\n  clusters:" >> resources/options.yaml
printf "\n    - name: ${managed1_cluster_name}" >> resources/options.yaml
printf "\n      kubeconfig: ${managed1_kubeconfig}" >> resources/options.yaml
printf "\n      kubecontext: ${managed1_kubecontext}" >> resources/options.yaml
printf "\n      leafhubname: ${leaf_hub_name}" >> resources/options.yaml
printf "\n    - name: ${managed2_cluster_name}" >> resources/options.yaml
printf "\n      kubeconfig: ${managed2_kubeconfig}" >> resources/options.yaml
printf "\n      kubecontext: ${managed2_kubecontext}" >> resources/options.yaml
printf "\n      leafhubname: ${leaf_hub_name}" >> resources/options.yaml


ginkgo ${ROOTDIR}/pkg/test -p -- -options=${ROOTDIR}/resources/options.yaml -v=5 