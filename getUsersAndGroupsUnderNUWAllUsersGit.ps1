$filepath = "<File Path to dump as TXT>"
$ADGroup = "<Name of Group to browse Recursive tree memberships>"

function outputADGroupMembership ([String]$groupname)
{
    Out-File -FilePath $filepath -InputObject $groupname -Width 80
    $Accounts = get-adgroupmember $groupname | select name, objectclass | Sort objectclass,name
    Out-File -FilePath $filepath -InputObject $Accounts -Append -Width 80
    $groups = get-adgroupmember $groupname | where objectclass -eq group | Sort objectclass,name
    foreach ($group in $groups){
        outputADGroupMembershipAppend ($group)
    }
}

function outputADGroupMembershipAppend ([String]$groupname)
{
    $gn = get-adgroup -Filter {DistinguishedName -eq $groupname} | select name
    Out-File -FilePath $filepath -InputObject $gn.name -Append -Width 80
    $Accounts  = get-adgroupmember $groupname | select name, objectclass | Sort objectclass,name
    Out-File -FilePath $filepath -InputObject $Accounts -Append -Width 80
    $groups = get-adgroupmember $groupname | where objectclass -eq group | Sort objectclass,name
    foreach ($group in $groups){
        outputADGroupMembershipAppend ($group)
    }
}

outputADGroupMembership($ADGroup)