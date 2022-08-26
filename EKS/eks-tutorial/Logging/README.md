# Loggin Demo
# Demo 1
### Logging agent   fkuent d
### Logging backend cloudwatch - elastic search - kibana

#### Note:
1. cluster-name=attractive-gopher
2. region us-east-1

### Attach cloudwatch full access policy to all nodegroup IAM role

### Delpoy SA, cluster role and clusterrole binding and fluentd daemons
```
kubectl apply -f fluentd.yaml
```
### Delpy loadbalance svc
```
kubectl apply lb-svc.yaml
```

### Create container image and push ECR using Docker file

### Delpoy hell k8s for logs
```
kubectl apply -g hello-k8s-forlog.yml
```
### Create elastic search
```
aws es create-elasticsearch-domain --domain-name eks-logs --elasticsearch-version 7.4 --elasticsearch-cluster-config InstanceType=t3.small.elasticsearch,InstanceCount=1 --ebs-options EBSEnabled=true,VolumeType=gp3,VolumeSize=10 --access-policies '{"Version": "2012-10-17", "Statement": [{"Action": "es:*", "Principal":"*","Effect": "Allow", "Condition": {"IpAddress":{"aws:SourceIp":["183.82.97.224"]}}}]}'
```
### or Alternativley, Create Open Search, (either es or os)
```
aws opensearch create-domain --domain-name eks-log --engine-version OpenSearch_1.2 --cluster-config  InstanceType=t3.small.search,InstanceCount=2 --ebs-options EBSEnabled=true,VolumeType=gp3,VolumeSize=10 --access-policies '{"Version": "2012-10-17", "Statement": [{"Action": "es:*", "Principal":"*","Effect": "Allow", "Condition": {"IpAddress":{"aws:SourceIp":["183.82.97.224"]}}}]}'
```

### Create IAm role for lamda for es access

### Create subcription filter for Es, choose lambda role, common format in cloudwatch log group

*****************
## Demo 2
### ref https://aws.amazon.com/blogs/opensource/centralized-container-logging-fluent-bit/

### create a policy file called eks-fluent-bit-daemonset-policy.json (source) with the following content:
### ref https://github.com/aws-samples/amazon-ecs-fluent-bit-daemon-service/blob/mainline/eks/eks-fluent-bit-daemonset-policy.json
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecordBatch"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        }
    ]
}
```
### attach this policy to workernodegroup of eks cluster

### create a new IAM Role with two policy files for Firehose
### Ref https://github.com/aws-samples/amazon-ecs-fluent-bit-daemon-service/blob/mainline/log-analysis/firehose-policy.json


### create the firehose_delivery_role
```
aws iam create-role --role-name firehose_delivery_role --assume-role-policy-document file://firehose-policy.json
```

### From the resulting JSON output of the above command, note down the role ARN, which will be something in the form of arn:aws:iam::XXXXXXXXXXXXX:role/firehose_delivery_role.

### in firehose-delivery-policy.json file
### edit

### Note: 
1. replace the XXXXXXXXXXXX with your own account ID
2. Also, in the S3 section, replace raghib-eks-log with your own bucket name

#### get Account id
```
aws sts get-caller-identity --output text --query 'Account'
```
### Create s3 bucket
```
aws s3 mb s3://raghib-eks-log --region us-east-1
```

### Second, in the firehose-delivery-policy.json
```
aws iam put-role-policy --role-name firehose_delivery_role --policy-name firehose-fluentbit-s3-streaming --policy-document file://firehose-delivery-policy.json
```

### create the ECS delivery stream:
```
aws firehose create-delivery-stream \
            --delivery-stream-name eks-stream \
            --delivery-stream-type DirectPut \
            --s3-destination-configuration \
RoleARN=arn:aws:iam::561243041928:role/firehose_delivery_role,\
BucketARN="arn:aws:s3:::mh9-firelens-demo",\
Prefix=ecs
```

### Launch Fluent bit daemon set and Sa cluster role
```
kubectl apply -f fluentbit-SA-Cr.yaml
```

### Deploy the following NGINX app
```
kubectl apply -f nginx-app.yaml
```


### We now need to generate some load for the NGINX containers 
```
./load-gen-eks.sh &
```