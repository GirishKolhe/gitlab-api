<#
.SYNOPSIS
This utility is responsible for initating a remote connection to the gitlab runner having tag [Testing]

.DESCRIPTION
This powershell script exposes runner information such as id, tags, description, ip_address and so on

.PARAMETER uri
This should be url with http or https protocol of gitlab environment and will be used for gitlab api. e.g. http://<ip or name>

.PARAMETER accessKey
The accessKey that will be used as a private token for authentication e.g. for sandbox environment accessKey is yGXPG5uxzN6esGc-E15C

.NOTES   
Name:        gitlab-api-getrunner-info.ps1
Author:      Girish Kolhe
DateUpdated: 2018-08-01
Version:     1.0.0

.Scenarios Tested - Invalid gitlab access key

.EXAMPLE
. .\gitlab-api-getrunner-info.ps1 -uri http://<IP or domain> -accessKey <accessKey>
#>
 
##########################################################################################################################################
param (
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string] $uri,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()] 
[string] $accessKey
)
##########################################################################################################################################
$private_token = 'private_token='+$accessKey
$gitAPI = 'api/v4/runners'
$other_params = 'fmt=json'

############ Start - Functions #################

# This function sends request to gitlab server and returns all runner-ids
Function getRunnerIDs($base, $api, $token, $misc_tokens) {
	$request = $base+'/'+$api+'?'+$token+'&'+$misc_tokens
	Try {
		Write-Host 'Get Runner IDs' $request '- starts'
		$response = Invoke-RestMethod -Uri $request
		Write-Host 'Get Runner IDs' $request '- ends'
	} catch {
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			Write-Host 'Error encountered:' $ErrorMessage
			exit 1
	}
	return $response.id
}

# This function is responsible for retrieving all the details pertaining to a runner id
Function getRunnerDetails ($base, $api, $token, $misc_tokens, $id) {
	$request = $base+'/'+$api+'/'+$id+'?'+$token+'&'+$misc_tokens
	Try {
		Write-Host 'Get runner information' $request '- starts'
		$response = Invoke-RestMethod -Uri $request
		Write-Host 'Get runner information' $request '- ends'
    } catch {
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			Write-Host 'Error encountered:' $ErrorMessage
			exit 1
	}
	return $response
}

# This function is responsible for retrieving active key from a response json body
Function getActiveStatus ($jsonObject) {
    return $jsonObject.active
}
# This function is responsible for retrieving online key from a response json body
Function getOnlineStatus ($jsonObject) {
    return $jsonObject.online
}

# This function is responsible for retrieving tags key from a response json body
Function getRunnerTags ($jsonObject) {
    return $jsonObject.tag_list
}

# This function is responsible for retrieving ip_address key from a response json body
Function getRunnerIPAddress ($jsonObject) {
    return $jsonObject.ip_address
}

# This function is responsible for retrieving description key from a response json body
Function getRunnerDescription ($jsonObject) {
    return $jsonObject.description
}

# This function is responsible for retrieving platform key from a response json body
Function getRunnerPlatform ($jsonObject) {
    return $jsonObject.platform
}

# This function is responsible for retrieving projects key from a response json body
Function getRunnerProjects ($jsonObject) {
    return $jsonObject.projects
}


############ Ends - Functions #################

############ Code starts #################
#fetch on-line runners Ids
Write-Host `n[$(Get-Date -Format yyyy/MMM/dd-HH:mm:ss.ff)] Gitlab Runners Details..
$runnerIDs = getRunnerIDs $uri $gitAPI $private_token $other_params

foreach ($runnerID in $runnerIDs) {
    #Write-Host $runnerID
    $runnerDetails = getRunnerDetails $uri $gitAPI $private_token $other_params $runnerID
	$runnerActiveStatus = getActiveStatus $runnerDetails
	$runnerOnlineStatus = getOnlineStatus $runnerDetails
    $runnertags = getRunnerTags $runnerDetails
    $runnderIP = getRunnerIPAddress $runnerDetails
	$runnerDesc = getRunnerDescription $runnerDetails
	$runnerPlatform = getRunnerPlatform $runnerDetails
	$runnerProj = getRunnerProjects $runnerDetails
    Write-Host 'Active status:' $runnerActiveStatus 
    Write-Host 'Online status:' $runnerOnlineStatus 
    Write-Host 'Runner IP:' $runnderIP 
	Write-Host 'Tag(s):' [$runnertags]
	Write-Host 'Description:' [$runnerDesc]
	Write-Host 'Platform:' [$runnerPlatform]
	Write-Host 'Projects:' [$runnerProj]
	Write-Host ''
}
Write-Host '**** Execution complete!! ****'
# Because this is a simple script, just returning 0 at the end to stimulate success. Failure is thrown in catch statement in above functions
exit 0