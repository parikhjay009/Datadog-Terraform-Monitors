# 1. CRITICAL: Any pod crash (app down)
resource "datadog_monitor" "pod_crash" {
  name    = "EKS {{cluster_name}} Pod Crash"
  type    = "query alert"
  query   = "max(last_5m):max:kubernetes_state.pod_status_phase{cluster_name:${var.cluster_name},phase:failed} > 0"
  message = "CRITICAL: Pods crashing in {{cluster_name}}. Check: https://app.datadoghq.com/infrastructure?query=cluster_name:${var.cluster_name}"
  tags    = ["env:${var.environment}", "team:sre", "priority:critical"]

  monitor_thresholds {
    critical = 0
    warning  = 0
  }

  priority = 4  # Highest
  notify_no_data = true
}

# 2. CRITICAL: RDS CPU >90%
resource "datadog_monitor" "rds_cpu" {
  name    = "RDS PostgreSQL CPU Overloaded"
  type    = "query alert"
  query   = "avg(last_5m):avg:aws.rds.cpuutilization{dbinstanceidentifier:your-postgres-rds} > 90"
  message = "CRITICAL: RDS CPU >90%. Scale instance or investigate slow queries."
  tags    = ["env:${var.environment}", "service:database", "priority:critical"]

  monitor_thresholds {
    critical = 90
    warning  = 80
  }
  priority = 4
}

# 3. CRITICAL: GraphQL Error Rate
resource "datadog_monitor" "graphql_errors" {
  name    = "GraphQL Error Rate Spike"
  type    = "query alert"
  query   = "avg(last_5m):avg:elixir.graphql_errors_total_rate{env:${var.environment}} / avg:elixir.graphql_requests_total_rate{env:${var.environment}} * 100 > 5"
  message = "CRITICAL: GraphQL error rate {{value}}%. Check app logs and traces."
  tags    = ["env:${var.environment}", "service:graphql", "priority:critical"]

  monitor_thresholds {
    critical = 5  # 5% errors
    warning  = 2
  }
  priority = 4
}

# 4. WARNING: Pods Pending (capacity)
resource "datadog_monitor" "pod_pending" {
  name    = "EKS Pods Pending"
  type    = "query alert"
  query   = "max(last_10m):max:kubernetes_state.pod_status_phase{cluster_name:${var.cluster_name},phase:Pending} by {pod_name} > 2"
  message = "Pods pending >2min. Node capacity issue?"
  tags    = ["env:${var.environment}", "priority:warning"]

  monitor_thresholds {
    warning  = 2
    critical = 5
  }
}

# 5. WARNING: High Latency P95
resource "datadog_monitor" "p95_latency" {
  name    = "GraphQL P95 Latency"
  type    = "query alert"
  query   = "p95(last_5m):trace.graphql.request.duration{env:${var.environment}} > 2000"
  message = "GraphQL P95 latency >2s. Check traces."
  tags    = ["env:${var.environment}", "service:graphql", "priority:warning"]

  monitor_thresholds {
    warning  = 2000  # 2s
    critical = 5000  # 5s
  }
}
