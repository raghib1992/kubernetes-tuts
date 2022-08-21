# Use EFS CSI driver for EKS
Ref https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/

Ref https://github.com/kubernetes-sigs/aws-efs-csi-driver#deploy-the-driver

Deploy and test the Amazon EFS CSI driver

1. Download the IAM policy document from GitHub:
curl -o iam-policy-example.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.2.0/docs/iam-policy-example.json

2.    Create an IAM policy:
aws iam create-policy --policy-name AmazonEKS_EFS_CSI_Driver_Policy --policy-document file://iam-policy-example.json

3.    Annotate the Kubernetes service account with the IAM role ARN and the IAM role with the Kubernetes service account name. For example:
```
aws eks describe-cluster --name test-cluster --query "cluster.identity.oidc.issuer" --output text
```
#### Note: In step 3, replace your_cluster_name with your cluster name.
https://oidc.eks.ap-south-1.amazonaws.com/id/35DBFBA05CC3C53F8D4617115D730B2F


4.    Create the following IAM trust policy, and then grant the AssumeRoleWithWebIdentity action to your Kubernetes service account. For example:
```
cat <<EOF > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/<XXXXXXXXXX45D83924220DC4815XXXXX>"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/<XXXXXXXXXX45D83924220DC4815XXXXX>:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
        }
      }
    }
  ]
}
EOF
```
### Note: In step 4, replace YOUR_AWS_ACCOUNT_ID with your account ID. Replace YOUR_AWS_REGION with your Region. Replace XXXXXXXXXX45D83924220DC4815XXXXX with the value returned in step 3.

5.    Create an IAM role:
```
aws iam create-role --role-name AmazonEKS_EFS_CSI_DriverRole --assume-role-policy-document file://"trust-policy.json"
```
6.    Attach your new IAM policy to the role:
```
aws iam attach-role-policy --policy-arn arn:aws:iam::561243041928:policy/AmazonEKS_EFS_CSI_Driver_Policy --role-name AmazonEKS_EFS_CSI_DriverRole
```

7.    Install the driver using images stored in the public Amazon ECR registry by downloading the manifest:
```
kubectl kustomize "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.3" > public-ecr-driver.yaml	<br>
```

8.    Edit the file 'public-ecr-driver.yaml' and annotate 'efs-csi-controller-sa' Kubernetes service account section with the ARN of the IAM role that you created: 
```
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/name: aws-efs-csi-driver
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<accountid>:role/AmazonEKS_EFS_CSI_DriverRole
  name: efs-csi-controller-sa
  namespace: kube-system
```
Deploy the Amazon EFS CSI driver:
1.    To deploy the Amazon EFS CSI driver, apply the manifest:
```
kubectl apply -f public-ecr-driver.yaml
```

2.    If your cluster contains only AWS Fargate pods (no nodes), then deploy the driver with the following command (all Regions):
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/deploy/kubernetes/base/csidriver.yaml
```

3.    Get the VPC ID for your Amazon EKS cluster:
```
aws eks describe-cluster --name test-cluster --query "cluster.resourcesVpcConfig.vpcId" --output text
```
### Note: In step 2, replace your_cluster_name with your cluster name.
vpc-0900e9dff6c8a7a74

4.    Get the CIDR range for your VPC cluster:
```
aws ec2 describe-vpcs --vpc-ids vpc-0900e9dff6c8a7a74 --query "Vpcs[].CidrBlock" --output text
```
### Note: In step 3, replace the YOUR_VPC_ID with the VPC ID from the preceding step 2.
192.168.0.0/16

5.    Create a security group that allows inbound network file system (NFS) traffic for your Amazon EFS mount points:
```
aws ec2 create-security-group --description efs-test-sg --group-name efs-sg --vpc-id vpc-0900e9dff6c8a7a74
```
### Note: Replace YOUR_VPC_ID with the output from the preceding step 2. Save the GroupId for later.
sg-0bddf80315033b249

6.    Add an NFS inbound rule so that resources in your VPC can communicate with your Amazon EFS file system:
```
aws ec2 authorize-security-group-ingress --group-id sg-0bddf80315033b249 --protocol tcp --port 2049 --cidr 192.168.0.0/16
```

7.    Create an Amazon EFS file system for your Amazon EKS cluster:
```
aws efs create-file-system --creation-token eks-efs
```
### Note: Save the FileSystemId for later use.
fs-0d6785b23999828b6
8.    To create a mount target for Amazon EFS, run the following command:
```
aws efs create-mount-target --file-system-id fs-0d6785b23999828b6 --subnet-id subnet-0e993c853cb3992b3 --security-group sg-0bddf80315033b249
```
### mportant: Be sure to run the command for all the Availability Zones with the SubnetID in the Availability Zone where your worker nodes are running. Replace FileSystemId with the output of the preceding step 6 (where you created the Amazon EFS file system). Replace sg-xxx with the output of the preceding step 4 (where you created the security group). Replace SubnetID with the subnet used by your worker nodes. To create mount targets in multiple subnets, you must run the command in step 7 separately for each subnet ID. It's a best practice to create a mount target in each Availability Zone where your worker nodes are running.

### Note: You can create mount targets for all the Availability Zones where worker nodes are launched. Then, all the Amazon Elastic Compute Cloud (Amazon EC2) instances in the Availability Zone with the mount target can use the file system.

## Test the Amazon EFS CSI driver:

You can test the Amazon EFS CSI driver by deploying two pods that write to the same file.

1.    Clone the aws-efs-csi-driver repository from AWS GitHub:
```
git clone https://github.com/kubernetes-sigs/aws-efs-csi-driver.git
```

2.    Change your working directory to the folder that contains the Amazon EFS CSI driver test files:
```
cd aws-efs-csi-driver/examples/kubernetes/multiple_pods/
```

3.    Retrieve your Amazon EFS file system ID that was created earlier:
```
aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text
```
### Note: If the command in step 3 returns more than one result, you can use the Amazon EFS file system ID that you saved earlier.
fs-0d6785b23999828b6

4.    In the specs/pv.yaml file, replace the spec.csi.volumeHandle value with your Amazon EFS FileSystemId from previous steps.

5.    Create the Kubernetes resources required for testing:
```
kubectl apply -f specs/
```
Note: The kubectl command in the preceding step 5 creates an Amazon EFS storage class, PVC, persistent volume, and two pods (app1 and app2).

6.    List the persistent volumes in the default namespace, and look for a persistent volume with the default/efs-claim claim:
```
kubectl get pv -w
```
7.    Describe the persistent volume:
```
kubectl describe pv efs-pv
```
8.    Test if the two pods are writing data to the file:
```

