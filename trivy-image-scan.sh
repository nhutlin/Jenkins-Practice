#!/bin/bash

# Thư mục gốc của dự án
project_root=$(pwd)

# Tìm tất cả các Dockerfile trong thư mục dự án
dockerfiles=$(find $project_root -type f -name 'Dockerfile')

# Lặp qua tất cả các Dockerfile tìm được
for dockerfile in $dockerfiles; do
    # Lấy tên hình ảnh từ Dockerfile
    dockerImageName=$(awk 'NR==1 {print $2}' $dockerfile)
    echo "Scanning image: $dockerImageName"

    # Quét hình ảnh Docker sử dụng Trivy
    docker run --rm -v $project_root:/root/.cache/  -e TRIVY_GITHUB_TOKEN='token_github' aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

    # Xử lý kết quả quét
    exit_code=$?
    echo "Exit Code : $exit_code"

    # Kiểm tra kết quả quét
    if [[ "${exit_code}" == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found"
        exit 1;
    else
        echo "Image scanning passed. No CRITICAL vulnerabilities found"
    fi;
done
