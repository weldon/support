Function Get-JCAssociation
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][ValidateSet('activedirectories', 'active_directory', 'commands', 'command', 'ldapservers', 'ldap_server', 'policies', 'policy', 'applications', 'application', 'radiusservers', 'radius_server', 'systemgroups', 'system_group', 'systems', 'system', 'usergroups', 'user_group', 'users', 'user', 'gsuites', 'g_suite', 'office365s', 'office_365')][string]$InputObjectType
    )
    DynamicParam
    {
        $InputJCObject = Get-JCObject -Type:($InputObjectType);
        $JCAssociationType = Get-JCObjectType -Type:($InputObjectType) | Where-Object {$_.Category -eq 'JumpCloud'};
        # Build parameter array
        $Params = @()
        # Define the new parameters
        $Params += @{'Name' = 'InputObjectId'; 'Type' = [System.String]; 'Position' = 1; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ParameterSets' = @('ById'); 'ValidateSet' = @($InputJCObject.($InputJCObject.ById | Select-Object -Unique)); }
        $Params += @{'Name' = 'InputObjectName'; 'Type' = [System.String]; 'Position' = 2; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ParameterSets' = @('ByName'); 'ValidateSet' = @($InputJCObject.($InputJCObject.ByName | Select-Object -Unique)); }
        $Params += @{'Name' = 'TargetObjectType'; 'Type' = [System.String]; 'Position' = 3; 'ValueFromPipelineByPropertyName' = $true; 'Mandatory' = $true; 'ValidateNotNullOrEmpty' = $true; 'ValidateSet' = $JCAssociationType.Targets; }
        $Params += @{'Name' = 'HideTargetData'; 'Type' = [Switch]; 'Position' = 4; 'ValueFromPipelineByPropertyName' = $true; }
        # Create new parameters
        Return $Params | ForEach-Object {New-Object PSObject -Property:($_)} | New-DynamicParameter
    }
    Begin
    {
        # Create new variables for script
        $PsBoundParameters.GetEnumerator() | ForEach-Object {New-Variable -Name:($_.Key) -Value:($_.Value) -Force}
        # Debug message for parameter call
        Write-Debug ('[CallFunction]' + $MyInvocation.MyCommand.Name + ' ' + ($PsBoundParameters.GetEnumerator() | Sort-Object Key | ForEach-Object { '-' + $_.Key + ":('" + ($_.Value -join "','").Replace("'True'", '$True').Replace("'False'", '$False') + "')"}) )
        If ($PSCmdlet.ParameterSetName -ne '__AllParameterSets') {Write-Verbose ('[ParameterSet]' + $MyInvocation.MyCommand.Name + ':' + $PSCmdlet.ParameterSetName)}
    }
    Process
    {
        $Action = 'get'
        # Create hash table to store variables
        $FunctionParameters = [ordered]@{}
        # Add input parameters from function in to hash table and filter out unnecessary parameters
        $PSBoundParameters.GetEnumerator() | ForEach-Object {$FunctionParameters.Add($_.Key, $_.Value) | Out-Null}
        # Add parameters from the script to the FunctionParameters hashtable
        $FunctionParameters.Add('Action', $Action) | Out-Null
        Write-Debug ('Splatting Parameters');
        If ($DebugPreference -ne 'SilentlyContinue') {$FunctionParameters}
        # Run the command
        $Results = Invoke-JCAssociation @FunctionParameters
    }
    End
    {
        Return $Results
    }
}