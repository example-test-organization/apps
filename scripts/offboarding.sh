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


# Remove OCP Group for team being onboarded
GROUP_PATH="${REPO}/cluster-scope/base/user.openshift.io/groups/${GROUP}";
rm ${GROUP_PATH} -rf

# Remove namespace for team being onboarded
NAMESPACE_PATH="${REPO}/cluster-scope/base/core/namespaces/${NAMESPACE}/";
rm ${NAMESPACE_PATH} -rf

# "Give the team being onboarded access to the Namespace via OCP rbac"

RBAC_PATH="${REPO}/cluster-scope/components/project-admin-rolebindings/${GROUP}/"
rm ${RBAC_PATH} -rf

# Remove from cluster
# TODO

set -o allexport