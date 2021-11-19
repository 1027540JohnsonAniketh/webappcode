# webappcode
## Installation:
<pre>
1)First setup the infrasturcture using the following commands:
  <b>terraform init</b>
  <b>terrafrom apply</b>
2)Trigger github actions by creating a pull request and merge it.
3)Now open your aws console and check the deployment status in the CodeDeploy application.
4)After successful deployment test out the end points.
</pre>

## Restful End points:<br/>
<pre>
Create a user                               : /v1/users
Get a user                                  : /v1/users/{username}
Update a user                               : /v1/users/{usernmae}
Create a user profile image in S3 bucket    : /v1/users
Get a user's profile image                  : /v1/users/{username}/{imagename}
Update a user                               : /v1/users/{usernmae}/{imagename}
</pre>
