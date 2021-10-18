#!/bin/bash

# pull down source repo
sudo yum install git -y
git clone ${repo_url}

# TO-DO: build apk using command line here

# Install Platform Tools
# wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
# sudo su
# mkdir -p /opt/platform-tools
# unzip platform-tools-latest-linux.zip -d /opt/platform-tools

# Install SDK
# wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
# mkdir -p /opt/android-sdk
# unzip sdk-tools-linux-3859397.zip -d /opt/android-sdk

# Make a fake .apk file
cd /
mkdir builds
cd builds
echo 'This is definitely a valid build' > pretendThisIsABuild.apk
aws s3 cp pretendThisIsABuild.apk s3://${s3_bucket_name}/androidBuilds/

# Terminate this instance automatically when finished
export EC2_INSTANCE_ID=$(ec2-metadata -i | cut -d " " -f 2)
aws configure set default.region us-west-2
aws ec2 terminate-instances --instance-ids $EC2_INSTANCE_ID