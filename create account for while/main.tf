

provider "aws" {
    region = "ca-central-1"
}

# список имен 
variable "aws_users" {
    description = "List of IAM Users to create"
    default = ["vasya", "petya", "kolya", "lena", "vova", "donald"]
}

# создание одного пользователя
resource "aws_iam_user" "user1" {
    name = "pushka"
}

# ******************************************** cylce for while create users
# создание нескольких юзеров из списка
resource "aws_iam_user" "users" {
    count = length(var.aws_users)
    name  = element(var.aws_users, count.index)
}

# вывод данных созданных юзеров
output "created_iam_users_all" {
    value = aws_iam_user.users
}

# вывод id юзера
output "created_iam_users" {
    value = aws_iam_user.users[*].id
}

# вывод с циклом loop
output "created_iam_users_custom" {
    value = [
        for i in aws_iam_user.users:
        "Hello user: ${user.name} has ARN: ${user.arn}"
    ]
}

# вывод картой map
output "created_iam_users_map" {
    value = {
        for user in aws_iam_user.users:
        user.unique_id => user.name.id
    }
}

# print list users with name length 4  
output "custom_if_length" {
    value = [
        for x in aws_iam_user.users:
        x.name
        if length(x.name) == 4
    ]
}



# ****************************************************** create instance count
# создание серверов массивом
resource "aws_instance" "servers" {
    count         = 3
    ami           = "ami-07ab3281411d31d04"
    instance_type = "t3.micro"
    tags = {
        Name = "Server Number ${count.index + 1}"
    }
}

# print nice MAP of Instance ID: PublicIP
output "server_all" {
    value = {
        for server in aws_instance :
        server.id => server.public_ip
    }
}
