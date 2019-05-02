#!/bin/sh
STATE=$1
COMMIT=$2
CONTEXT="Unit Tests - Jenkins"
GITHUB_URL=https://api.github.com/repos/david-acuitydigital/attack-of-the-bros/statuses
BUILD_URL="https://jenkins.ctnr.ctl.io"
if [[ -z "${STATE}" ]] || [[ -z "${COMMIT}" ]] || [[ -z "${REPO_USER}" ]] || [[ -z "${REPO_PASSWORD}" ]] ; then
  echo "Usage:"
  echo "git-status.sh state commit"
  echo '  state - state of the status vaild values are "success", or "failure"'
  echo '  commit - The commit number to which to apply the status'
  echo '** NOTE REPO_USER and REPO_PASSWORD must be exported environment variables for a user with access to ${GITHUB_URL}'
  exit 1
fi

curl -s -u ${REPO_USER}:${REPO_PASSWORD} -X POST --header "Content-Type: application/json" --data "{\"state\": \"${STATE}\", \"target_url\": \"${BUILD_URL}\", \"context\": \"${CONTEXT}\"}" ${GITHUB_URL}/${COMMIT}