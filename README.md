# AIonK8sDemo
The task is to deploy the large language model “Dolly v2 3b” as an API on the Kubernetes cluster

## Summary
Databricks' dolly-v2-3b, an instruction-following large language model trained on the Databricks machine learning platform that is licensed for commercial use. Based on pythia-2.8b, Dolly is trained on ~15k instruction/response fine tuning records databricks-dolly-15k generated by Databricks employees in capability domains from the InstructGPT paper, including brainstorming, classification, closed QA, generation, information extraction, open QA and summarization. dolly-v2-3b is not a state-of-the-art model, but does exhibit surprisingly high quality instruction following behavior not characteristic of the foundation model on which it is based.

## Model Overview
dolly-v2-3b is a 2.8 billion parameter causal language model created by Databricks that is derived from EleutherAI's Pythia-2.8b and fine-tuned on a ~15K record instruction corpus generated by Databricks employees and released under a permissive license (CC-BY-SA)

## Goal to achieve
1. Setup Environment on Azure by IaC
2. Build all necessary components by scripts, IaC and automation
3. Deliver to K8s/Aks Environment
4. Deliver to production ready environment


## Steps
1. setup initial environment for terraform to deploy infra resource. resources like backend, vnet, resource group etc.
    a.  remote backend state
    b.  basic resource group, vnet, subnet
    c.  github action/ workflows for CI/CD pipeline
    d.  local azure credentials and github action variables/secrets
    e.  setup .gitignore files
    f.  install pre-commit, hooks for better efficiency.
    g.  setup git remote and git push upstream

2. setup aks cluster, acr and role