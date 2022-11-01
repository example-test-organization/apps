# Pre-conditions:
# Working directory is cloned apps repo
#

PAYLOAD=${WORKING_DIR}/data.yaml
PROJECT=$(yq e .project-name ${PAYLOAD})
QUOTA=$(yq e .quota[0] ${PAYLOAD})

git checkout -b onboarding_${PROJECT}
echo Repo: ${TARGET_REPO}

echo Users:
yq e '.users = (.users | split(",")) ' data.yaml

kustomize init
git add -u
git commit -m "onboarding pr."
