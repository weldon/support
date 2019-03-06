Function New-JCAssociation
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][ValidateSet('activedirectories', 'applications', 'commands', 'gsuites', 'ldapservers', 'office365s', 'policies', 'radiusservers', 'systemgroups', 'systems', 'usergroups', 'users')][string]$InputObjectType
    )
    DynamicParam
    {
        # Build parameter array
        $Params = @()
        # Define the new parameters
        $Params += @{'Name' = 'InputObjectId'; 'Type' = [System.String]; 'Position' = 1; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ParameterSets' = @('ById'); }
        $Params += @{'Name' = 'InputObjectName'; 'Type' = [System.String]; 'Position' = 2; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ParameterSets' = @('ByName'); }
        $Params += @{'Name' = 'TargetObjectType'; 'Type' = [System.String]; 'Position' = 3; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ValidateSet' = (Get-JCAssociationType -InputObject:($InputObjectType)).Targets; }
        $Params += @{'Name' = 'TargetObjectId'; 'Type' = [System.String]; 'Position' = 4; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ParameterSets' = @('ById'); }
        $Params += @{'Name' = 'TargetObjectName'; 'Type' = [System.String]; 'Position' = 5; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ParameterSets' = @('ByName'); }
        # Create new parameters
        Return $Params | ForEach-Object {New-Object PSObject -Property:($_)} | New-DynamicParameter
    }
    Begin
    {
        # Create new variables for script
        $PsBoundParameters.GetEnumerator() | ForEach-Object {New-Variable -Name:($_.Key) -Value:($_.Value) -Force}
        # Debug message for parameter call
        Write-Debug ('[CallFunction]' + $MyInvocation.MyCommand.Name + ' ' + ($PsBoundParameters.GetEnumerator() | Sort-Object Key | ForEach-Object { '-' + $_.Key + ":('" + ($_.Value -join "','") + "')"}).Replace("'True'", '$True').Replace("'False'", '$False'))
        If ($PSCmdlet.ParameterSetName -ne '__AllParameterSets') {Write-Verbose ('[ParameterSet]' + $MyInvocation.MyCommand.Name + ':' + $PSCmdlet.ParameterSetName)}
    }
    Process
    {
        $Results = Switch ($PSCmdlet.ParameterSetName)
        {
            'ById'
            {
                Invoke-JCAssociation -Action:('add') -InputObjectType:($InputObjectType) -InputObjectId:($InputObjectId) -TargetObjectType:($TargetObjectType) -TargetObjectId:($TargetObjectId);
            }
            'ByName'
            {
                Invoke-JCAssociation -Action:('add') -InputObjectType:($InputObjectType) -InputObjectName:($InputObjectName) -TargetObjectType:($TargetObjectType) -TargetObjectName:($TargetObjectName);
            }
        }
    }
    End
    {
        Return $Results
    }
}