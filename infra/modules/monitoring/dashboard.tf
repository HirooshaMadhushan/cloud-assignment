resource "aws_cloudwatch_dashboard" "cloudmart" {
  dashboard_name = "CloudMart-Overview"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0
        y    = 0
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"
          title   = "CPU per Service"
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization", "Namespace", "cloudmart-${var.common_tags["Environment"]}", "PodName", "product-service"],
            ["ContainerInsights", "pod_cpu_utilization", "Namespace", "cloudmart-${var.common_tags["Environment"]}", "PodName", "order-service"],
            ["ContainerInsights", "pod_cpu_utilization", "Namespace", "cloudmart-${var.common_tags["Environment"]}", "PodName", "user-service"]
          ]
          period = 60
          stat   = "Average"
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 6
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"
          title   = "SQS Queue Depth (orders)"
          metrics = [["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "cloudmart-orders"]]
          period = 60
          stat   = "Sum"
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 12
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"
          title   = "RDS Connections"
          metrics = [["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "cloudmart-postgres"]]
          period = 60
          stat   = "Sum"
        }
      }
    ]
  })
}
