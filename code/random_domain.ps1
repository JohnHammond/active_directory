param( 
    [Parameter(Mandatory=$true)] $OutputJSONFile,
    [int]$UserCount,
    [int]$GroupCount,
    [int]$LocalAdminCount
 )


$group_names = [System.Collections.ArrayList](Get-Content "data/group_names.txt")
$first_names = [System.Collections.ArrayList](Get-Content "data/first_names.txt")
$last_names = [System.Collections.ArrayList](Get-Content "data/last_names.txt")
$passwords = [System.Collections.ArrayList](Get-Content "data/passwords.txt")

$groups = @()
$users = @()

# Default UserCount set to 5 (if not set)
if ( $UserCount -eq 0 ){
    $UserCount = 5
}

# Default GroupCount set to 5 (if not set)
if ( $GroupCount -eq 0 ){
    $GroupCount = 1
}

if ( $LocalAdminCount -ne 0){
    $local_admin_indexes = @()
    while (($local_admin_indexes | Measure-Object ).Count -lt $LocalAdminCount){
        
        $random_index = (Get-Random -InputObject (1..($UserCount)) | Where-Object { $local_admin_indexes -notcontains $_ } )
        $local_admin_indexes += @( $random_index )
        echo "adding $random_index to local_admin_indexes $local_admin_indexes"
    }
}

for ( $i = 1; $i -le $GroupCount; $i++ ){
    $group_name = (Get-Random -InputObject $group_names)
    $group = @{ "name" = "$group_name" }
    $groups += $group
    $group_names.Remove($group_name)
}

for ( $i = 1; $i -le $UserCount; $i++ ){
    $first_name = (Get-Random -InputObject $first_names)
    $last_name = (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)

    $new_user = @{ `
        "name"="$first_name $last_name"
        "password"="$password"
        "groups" = (Get-Random -InputObject $groups).name
        }

    if ( $local_admin_indexes | Where { $_ -eq $i  } ){
        echo "user $i is local admin"
        $new_user["local_admin"] = $true
    }

    $users += $new_user

    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

ConvertTo-Json -InputObject @{ 
    "domain"= "xyz.com"
    "groups"=$groups
    "users"=$users
} | Out-File $OutputJSONFile 