# webappcode
# Installation:
1)First setup the infrasturcture using the following commands:<br/>
  <b>terraform init</b><br/>
  <b>terrafrom apply</b><br/>
2)Trigger github actions by creating a pull request and merge it.<br/>
3)Now open your aws console and check the deployment status in the CodeDeploy application.<br/>
4)After successful deployment test out the end points.<br/>

# Restful End points:<br/>
Create a user                               : /v1/users<br/>
Get a user                                  : /v1/users/{username}<br/>
Update a user                               : /v1/users/{usernmae}<br/>
Create a user profile image in S3 bucket    : /v1/users<br/>
Get a user's profile image                  : /v1/users/{username}/{imagename}<br/>
Update a user                               : /v1/users/{usernmae}/{imagename}<br/>
