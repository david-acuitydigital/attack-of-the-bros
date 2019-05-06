#!/bin/sh
if [[ -z "${GIT_TOKEN}" ]] ; then
  echo "Please set the GIT_TOKEN"
  exit 1
fi
protect () {
    OWNER=${1}
    REPO=${2}
    BRANCH=${3}
    GITHUB_URL=https://api.github.com
    URL="${GITHUB_URL}/repos/${OWNER}/${REPO}/branches/${BRANCH}"
    echo "==============================================================================================================="
    echo "GIT_TOKEN . . . : ${GIT_TOKEN: 0:1}********${GIT_TOKEN: -2:2}"
    echo "OWNER . . . . . : ${OWNER}"
    echo "REPO  . . . . . : ${REPO}"
    echo "BRANCH  . . . . : ${BRANCH}"
    echo "URL . . . . . . : ${URL}"
    echo "==============================================================================================================="
    echo "Protecting ${OWNER}/${REPO}/${BRANCH}...."
    echo "==============================================================================================================="
    export TO_URL=${URL}/protection
    export METHOD=PUT
    echo "Response:"

    ## Make Service Call to Protect Branch
    curl ${URL}/protection \
    -H "Authorization: token ${GIT_TOKEN}" \
    -H "Accept: application/vnd.github.luke-cage-preview+json" \
    -X ${METHOD} \
    -d \
    '{
       "enabled": true,
       "required_status_checks":{
         "strict":true,
         "contexts":[
           "Unit Tests - Jenkins"
         ]
       },
       "required_pull_request_reviews":{
         "dismiss_stale_reviews":true,
         "require_code_owner_reviews":false,
         "required_approving_review_count": 1
       },
       "enforce_admins": true,
       "restrictions": null
    }' \
    -s | jq .
    echo "==============================================================================================================="
}

default_branch () {
    OWNER=${1}
    REPO=${2}
    BRANCH=${3}
    GITHUB_URL=https://api.github.com
    URL="${GITHUB_URL}/repos/${OWNER}/${REPO}"
    echo "GIT_TOKEN . . . : ${GIT_TOKEN: 0:1}********${GIT_TOKEN: -2:2}"
    echo "OWNER . . . . . : ${OWNER}"
    echo "REPO  . . . . . : ${REPO}"
    echo "BRANCH  . . . . : ${BRANCH}"
    echo "URL . . . . . . : ${URL}"
    echo "==============================================================================================================="

    echo "Setting the default branch for ${OWNER}/${REPO} to ${BRANCH}...."
    echo "==============================================================================================================="
    export TO_URL=${URL}
    export METHOD=PATCH
    echo "Response:"

    ## Change Default Branch
    curl ${URL} \
    -H "Authorization: token ${GIT_TOKEN}" \
    -X ${METHOD} \
    -d "{\"default_branch\": \"${BRANCH}\"}" \
    -s  | jq '{owner:.owner.login, name: .name, default_branch: .default_branch}'
    echo "==============================================================================================================="
}

update_repo() {
    protect ${1} ${2} master
    protect ${1} ${2} dev
    default_branch ${1} ${2} dev
}

REPO_OWNER=CenturyLinkCloud

update_repo ${REPO_OWNER} mos-active-directory-service
update_repo ${REPO_OWNER} mos-appliance-service
update_repo ${REPO_OWNER} mos-billing-listener
update_repo ${REPO_OWNER} mos-billing-service
update_repo ${REPO_OWNER} mos-certificate-services
update_repo ${REPO_OWNER} mos-change-integration-service
update_repo ${REPO_OWNER} mos-cmdb-application-listener
update_repo ${REPO_OWNER} mos-cmdb-reconciliation-listener
update_repo ${REPO_OWNER} mos-commander-api
update_repo ${REPO_OWNER} mos-customer-site-api
update_repo ${REPO_OWNER} mos-datacenter-service
update_repo ${REPO_OWNER} mos-dns-register-listener
update_repo ${REPO_OWNER} mos-dns-service
update_repo ${REPO_OWNER} mos-event-enrichment-service
update_repo ${REPO_OWNER} mos-event-listener
update_repo ${REPO_OWNER} mos-gateway-api
update_repo ${REPO_OWNER} mos-gateway-change-listener
update_repo ${REPO_OWNER} mos-managed-application-create-listener
update_repo ${REPO_OWNER} mos-managed-server-service
update_repo ${REPO_OWNER} mos-missing_recon_metric
update_repo ${REPO_OWNER} mos-monitoring-configuration-listener
update_repo ${REPO_OWNER} mos-monitoring-policy-service
update_repo ${REPO_OWNER} mos-network-services
update_repo ${REPO_OWNER} mos-notification-listener
update_repo ${REPO_OWNER} mos-remedy-server-listener
update_repo ${REPO_OWNER} mos-remedy-service
update_repo ${REPO_OWNER} mos-remote-admin-register-listener
update_repo ${REPO_OWNER} mos-retry-listener
update_repo ${REPO_OWNER} mos-runner-minion-service
update_repo ${REPO_OWNER} mos-server-create-listener
update_repo ${REPO_OWNER} mos-status-api
update_repo ${REPO_OWNER} mos-ticket-listener
update_repo ${REPO_OWNER} mos-ticket-service
update_repo ${REPO_OWNER} mos-vpn-access
update_repo ${REPO_OWNER} mos-watcher-listener
update_repo ${REPO_OWNER} mos-webhook-service

# Skipped Repositories
#update_repo ${REPO_OWNER} mos-documentation
#update_repo ${REPO_OWNER} mos-elasticbox
#update_repo ${REPO_OWNER} mos-end-to-end-testing
#update_repo ${REPO_OWNER} mos-etcd-config-utility
#update_repo ${REPO_OWNER} mos-event-enrichment-api
#update_repo ${REPO_OWNER} mos-kubernetes-infrastructure
#update_repo ${REPO_OWNER} mos-micro-services
#update_repo ${REPO_OWNER} mos-monitoring
#update_repo ${REPO_OWNER} mos-pyutils
#update_repo ${REPO_OWNER} mos-remote-admin-service
#update_repo ${REPO_OWNER} mos-reconciliation-listener
#update_repo ${REPO_OWNER} mos-sddc
#update_repo ${REPO_OWNER} mos-server-update-webhook
#update_repo ${REPO_OWNER} mos-spi-poc
#update_repo ${REPO_OWNER} mos-server-update-listener
#update_repo ${REPO_OWNER} mos-vpn-hub-api
