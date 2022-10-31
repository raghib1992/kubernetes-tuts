1. Create Policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
```
2. aws account role and attach the policy
3. aws iam get-role --profile sankalan --role-name eks-admin
4. Policy for user
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "arn:aws:iam::566881612178:role/sankalan-eks-access-role"
        }
    ]
}
```
4. aws sts assume-role --role-arn arn:aws:iam::561243041928:role/devops-admin --role-session-name raghib --profile umber
```
{
    "Credentials": {
        "AccessKeyId": "ASIAYFLFRGCEBTUYN4UL",
        "SecretAccessKey": "3WuyBYdKBknWC+v8/84A3ZHpuD8jHg/nTFZCQ43p",
        "SessionToken": "IQoJb3JpZ2luX2VjEIb//////////wEaCmFwLXNvdXRoLTEiSDBGAiEA/7tbLWXTfByP3ywwhHWFMb5/9gY3s+5XS1HchlLtQ4UCIQCIgy4z/yWmMbROdoICXE2Ta1+v1lGErAdt7/Myn8sviiqaAghfEAAaDDU2MTI0MzA0MTkyOCIM/dSk2oKKlKM0EmfZKvcBxK6404Qc94UXmHsdX3ogcQc4sJoV33DusbVZfL58fLgaDNnqehyE9e3fOQ3Wg4xXiPtMITngR7WGFTYu1wasoqZWXfRD2NCIeX4O5UhM3JW6I/23hHDfPOSFHwLfzpWZRWKFER4ARuoOUiTyaFbDAmb5yCqFMYD4iV0rWG5QwOVwQWLfp8a78RS9FBcJ/xtksxZqUp8oK1d+0Y3kKmQztkr7er0tiTYMIlJVMEx+bPTOhqJKon61WZOTIfABrE6zt0vMkDNzsW7RKFDIgCM+g+HPit41FvM2YML1V9yIvWz2FH8UurZzeLUJ4MikkZDvg5KF+cdvuzChsMWaBjqcAbaWsxirtbk9/MaKADrHRV3o0s7g/xfGpP+GbvDVssptXCnYI7O4c/nSLEzVBgLFZsVPgdEhMuDeSvBBCV10kfIf0bF5YfW9xMM02ElU412komTV0KOaetzwrvAWOhd0AlASbOc0auUkoy9afOsgJiavcmce1g8994NMVAbFk4VVzyHQY6yqzO4YJmLRUe2b270sDrzFFci6aIVijw==",
        "Expiration": "2022-10-20T15:16:01+00:00"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROAYFLFRGCELFTJKIL4R:umber-seesion",
        "Arn": "arn:aws:sts::561243041928:assumed-role/devops-admin/umber-seesion"
    }
}
```
5. kubectl edit cm aws-auth -n kube-system -o yaml 
6. vi ~/.aws/config
```
[profile devops-admin]
role_arn = arn:aws:iam::561243041928:role/devops-admin
source_profile = umber
```
vi ~\.aws\credentials
```
[profile devops-admin]
role_arn = arn:aws:iam::721259643016:role/devops-admin
source_profile = bouqs
```
```
aws eks --region ap-south-1 update-kubeconfig --name test-cluster --profile devops-admin
```