

#! /bin/bash

helm install vllm vllm-stack  --create-namespace -n vllm -f vllm-stack/values-gke.yaml

helm upgrade vllm vllm-stack  --create-namespace -n vllm -f vllm-stack/values-gke.yaml

helm template vllm vllm-stack/ -f vllm-stack/values-gke.yaml --output-dir=./outputs

k get 