## Create nsamespace
```
kubectl create namespace openldap
```
## creatr secret file
```
apiVersion: v1
kind: Secret
metadata:
  name: openldap-secrets
  namespace: openldap
type: Opaque
data:
  organizatation: "bXlvcmdhbml6YXRpb24=" #myorganization bXlvcmdhbml6YXRpb24=
  domain: "bXlkb21haW4=" #mydomain
  password: "bXlwYXNzd29yZA==" #mypassword
```

## PVC definition file
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: openldap-data-disk
  namespace: openldap
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

## LDAP deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: openldap-deployment
  namespace: openldap
  labels:
    app: openldap
spec:
  replicas: 1
  selector:
    matchLabels:
      app: openldap
  template:
    metadata:
      labels:
        app: openldap
    spec:
      containers:
        - name: openldap
          image: osixia/openldap:1.3.0
          ports:
            - containerPort: 389
            - containerPort: 636
          env:
            - name: LDAP_ORGANISATION
              valueFrom:
                secretKeyRef:
                  name: openldap-secrets
                  key: organizatation
            - name: LDAP_DOMAIN
              valueFrom:
                secretKeyRef:
                  name: openldap-secrets
                  key: domain
            - name: LDAP_ADMIN_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: openldap-secrets
                  key: password
          volumeMounts:
            - name: openldap-volume
              mountPath: "/var/lib/ldap"
              subPath: database
            - name: openldap-volume
              mountPath: "/etc/ldap/slapd.d"
              subPath: config
      volumes:
        - name: openldap-volume
          persistentVolumeClaim:
            claimName: openldap-data-disk
```
## LDAP Service
```
apiVersion: v1
kind: Service
metadata:
  name: openldap-service
  namespace: openldap
spec:
  selector:
    app: openldap
  ports:
  - name: openldap1
    protocol: TCP
    port: 389
    targetPort: 389
  - name: openldap2
    protocol: TCP
    port: 636
    targetPort: 636
```
## php deploy
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: phpldapadmin-deployment
  namespace: openldap
  labels:
    app: phpldapadmin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: phpldapadmin
  template:
    metadata:
      labels:
        app: phpldapadmin
    spec:
      containers:
        - name: phpldapadmin
          image: osixia/phpldapadmin:0.9.0
          ports:
            - containerPort: 443
          env:
            - name: PHPLDAPADMIN_LDAP_HOSTS
              value: openldap-service
```
## php service
```
apiVersion: v1
kind: Service
metadata:
  name: phpldapadmin-service
  namespace: openldap
spec:
  type: LoadBalancer
  selector:
    app: phpldapadmin
  ports:
  - protocol: TCP
    port: 9943
    targetPort: 443
```