kubectl exec -it app2 -- tail /data/out1.txt
```
Wait for about one minute. The output shows the current date written to /data/out1.txt by both pods.
****************************************
****************************************
Use External NFS Provisioner
## Ref:
```
    https://github.com/kubernetes-sigs/sig-storage-lib-external-provisioner
    https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
```
## Create ns if required
```
apiVersion: v1
kind: Namespace
metadata:
  name: storage
```

## Create SA
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-client-provisioner
  namespace: storage
```

## Create Cluster Role
```
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
rules:
- apiGroups: [""]
  resources: ["persistentvolumes"]
  verbs: ["get", "list", "watch", "create", "delete"]
- apiGroups: [""]
  resources: ["persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "update"]
- apiGroups: ["storage.k8s.io"]
  resources: ["storageclasses"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["events"]
  verbs: ["create", "update", "patch"]
```

## Cluster role bindings
```
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
subjects:
- kind: ServiceAccount
  name: nfs-client-provisioner
  namespace: storage
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
```

## Create Role
```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: storage
rules:
- apiGroups: [""]
  resources: ["endpoints"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
```

## Create Role Bindings
```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: storage
  name: leader-locking-nfs-client-provisioner
subjects:
- kind: ServiceAccount
  name: nfs-client-provisioner
  namespace: storage
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io
```

### nfs-external-provisioner
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-client-provisioner
  labels:
    app: nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: default
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME
              value: k8s-sigs.io/nfs-subdir-external-provisioner
            - name: NFS_SERVER
              value: fs-00433efb31ab331bf.efs.ap-south-1.amazonaws.com
            - name: NFS_PATH
              value: /
      volumes:
        - name: nfs-client-root
          nfs:
            server: fs-00433efb31ab331bf.efs.ap-south-1.amazonaws.com
            path: /
```

### storageclass.yaml
```
apiVersion: storage.k8s.io/v1
kind:StorageClass
metadata:
    name: efs
provisioner: efs-storage
parameters:
  archiveOnDelete: "false"
```

### PVC yaml file
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc
spec:
  storageClassName: efs
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Mi
```

deployment.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: foo
  namespace: staging
spec:
  replicas: 1
  selector:
    matchLabels:
      app: foo
  template:
    metadata:
      labels:
        app: foo
    spec:
      containers:
      - name: foo
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        volumeMounts:
        - name: efs-pvc
          mountPath: "/data"
      volumes:
      - name: efs-pvc
        persistentVolumeClaim:
          claimName: test-claim
```

Ref https://github.com/kubernetes/examples/blob/master/staging/volumes/nfs/nfs-pv.yaml
PV yaml file

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: fs-00433efb31ab331bf.efs.ap-south-1.amazonaws.com   #nfs-server.default.svc.cluster.local
    path: "/home/ec2-user/efs-mount-pint"
  mountOptions:
    - nfsvers=4.1
```
PVC yaml file

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 500Mi
  volumeName: nfs
```

