provider "aws" {
  region  = "us-west-2"
  profile = "dev"
}

data "aws_instance" "foo" {
    // instance_id = "i-0bb13c5d8e2663b67"

    filter {
        name   = "image-id"
        values = ["ami-0470ffc25105508d0"]
    }

    filter {
        name   = "tag:Name"
        values = ["webapp"]
    }
}
resource "aws_route53_record" "www" {
    zone_id = "Z00145111G8Q06ZF6OEKT"
    name    = "dev.njaniketh.me"
    type    = "A"
    ttl     = "300"
    records = [data.aws_instance.foo.public_ip]
}
