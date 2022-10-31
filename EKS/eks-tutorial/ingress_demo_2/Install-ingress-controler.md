https://aws.amazon.com/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/

ISSUER_URL=$(aws eks describe-cluster --name test1 \
  --query "cluster.identity.oidc.issuer" --region ap-south-1 --output text)

