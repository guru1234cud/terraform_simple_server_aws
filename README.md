# ☁️ Terraform AWS Web Server Setup

This project uses **Terraform** to deploy a basic infrastructure on **AWS** — including a VPC, subnet, route table, internet gateway, security group, and an EC2 instance running a simple Apache web server (Ubuntu-based).

---

## 🚀 What It Does

- Creates a custom VPC with a CIDR block `10.0.0.0/16`
- Launches a public subnet in `ap-south-1a` (Mumbai)
- Adds an Internet Gateway + routes to the internet
- Deploys a security group allowing **SSH (22)**, **HTTP (80)**, and **HTTPS (443)**
- Launches a **t2.micro Ubuntu EC2 instance** with Apache pre-installed
- Associates an Elastic IP to make the instance publicly accessible
- Automatically serves a simple `webserver` message on the home page

---

## 🧱 Components

| Component          | Description |
|-------------------|-------------|
| VPC               | Custom virtual private cloud (10.0.0.0/16) |
| Subnet            | Public subnet (10.0.1.0/24) |
| Internet Gateway  | Enables external internet access |
| Route Table       | Routes `0.0.0.0/0` to Internet Gateway |
| Security Group    | Allows SSH, HTTP, HTTPS from anywhere |
| Network Interface | Bound to EC2 instance with static private IP |
| EC2 Instance      | Ubuntu server running Apache |
| Elastic IP        | Maps the public IP to the EC2 instance |

---

## 📂 How to Use

### 1. Clone the Repo
```bash
git clone https://github.com/yourusername/terraform-aws-webserver.git
cd terraform-aws-webserver
