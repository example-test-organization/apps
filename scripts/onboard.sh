PAYLOAD=${WORKING_DIR}/data.yaml
PROJECT=$(yq e .project-name ${PAYLOAD})

ENVIRONMENT=moc
CLUSTER=$(yq e .cluster[0] ${PAYLOAD})
NAMESPACE=$(yq e .project-name ${PAYLOAD})
REQUESTER=$(yq e .project-owner ${PAYLOAD})
DISPLAY_NAME=$(yq e .project-name ${PAYLOAD})
PROJECT_OWNER=$(yq e .project-owner ${PAYLOAD})
ONBOARDING_ISSUE=https://github.com/${ORG_NAME}/${SOURCE_REPO}/issues/${ISSUE_NUMBER}
DOCS=$(yq e .project-docs-link ${PAYLOAD})
GROUP=$(yq e .team-name ${PAYLOAD})
USERS=$(yq '.users | split(",") | map(trim)' -o json -I=0 ${PAYLOAD})


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

scripts/create_jsonnet_group.sh
scripts/create_namespace.sh
scripts/create_rbac.sh
scripts/create_namespace_rbac.sh
