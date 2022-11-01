git checkout -b onboarding_${PROJECT-NAME}
echo ${TARGET_REPO}, ${SCRIPT_PATH}
cat /mnt/shared/data.yaml
kustomize init
git add -u
git commit -m "onboarding pr."
