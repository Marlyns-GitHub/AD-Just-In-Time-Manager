$pamfeature = "Privileged Access Management Feature"
$domain = (Get-ADDomain).DNSRoot
$checkpam = (Get-ADOptionalFeature -Identity $pamfeature).EnabledScopes

if (-not($checkpam)){

    $hidden = Enable-ADOptionalFeature $pamfeature -Scope ForestOrConfigurationSet -Target $domain -Confirm:$false
}