#!/usr/bin/env bash

docker login -u barkinggecko
docker build --pull --no-cache --tag barkinggecko/aws-cdk-devcontainer:latest .
docker push barkinggecko/aws-cdk-devcontainer:latest