#!/usr/bin/env bash
git clone https://x-access-token:${GITHUB_TOKEN}@github.com/${ORG_NAME}/${REPO_NAME}
cd ${REPO_NAME}
git checkout -b onboarding_${PROJECT-NAME}
kustomize init
git add -u
git commit -m "onboarding pr."
