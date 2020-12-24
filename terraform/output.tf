output "Wikimedia_URL" {
  description = "Wikimedia login instructions"
  value       = "Please access http://${aws_instance.mediawiki.public_ip}/mediawiki url once ec2 health checks are passed !!"
}