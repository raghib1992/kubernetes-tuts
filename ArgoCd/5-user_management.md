argocd login localhost:8080 --username admin --password 39p8JhG9v44-Jk1I

Create User
kubectl -n argocd edit cm argocd-cm
data:
	accounts.raghib: apikey, login
	accounts.uzma: apikey, login
	accounts.dev: apikey. login
save the file
verify the same in ui

set the password
argocd account update-password --account raghib
promt for password admin 
promt for new password

same process for all users
try to login using new user and password

Nothing show on UI as this user has no access


Create permission for users
kubectl -n argocd edit cm argocd-rbac-cm
data:
	policy.csv: |
		p, role:devops, applications, *, *, allow
		p, role:devops, repositories, *, *, allow
		p, role:devops, projects, *, *, allow
		p, role:developer, applications, get, *, allow
		p, role:nginx, applications, sync, default/nginx, allow
		p, role:nginx, applications, get, default/nginx, allow
		p, role:nginx, applications, delete, default/nginx, allow
		g, raghib, role:devops
		g, uzma, role:admin
		g, dev, role:developer
		
save the file

Verify the sam in UI


_______________

Create new project
allow all

Create Roles in project
Assign roles to group

