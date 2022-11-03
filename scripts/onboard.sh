PAYLOAD=${WORKING_DIR}/data.yaml
PROJECT=$(yq e .project-name ${PAYLOAD})

ENVIRONMENT=moc
CLUSTER=$(yq e .cluster[0] ${PAYLOAD})
NAMESPACE=$(yq e .project-name ${PAYLOAD})
REQUESTER=gingersnap
DISPLAY_NAME="gingersnap"
PROJECT_OWNER=gingersnap
ONBOARDING_ISSUE=https://github.com/${ORG_NAME}/${SOURCE_REPO}/issues/${ISSUE_NUMBER}
DOCS=https://github.com/gingersnap-cloud
GROUP=gingersnap
USERS="['ryanemerson', 'pminz', 'tristantarrant', 'karesti', 'wburns', 'fax4ever', 'rigazilla', 'jabolina', 'pruivo', 'dpanshug']"

scripts/create_jsonnet_group.sh
scripts/create_namespace.sh
scripts/create_rbac.sh
scripts/create_namespace_rbac.sh
