set -o allexport
set -e
set -x
set -o pipefail

# Pre-condition:
# - Create the config file at location ${PAYLOAD_PATH}
# - Clone the github.com/operate-first/apps repo at location ${WORKING_DIR}

CONFIG=${PAYLOAD_PATH}
REPO=${WORKING_DIR}/apps

# Unpack Config file, we will need these environment variables for the remainder of the steps
PROJECT=$(yq e .project-name ${CONFIG})
ENVIRONMENT=moc
CLUSTER=$(yq e '.cluster[0] | downcase' ${CONFIG})
NAMESPACE=$(yq e '.project-name | downcase' ${CONFIG})
REQUESTER=$(yq e '.project-owner' ${CONFIG})
DISPLAY_NAME=$(yq e '.project-name' ${CONFIG})
PROJECT_OWNER=$(yq e '.project-owner' ${CONFIG})
ONBOARDING_ISSUE=https://github.com/${ORG_NAME}/${SOURCE_REPO}/issues/${ISSUE_NUMBER}
DOCS=$(yq e '.project-docs-link' ${CONFIG})
GROUP=$(yq e '.team-name' ${CONFIG})
USERS=$(yq '.users | split(",") | map(trim)' -o json -I=0 ${CONFIG})
QUOTA=$(yq e '.quota[0] | downcase' ${CONFIG})

echo ENVIRONMENT $ENVIRONMENT
echo CLUSTER $CLUSTER
echo NAMESPACE $NAMESPACE
echo REQUESTER $REQUESTER
echo DISPLAY_NAME $DISPLAY_NAME
echo PROJECT_OWNER $PROJECT_OWNER
echo ONBOARDING_ISSUE $ONBOARDING_ISSUE
echo DOCS $DOCS
echo GROUP $GROUP
echo USERS $USERS

# Create OCP Group for team being onboarded

GROUP_PATH="${REPO}/cluster-scope/base/user.openshift.io/groups/${GROUP}";
mkdir ${GROUP_PATH}
jsonnet --ext-str GROUP --ext-code USERS scripts/jsonnet/group.jsonnet | yq -P > ${GROUP_PATH}/group.yaml
cd ${GROUP_PATH}
kustomize init ${GROUP_PATH}
kustomize edit add resource group.yaml

# Create namespace for team being onboarded

cd ${REPO}
NAMESPACE_PATH="${REPO}/cluster-scope/base/core/namespaces/${NAMESPACE}/";
mkdir ${NAMESPACE_PATH}
jsonnet --ext-str NAMESPACE \
  --ext-str REQUESTER \
  --ext-str DISPLAY_NAME \
  --ext-str PROJECT_OWNER \
  --ext-str ONBOARDING_ISSUE \
  --ext-str DOCS \
  scripts/jsonnet/namespace.jsonnet | yq -P > ${NAMESPACE_PATH}/namespace.yaml
cd ${NAMESPACE_PATH}
kustomize init ${NAMESPACE_PATH}
kustomize edit add resource namespace.yaml
kustomize edit set namespace ${NAMESPACE}
kustomize edit add component ${REPO}/cluster-scope/components/limitranges/default
kustomize edit add component ${REPO}/cluster-scope/components/resourcequotas/${QUOTA}

# "Give the team being onboarded access to the Namespace via OCP rbac"

cd ${REPO}
RBAC_PATH="${REPO}/cluster-scope/components/project-admin-rolebindings/${GROUP}/"
mkdir ${RBAC_PATH}
jsonnet --ext-str GROUP --ext-code USERS scripts/jsonnet/rbac.jsonnet | yq -P > ${RBAC_PATH}/rbac.yaml
cd ${RBAC_PATH}
kustomize init ${RBAC_PATH}
kustomize edit add resource rbac.yaml

# Add rbac to the namespace being onboarded.

cd ${NAMESPACE_PATH}
kustomize edit add resource ${RBAC_PATH}

set -o allexport