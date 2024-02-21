1. Create IAM User
2. Assign Role with Policy: AmazonEKSViewNodesAndWorkloadsPOlicy
3. Create RBAC
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: CLusterRole
metadata:
    name: reader
rules:
- apiGroups: ["*"]
  resources: ["deployments", "configmaps", "pods", "secrets", "services", "ingress"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: CLusterRoleBinding
metadata:
    name: reader
subjects:
- kind: Group
  name: reader
  apiGroup: rbac.authorization.k8s.io
roleRef: 
- kind: ClusterRole
  name: reader
  apiGroup: rbac.authorization.k8s.io
---
```
4. Create IAM Policy
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"eks:DescribeCluster",
				"eks:DescribeNodegroup",
				"eks:AccessKubernetesApi",
				"eks:ListFargateProfiles",
				"eks:ListClusters",
				"eks:ListNodegroups",
				"eks:ListUpdates",
                "ssm:GetParamter"
			],
			"Resource": [
				"*"
			]
		}
	]
}