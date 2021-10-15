#!/bin/bash

sudo su
cd /
mkdir builds
cd builds
echo 'This is definitely a valid build' > pretendThisIsABuild.txt
aws s3 cp pretendThisIsABuild.txt s3://${s3_bucket_name}/androidBuilds/