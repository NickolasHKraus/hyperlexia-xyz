#!/usr/bin/env bash
#
# Deploy hyperlexia.xyz to AWS
#
# usage: deploy.sh
#

# change directory to project root
cd $HOME/NickolasHKraus/hyperlexia-xyz

# set S3 bucket
S3_BUCKET_ROOT=$(aws cloudformation describe-stack-resources \
--stack-name hyperlexia-xyz \
--query 'StackResources[?LogicalResourceId==`S3BucketRoot`].PhysicalResourceId' \
| grep -o -E "[a-zA-Z0-9/-]+")

# set CloudFront distribution ID
CF_DISTRIBUTION_ID=$(aws cloudformation describe-stack-resources \
--stack-name hyperlexia-xyz \
--query 'StackResources[?LogicalResourceId==`CloudFrontDistribution`].PhysicalResourceId' \
| grep -o -E "[a-zA-Z0-9/-]+")

# remove static files
rm -rf $PWD/public

# build static files
hugo

# remove files from S3
aws s3 rm s3://$S3_BUCKET_ROOT --recursive

# sync files with S3
aws s3 sync --acl "public-read" public/ s3://$S3_BUCKET_ROOT

# invalidate cloudfront cache
aws cloudfront create-invalidation --distribution-id $CF_DISTRIBUTION_ID --paths "/*"
