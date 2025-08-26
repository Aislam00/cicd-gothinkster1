#!/bin/bash

ENV=${1:-dev}
IMAGE_TAG=${2:-latest}

echo "Deploying to $ENV environment..."

aws autoscaling start-instance-refresh \
    --auto-scaling-group-name "realworld-$ENV-app-asg" \
    --preferences MinHealthyPercentage=50 \
    --region eu-west-2

echo "Deployment triggered for $ENV"
