
# ==========================
     VPC CIDR BLOCK:
# ==========================

resource "aws_vpc" "my-vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

# ==========================
     INTERNET-GATEWAY:
# ==========================

resource "aws_internet_gateway" "my-igw"{
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my-igw"
    }
}

# ==========================
     PUBLIC-SUBNET:
# ==========================

resource "aws_subnet" "my-public-subnet" {
    count = 2
    vpc_id =aws_vpc.my-vpc.i
    cidr_block = cidrsubnet(aws_vpc.my-vpc.id, 8, count.index)
    avaiability_zone = element([], count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "my-public-subnet-${count.index}"
    }
}

# ==========================
     PRIVATE-SUBNET:
# ==========================

/*resource "aws_subnet" "my-private-subnet" {
    count = 2
    vpc_id =aws_vpc.my-vpc.i
    cidr_block = cidrsubnet(aws_vpc.my-vpc.id, 8, count.index)
    avaiability_zone = element([], count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "my-private-subnet-${count.index}"
    }
}*/

# ==========================
     PUBLIC-ROUTE-TABLE:
# ==========================

resource "aws_route_table" "my-public-route-table" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags = {
        Name = "my-public-route-table"
    }
}

# ==========================
     PRIVATE-ROUTE-TABLE:
# ==========================

/*resource "aws_route_table" "my-private-route-table" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = ""

    }
}*/

# ====================================
     PUBLIC-ROUTE-TABLE-ASSOCIATION:
# ====================================

resource "aws-route_table_association" "my-public-route-table-association" {
    count = 2
    subnet_id = aws_subnet.my-public-subnet[count.index].id
    route_table_id = aws_route_table.my-public-route-table.id
}

# ====================================
     PRIVATE-ROUTE-TABLE-ASSOCIATION:
# ====================================

/*resource "aws-route_table_association" "my-private-route-table-association" {
    count = 2
    subnet_id = aws_subnet.my-private-subnet[count.index].id
    route_table_id = aws_route_table.my-private-route-table.id
}