locals {
    subnet_cidrs              = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
    subnet_availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = format("%s-%s", "vpc", "vpc_${terraform.workspace}")
    }
}

resource "aws_subnet" "subnet" {
    depends_on = [aws_vpc.vpc]
    count      = length(local.subnet_cidrs)

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = local.subnet_cidrs[count.index]
    availability_zone = local.subnet_availability_zones[count.index]
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = format("%s-%s", "igw", "igw_${terraform.workspace}")
    }
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = format("%s-%s", "rt", "rt_${terraform.workspace}")
    }
}

resource "aws_route_table_association" "route_association" {
    count          = length(local.subnet_cidrs)
    subnet_id      = element(aws_subnet.subnet.*.id, count.index)
    route_table_id = aws_route_table.route_table.id
}


resource "aws_security_group" "application" {
    name        = "application"
    description = "Application inbound traffic"
    vpc_id      = aws_vpc.vpc.id

    ingress = [
        {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        },
        {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        }, 
        {
        description      = "HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        },
        {
        description      = "TCP"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        }
    ]

    egress = [
        {
        description      = "for all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        }
    ]
}

resource "aws_security_group" "database" {
    name        = "database"
    description = "Database inbound traffic"
    vpc_id      = aws_vpc.vpc.id

    ingress = [
        {
        description      = "MySQL"
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = [aws_security_group.application.id]
        self             = false
        }
    ]

    egress = [
        {
        description      = "for all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        }
    ]
}

data "aws_iam_user" "selected1" {
user_name = "ghactions-app"
}
data "aws_iam_role" "currRole" {
name = "CodeDeployEC2ServiceRole"
}
data "aws_iam_policy" "currPolicy" {
arn = "arn:aws:iam::108519617795:policy/CodeDeploy-EC2-S3"
}
data "aws_iam_policy" "currPolicyUploadToS3" {
arn = "arn:aws:iam::108519617795:policy/GH-Upload-To-S3"
}
resource "aws_iam_user_policy_attachment" "attachUserUploadS3Attach" {
user       = "ghactions-app"
policy_arn = data.aws_iam_policy.currPolicy.arn
}
resource "aws_iam_role_policy_attachment" "test-attach1" {
    role       = data.aws_iam_role.currRole.name
    policy_arn = data.aws_iam_policy.currPolicy.arn
}
resource "aws_iam_role_policy_attachment" "test-attach" {
role       = data.aws_iam_role.currRole.name
policy_arn = data.aws_iam_policy.currPolicyUploadToS3.arn
}
resource "aws_db_subnet_group" "db-subnet" {
name       = "db-subnet"
subnet_ids = ["${aws_subnet.subnet.*.id[1]}", "${aws_subnet.subnet.*.id[0]}"]
}

resource "aws_db_parameter_group" "aurora_mysql" {
    name        = "my-rds-param"
    family = "mysql5.7"
    description = "My Rds Parameter group"
    parameter {
        name  = "character_set_server"
        value = "utf8"
    }
    parameter {
        name  = "character_set_client"
        value = "utf8"
    }
    parameter {
        name = "general_log"
        value = "0"  
    }
    parameter {
        name = "log_output"
        value = "FILE"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_db_instance" "csye6225" {
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    name                 = "csye6225"
    username             = "csye6225"
    password             = "csye6225"
    identifier             = "csye6225"
    multi_az             = false
    db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
    vpc_security_group_ids = [aws_security_group.database.id]
    parameter_group_name = aws_db_parameter_group.aurora_mysql.name
    publicly_accessible    = false
    skip_final_snapshot  = true
    tags = {
        Name = format("csye6225")
    }
}