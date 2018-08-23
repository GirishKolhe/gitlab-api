# gitlab-api

Gitlab API gives flexibility to access gitlab resouces such as issues, runners to automate different components of devOps or software development life cycle.

# gitlab-api-getrunner-info.ps1
> Powershell utility that demonstrate use of gitlab api to fetch runner information.

```
Usage
.\gitlab-api-getrunner-info.ps1 -uri http://<IP or Domain> -accessKey <accessKey>
```

## Highlights
> powershell cmdlets : Invoke-RestMethod and param validations such as ValidateNotNullOrEmpty()