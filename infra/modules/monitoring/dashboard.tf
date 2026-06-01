resource "aws_cloudwatch_dashboard" "cloudmart" {
  dashboard_name = "CloudMart-Overview"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title  = "CPU per Service"
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization", "Namespace", "cloudmart-prod", "PodName", "product-service"],
            ["ContainerInsights", "pod_cpu_utilization", "Namespace", "cloudmart-prod", "PodName", "order-service"],
            ["ContainerInsights", "pod_cpu_utilization", "Namespace", "cloudmart-prod", "PodName", "user-service"]
          ]
          period = 60
          stat   = "Average"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "SQS Queue Depth (orders)"
          metrics = [["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "cloudmart-orders"]]
          period = 60
          stat   = "Sum"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "RDS Connections"
          metrics = [["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "cloudmart-postgres"]]
          period = 60
          stat   = "Sum"
        }
      }
    ]
  })
}
