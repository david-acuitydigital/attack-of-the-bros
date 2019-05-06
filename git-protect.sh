#!/bin/sh
if [[ -z "${GIT_TOKEN}" ]] ; then
  echo "Please run 'export GIT_TOKEN=<your git token>' before running script"
  exit 1
fi

protect () {
    OWNER=${1}
    REPO=${2}
    BRANCH=${3}
    GITHUB_URL=https://api.github.com
    URL="${GITHUB_URL}/repos/${OWNER}/${REPO}/branches/${BRANCH}"
    echo "==============================================================================================================="
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

curl -H "Authorization: token ${GIT_TOKEN}" -s "https://api.github.com/orgs/CenturyLinkCloud/repos?type=member&sort=full_name&direction=asc&page=16" | jq -r '.[] | "update_repo ${REPO_OWNER} \(.name)"' | grep mos > mos-repos.txt
curl -H "Authorization: token ${GIT_TOKEN}" -s "https://api.github.com/orgs/CenturyLinkCloud/repos?type=member&sort=full_name&direction=asc&page=17" | jq -r '.[] | "update_repo ${REPO_OWNER} \(.name)"' | grep mos >> mos-repos.txt
curl -H "Authorization: token ${GIT_TOKEN}" -s "https://api.github.com/orgs/CenturyLinkCloud/repos?type=member&sort=full_name&direction=asc&page=18" | jq -r '.[] | "update_repo ${REPO_OWNER} \(.name)"' | grep mos >> mos-repos.txt
curl -H "Authorization: token ${GIT_TOKEN}" -s "https://api.github.com/orgs/CenturyLinkCloud/repos?type=member&sort=full_name&direction=asc&page=19" | jq -r '.[] | "update_repo ${REPO_OWNER} \(.name)"' | grep mos >> mos-repos.txt
curl -H "Authorization: token ${GIT_TOKEN}" -s "https://api.github.com/orgs/CenturyLinkCloud/repos?type=member&sort=full_name&direction=asc&page=20" | jq -r '.[] | "update_repo ${REPO_OWNER} \(.name)"' | grep mos >> mos-repos.txt

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
update_repo ${REPO_OWNER} mos-missing-recon-metric
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
# mos-documentation
# mos-elasticbox
# mos-end-to-end-testing
# mos-etcd-config-utility
# mos-event-enrichment-api
# mos-kubernetes-infrastructure
# mos-micro-services
# mos-missing_recon_metric
# mos-monitoring
# mos-pyutils
# mos-remote-admin-service
# mos-reconciliation-listener
# mos-sddc
# mos-server-update-webhook
# mos-spi-poc
# mos-server-update-listener
# mos-vpn-hub-api