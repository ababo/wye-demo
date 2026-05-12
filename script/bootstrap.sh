#!/usr/bin/env bash
set -euo pipefail

command -v aws >/dev/null
command -v jq >/dev/null

REGION="${AWS_REGION:-$(aws configure get region)}"

if [ -z "$REGION" ] || [ "$REGION" == "None" ]; then
  echo "Invalid region"
  exit 1
fi

echo "=============================="
echo "BOOTSTRAP START"
echo "Region: $REGION"
echo "=============================="

KEY_PATH="vault/ssh-key.pem"
ENV_PATH="env.json"

rm -f "$ENV_PATH"
mkdir -p vault

VPC_ID=$(aws ec2 create-vpc \
  --region "$REGION" \
  --cidr-block 10.0.0.0/16 \
  --query Vpc.VpcId --output text)

echo "[CREATE] VPC=$VPC_ID"

SUBNET_ID=$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block 10.0.0.0/24 \
  --query Subnet.SubnetId --output text)

echo "[CREATE] SUBNET=$SUBNET_ID"

IGW_ID=$(aws ec2 create-internet-gateway \
  --region "$REGION" \
  --query InternetGateway.InternetGatewayId --output text)

aws ec2 attach-internet-gateway \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --internet-gateway-id "$IGW_ID"

echo "[CREATE] IGW=$IGW_ID"

ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --query RouteTable.RouteTableId --output text)

echo "[CREATE] ROUTE_TABLE=$ROUTE_TABLE_ID"

aws ec2 create-route \
  --region "$REGION" \
  --route-table-id "$ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID" >/dev/null

ASSOC_ID=$(aws ec2 associate-route-table \
  --region "$REGION" \
  --route-table-id "$ROUTE_TABLE_ID" \
  --subnet-id "$SUBNET_ID" \
  --query AssociationId --output text)

echo "[CREATE] ROUTE_ASSOC=$ASSOC_ID"

KEY_NAME="demo-key-$(date +%s)"

aws ec2 create-key-pair \
  --region "$REGION" \
  --key-name "$KEY_NAME" \
  --query KeyMaterial \
  --output text > "$KEY_PATH"

chmod 600 "$KEY_PATH"

AMI_ID=$(aws ec2 describe-images \
  --region "$REGION" \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu-eks/k8s_1.35/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20260218" \
  --query 'Images[0].ImageId' \
  --output text)

echo "[CREATE] AMI=$AMI_ID"

jq -n \
  --arg region "$REGION" \
  --arg vpc "$VPC_ID" \
  --arg subnet "$SUBNET_ID" \
  --arg igw "$IGW_ID" \
  --arg rtb "$ROUTE_TABLE_ID" \
  --arg assoc "$ASSOC_ID" \
  --arg key "$KEY_NAME" \
  --arg ami "$AMI_ID" \
  '{
    region:$region,
    vpc:$vpc,
    subnet:$subnet,
    igw:$igw,
    route_table:$rtb,
    route_assoc:$assoc,
    key:$key,
    ami:$ami
  }' > env.json

echo "=============================="
echo "BOOTSTRAP COMPLETE"
echo "=============================="
