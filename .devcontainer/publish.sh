#!/usr/bin/env bash

docker login -u barkinggecko
docker build --tag barkinggecko/aws-cdk-devcontainer:latest .
docker push barkinggecko/aws-cdk-devcontainer:latest