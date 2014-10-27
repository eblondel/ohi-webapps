#!/bin/bash
# -*- sh-basic-offset: 4; sh-indentation: 4 -*-
# tweaked from https://raw.githubusercontent.com/craigcitro/r-travis/master/scripts/travis-tool.sh

set -e
# Comment out this line for quieter output:
set -x

CalculateScores() {  
    Rscript ./subcountry2014/calculate_scores.R
}

PushChanges() {   
    if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
        git config user.name "${GIT_NAME}"
        git config user.email "${GIT_EMAIL}"
        git commit -a -m "auto-calculate from ${TRAVIS_COMMIT}"
        git remote set-url origin "https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git"
        git push origin HEAD:master
    fi
}


COMMAND=$1
echo "Running command: ${COMMAND}"
shift
case $COMMAND in
    ##
    ## Calculate OHI scores
    "calculate_scores")
        CalculateScores
        ;;
        
    ##
    ## Push OHI scores back to github
    "push_changes")
        PushChanges
        ;;

esac
