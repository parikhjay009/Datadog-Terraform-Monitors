# Datadog Terraform Monitors for EKS / RDS / GraphQL Platform

This repository contains a starter set of Datadog monitors for a production platform running on AWS EKS, PostgreSQL on RDS, and a GraphQL API.

The monitor set is designed for systems with relatively low request volume but high-value transactions, where availability, correctness, and fast incident detection are more important than raw traffic scale.

## What is included

- Kubernetes pod failure monitor
- RDS CPU saturation monitor
- GraphQL error rate monitor
- Kubernetes pod pending monitor
- GraphQL p95 latency monitor

## Why these monitors matter

### 1. Pod crash monitor
This detects failed pods in the EKS cluster. If core application pods start failing, the service can quickly become unavailable.

### 2. RDS CPU monitor
This detects sustained database CPU saturation. Since the platform is a monolith backed by PostgreSQL, database contention can cause latency, timeouts, and failed transactions.

### 3. GraphQL error rate monitor
This measures API correctness from the client-facing layer. It is one of the most important service-level signals because it directly reflects user-visible failures.

### 4. Pod pending monitor
This detects scheduling pressure, insufficient node capacity, autoscaling failures, or invalid resource requests. It often provides early warning before customer impact becomes severe.

### 5. P95 latency monitor
This catches performance degradation before the platform is fully unavailable. Tail latency matters because slow requests can still create material business impact.

## Suggested alert severity

### Critical
- Pod crash for core production workloads
- RDS CPU above critical threshold
- GraphQL error rate above critical threshold

### Warning
- Pods pending for longer than expected
- P95 latency above warning threshold

## Files

- `variables.tf` for input variables
- `providers.tf` for Datadog provider
- `main.tf` for monitor resources


## How to use

1. Create a Datadog API key and application key.
2. Export them as environment variables or pass them through Terraform variables.
3. Replace the placeholder cluster name and RDS instance identifier.
4. Adjust thresholds based on your production baseline.
5. Run:

```bash
terraform init
terraform plan
terraform apply
```
