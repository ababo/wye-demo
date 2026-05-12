#!/usr/bin/env bash
set -euo pipefail

command -v aws >/dev/null
command -v jq >/dev/null

ENV="env.json"

if [ ! -f "$ENV" ]; then
  echo "Missing env.json"
  exit 1
fi

REGION=$(jq -r '.region' "$ENV")
VPC=$(jq -r '.vpc' "$ENV")
SUBNET=$(jq -r '.subnet' "$ENV")
IGW=$(jq -r '.igw' "$ENV")
RTB=$(jq -r '.route_table' "$ENV")
ASSOC=$(jq -r '.route_assoc' "$ENV")
KEY=$(jq -r '.key' "$ENV")

echo "=============================="
echo "TEARDOWN START"
echo "Region: $REGION"
echo "VPC: $VPC"
echo "=============================="

# ------------------------------
# Route table cleanup FIRST
# ------------------------------

echo "[DELETE] Route association: $ASSOC"
aws ec2 disassociate-route-table \
  --region "$REGION" \
  --association-id "$ASSOC" || true

echo "[DELETE] Route table routes"
aws ec2 delete-route \
  --region "$REGION" \
  --route-table-id "$RTB" \
  --destination-cidr-block 0.0.0.0/0 || true

echo "[DELETE] Route table: $RTB"
aws ec2 delete-route-table \
  --region "$REGION" \
  --route-table-id "$RTB" || true

# ------------------------------
# Subnet
# ------------------------------

echo "[DELETE] Subnet: $SUBNET"
aws ec2 delete-subnet \
  --region "$REGION" \
  --subnet-id "$SUBNET" || true

# ------------------------------
# IGW
# ------------------------------

echo "[DETACH] IGW: $IGW"
aws ec2 detach-internet-gateway \
  --region "$REGION" \
  --internet-gateway-id "$IGW" \
  --vpc-id "$VPC" || true

echo "[DELETE] IGW: $IGW"
aws ec2 delete-internet-gateway \
  --region "$REGION" \
  --internet-gateway-id "$IGW" || true

# ------------------------------
# Keypair
# ------------------------------

echo "[DELETE] Key: $KEY"
aws ec2 delete-key-pair \
  --region "$REGION" \
  --key-name "$KEY" \
  >/dev/null 2>&1

# ------------------------------
# VPC last
# ------------------------------

echo "[DELETE] VPC: $VPC"
aws ec2 delete-vpc \
  --region "$REGION" \
  --vpc-id "$VPC" || true

# ------------------------------
# local cleanup
# ------------------------------

rm -f env.json
rm -f vault/ssh-key.pem
rmdir vault 2>/dev/null || true

echo "=============================="
echo "TEARDOWN COMPLETE"
echo "=============================="
