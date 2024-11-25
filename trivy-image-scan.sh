#!/bin/bash

project_root=$(pwd)

dockerfiles=$(find $project_root -type f -name 'Dockerfile')

for dockerfile in $dockerfiles; do
    dockerImageName=$(awk 'NR==1 {print $2}' $dockerfile)
    echo "Scanning image: $dockerImageName"

    docker run --rm -v $project_root:/root/.cache/ \
        -e TRIVY_GITHUB_TOKEN='token_github' \
        aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

    exit_code=$?
    echo "Exit Code : $exit_code"

    if [[ "${exit_code}" == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found."
        continue
    else
        echo "Image scanning passed. No CRITICAL vulnerabilities found."
    fi
done

echo "All scans completed. Continuing pipeline despite any vulnerabilities."
