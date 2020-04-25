
<#PSScriptInfo

.VERSION 1.0.2

.GUID b6f70c64-13aa-4408-a83f-cebf800df2b4

.AUTHOR mziyabo

.COMPANYNAME

.COPYRIGHT (c) mziyabo. All rights reserved.

.TAGS kubectl auto-completion

.LICENSEURI

.PROJECTURI https://github.com/mziyabo/PSKubectlCompletion

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 PowerShell Core kubectl auto-completion   
#> 

function Register-KubectlCompletion {

    [scriptblock]$GetCompletions = {
        param($wordToComplete, $commandAst, $cursorPosition)
             
        $commandElements = $commandAst.CommandElements | ForEach-Object { $_.Extent.ToString().Split('=')[0] };
        $lastCommand = Get-LastCommand($commandAst.ToString());        
        $commands = Get-Commands($commandAst.ToString());
        
        $script:cmdLn = @{
            Commands       = $commands;
            WordToComplete = $wordToComplete
        };
        
        if ($commands.Count -gt 2) {
            
            $matches = (Get-AvailableOptions($lastCommand)).Where( { $_ -like "$wordToComplete*" });

            if ($matches.Count -eq 0) {             
                return Get-AvailableOptions($lastCommand) |
                Where-Object { $_ -notin $commandElements } |
                ForEach-Object { $_ };
            }
            else {
                return $matches |
                Where-Object { $_.StartsWith($wordToComplete) -and $_.Split("=")[0] -notin $commandElements } |
                ForEach-Object { $_ };
            }    
        }
        else {              
            [string[]]$result = Get-RootCompletionOptions;
            
            if ($wordToComplete -eq [string]::Empty -and $lastCommand -eq [string]::Empty) {
                return $result | ForEach-Object { $_ };  
            }
            elseIf ($result.Contains($lastCommand)) {
                if ($commandAst.ToString().Length -eq $cursorPosition) {
                    return $null;
                }
        
                return Get-AvailableOptions($lastCommand) |
                Where-Object { $_ -notin $commandElements -and $_.Split("=")[0] -notin $commandElements } | 
                ForEach-Object { $_ };
            }
            else {
                return $result |
                Where-Object { $_.StartsWith($wordToComplete) } |
                ForEach-Object { $_ };
            }   
        }
    }
    
    $rootCommands = ('kubectl','kubectl.exe');
    $aliases = (get-alias).Where({$_.Definition -in $rootCommands}).Name;
    if($aliases){$rootCommands+=$aliases}
    Register-ArgumentCompleter -CommandName $rootCommands -ScriptBlock $GetCompletions -Native
}


function Remove-CommandFlags($parameterName) {
    $cmd = $parameterName.Trim();

    $flags = Select-String '\s-{1,2}[\w-]*[=?|\s+]?[\w1-9_:/-]*' -InputObject $cmd -AllMatches;
    $flags.Matches.Value | ForEach-Object { $cmd = $cmd.Replace($_, " ") };

    return $cmd;
}

function Get-LastCommand($parameterName) { 
    
    $cmd = Remove-CommandFlags($parameterName);
    $options = $cmd.Trim().Split(' ');

    if ($options.Count -lt 2) {
        return 'root';
    }
    
    return $options[1];
}

function Get-Commands($parameterName) {

    $cmd = Remove-CommandFlags($parameterName);
    $commands = $cmd.Split(' ') | Where-Object { $_ -ne [string]::Empty };

    return $commands;
}

function Get-AvailableOptions($lastCommand) {
    
    $completions = [System.Collections.ArrayList]@();
    
    if ($lastCommand -in ("kubectl", "kubectl.exe")) {
        return $completions += Get-RootCompletionOptions($wordToComplete);
    }
    
    switch ($lastCommand) {
        get { 
            return $completions += Get-KubectlGet;
        }
        default {
            $completions = Invoke-Expression "Get-$lastCommand" -ErrorAction Ignore;
        }
    }
  
    return $completions;
}

function Get-KubectlCommon() {
    $flags = [System.Collections.ArrayList]@();
    
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    return $flags;
}

function Get-RootCompletionOptions() {    

    $commands = [System.Collections.ArrayList]@();

    $commands += ("alpha")
    $commands += ("annotate")
    $commands += ("api-resources")
    $commands += ("api-versions")
    $commands += ("apply")
    $commands += ("attach")
    $commands += ("auth")
    $commands += ("autoscale")
    $commands += ("certificate")
    $commands += ("cluster-info")
    $commands += ("completion")
    $commands += ("config")
    $commands += ("convert")
    $commands += ("cordon")
    $commands += ("cp")
    $commands += ("create")
    $commands += ("delete")
    $commands += ("describe")
    $commands += ("diff")
    $commands += ("drain")
    $commands += ("edit")
    $commands += ("exec")
    $commands += ("explain")
    $commands += ("expose")
    $commands += ("get")
    $commands += ("kustomize")
    $commands += ("label")
    $commands += ("logs")
    $commands += ("options")
    $commands += ("patch")
    $commands += ("plugin")
    $commands += ("port-forward")
    $commands += ("proxy")
    $commands += ("replace")
    $commands += ("rollout")
    $commands += ("run")
    $commands += ("scale")
    $commands += ("set")
    $commands += ("taint")
    $commands += ("top")
    $commands += ("uncordon")
    $commands += ("version")
    $commands += ("wait")
  
    $commands += ( { Get-KubectlCommon }.Invoke());
    return $commands;
}

function Get-alpha {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $commands += ("debug");
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
    
    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-alpha-$resource"
    }

    $commands += $flags;
    return $commands;
}

function Get-annotate() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--field-selector=")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--overwrite")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--resource-version=")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-api-resources() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--api-group=")
    $flags += ("--cached")
    $flags += ("--namespaced")
    $flags += ("--no-headers")
    $flags += ("--output=")
    $flags += ("--sort-by=")
    $flags += ("--verbs=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-api-versions() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-apply() {

    $commands = [System.Collections.ArrayList]@()
    $flags = [System.Collections.ArrayList]@()

    $commands += ("edit-last-applied")
    $commands += ("set-last-applied")
    $commands += ("view-last-applied")

    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--cascade")
    $flags += ("--dry-run")
    $flags += ("--field-manager=")
    $flags += ("--filename=")
    $flags += ("--force")
    $flags += ("--force-conflicts")
    $flags += ("--grace-period=")
    $flags += ("--kustomize=")
    $flags += ("--openapi-patch")
    $flags += ("--output=")
    $flags += ("--overwrite")
    $flags += ("--prune")
    $flags += ("--prune-whitelist=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--server-side")
    $flags += ("--template=")
    $flags += ("--timeout=")
    $flags += ("--validate")
    $flags += ("--wait")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
    
    if ($commands.Contains($cmdLn.Commands[2])) {
        return $flags;
    }

    $commands += $flags;
    return $commands;
}

function Get-attach() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--container=")
    $flags += ("--pod-running-timeout=")
    $flags += ("--stdin")
    $flags += ("-i")
    $flags += ("--tty")
    $flags += ("-t")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-auth() {

    $commands = [System.Collections.ArrayList]@()
    $commands += ("can-i")
    $commands += ("reconcile")
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-autoscale() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--cpu-percent=")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--generator=")
    $flags += ("--kustomize=")
    $flags += ("--max=")
    $flags += ("--min=")
    $flags += ("--name=")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
                        
    $commands += $flags;
    return $commands;
}

function Get-certificate() {

    $commands = [System.Collections.ArrayList]@()
    $commands += ("approve")
    $commands += ("deny")
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}
function Get-cluster-info() {

    $commands = [System.Collections.ArrayList]@()
    $flags = [System.Collections.ArrayList]@()
    $commands += ("dump")

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
    
    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-config-$resource"
    }

    $commands += $flags;
    return $commands;
}

function Get-completion() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--help")
    $flags += ("-h")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
                 
    $commands += $flags;
    return $commands;
}

function Get-config() {
    
    $commands = [System.Collections.ArrayList]@()
    $flags = [System.Collections.ArrayList]@()

    $commands += ("current-context")
    $commands += ("delete-cluster")
    $commands += ("delete-context")
    $commands += ("get-clusters")
    $commands += ("get-contexts")
    $commands += ("rename-context")
    $commands += ("set")
    $commands += ("set-cluster")
    $commands += ("set-context")
    $commands += ("set-credentials")
    $commands += ("unset")
    $commands += ("use-context")
    $commands += ("view")

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;

    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-config-$resource"
    }

    return $commands;
}

function Get-convert() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--output-version=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-cordon() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--dry-run")
    $flags += ("--selector=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-cp() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--container=")
    $flags += ("--no-preserve")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-create($parameterName) {

    $commands = [System.Collections.ArrayList]@()

    $commands += ("clusterrole")
    $commands += ("clusterrolebinding")
    $commands += ("configmap")
    $commands += ("cronjob")
    $commands += ("deployment")
    $commands += ("job")
    $commands += ("namespace")
    $commands += ("poddisruptionbudget")
    $commands += ("priorityclass")
    $commands += ("quota")
    $commands += ("role")
    $commands += ("rolebinding")
    $commands += ("secret")
    $commands += ("service")
    $commands += ("serviceaccount")
    
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--edit")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--raw=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--save-config")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--windows-line-endings")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    
    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-create-$resource"
    }
    
    $commands += $flags;
    return $commands;
}

function Get-delete() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all")
    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--cascade")
    $flags += ("--dry-run")
    $flags += ("--field-selector=")
    $flags += ("--filename=")
    $flags += ("--force")
    $flags += ("--grace-period=")
    $flags += ("--ignore-not-found")
    $flags += ("--kustomize=")
    $flags += ("--now")
    $flags += ("--output=")
    $flags += ("--raw=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--timeout=")
    $flags += ("--wait")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-describe() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--show-events")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-diff() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--field-manager=")
    $flags += ("--filename=")
    $flags += ("--force-conflicts")
    $flags += ("--kustomize=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--server-side")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-drain() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--delete-local-data")
    $flags += ("--disable-eviction")
    $flags += ("--dry-run")
    $flags += ("--force")
    $flags += ("--grace-period=")
    $flags += ("--ignore-daemonsets")
    $flags += ("--pod-selector=")
    $flags += ("--selector=")
    $flags += ("--skip-wait-for-delete-timeout=")
    $flags += ("--timeout=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-edit() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--output-patch")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--windows-line-endings")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-exec() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--container=")
    $flags += ("--filename=")
    $flags += ("--pod-running-timeout=")
    $flags += ("--stdin")
    $flags += ("-i")
    $flags += ("--tty")
    $flags += ("-t")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-explain() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--api-version=")
    $flags += ("--recursive")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-expose() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--cluster-ip=")
    $flags += ("--dry-run")
    $flags += ("--external-ip=")
    $flags += ("--filename=")
    $flags += ("--generator=")
    $flags += ("--kustomize=")
    $flags += ("--labels=")
    $flags += ("--load-balancer-ip=")
    $flags += ("--name=")
    $flags += ("--output=")
    $flags += ("--overrides=")
    $flags += ("--port=")
    $flags += ("--protocol=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--save-config")
    $flags += ("--selector=")
    $flags += ("--session-affinity=")
    $flags += ("--target-port=")
    $flags += ("--template=")
    $flags += ("--type=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
                             
    $commands += $flags;
    return $commands;
}

function Get-kustomize() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-label() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--field-selector=")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--list")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--overwrite")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--resource-version=")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-logs() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all-containers")
    $flags += ("--container=")
    $flags += ("--follow")
    $flags += ("-f")
    $flags += ("--ignore-errors")
    $flags += ("--insecure-skip-tls-verify-backend")
    $flags += ("--limit-bytes=")
    $flags += ("--max-log-requests=")
    $flags += ("--pod-running-timeout=")
    $flags += ("--prefix")
    $flags += ("--previous")
    $flags += ("-p")
    $flags += ("--selector=")
    $flags += ("--since=")
    $flags += ("--since-time=")
    $flags += ("--tail=")
    $flags += ("--timestamps")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-options() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}
function Get-patch() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--patch=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--type=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
               
    $commands += $flags;
    return $commands;
}

function Get-plugin() {

    $commands = [System.Collections.ArrayList]@()
    $commands += ("list")
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-port-forward() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--address=")
    $flags += ("--pod-running-timeout=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-proxy() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--accept-hosts=")
    $flags += ("--accept-paths=")
    $flags += ("--address=")
    $flags += ("--api-prefix=")
    $flags += ("--disable-filter")
    $flags += ("--keepalive=")
    $flags += ("--port=")
    $flags += ("--reject-methods=")
    $flags += ("--reject-paths=")
    $flags += ("--unix-socket=")
    $flags += ("--www=")
    $flags += ("--www-prefix=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-replace() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--cascade")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--force")
    $flags += ("--grace-period=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--raw=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--timeout=")
    $flags += ("--validate")
    $flags += ("--wait")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-rollout() {

    $commands = [System.Collections.ArrayList]@()
    $commands += ("history")
    $commands += ("pause")
    $commands += ("restart")
    $commands += ("resume")
    $commands += ("status")
    $commands += ("undo")

    $flags = [System.Collections.ArrayList]@()

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
    
    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-rollout-$resource"
    }
    
    $commands += $flags;
    return $commands;
}

function Get-run() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--allow-missing-template-keys")
    $flags += ("--attach")
    $flags += ("--cascade")
    $flags += ("--command")
    $flags += ("--dry-run")
    $flags += ("--env=")
    $flags += ("--expose")
    $flags += ("--filename=")
    $flags += ("--force")
    $flags += ("--grace-period=")
    $flags += ("--hostport=")
    $flags += ("--image=")
    $flags += ("--image-pull-policy=")
    $flags += ("--kustomize=")
    $flags += ("--labels=")
    $flags += ("--leave-stdin-open")
    $flags += ("--limits=")
    $flags += ("--output=")
    $flags += ("--overrides=")
    $flags += ("--pod-running-timeout=")
    $flags += ("--port=")
    $flags += ("--quiet")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--requests=")
    $flags += ("--restart=")
    $flags += ("--rm")
    $flags += ("--save-config")
    $flags += ("--serviceaccount=")
    $flags += ("--stdin")
    $flags += ("-i")
    $flags += ("--template=")
    $flags += ("--timeout=")
    $flags += ("--tty")
    $flags += ("-t")
    $flags += ("--wait")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
            
    $commands += $flags;
    return $commands;
}

function Get-scale() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--current-replicas=")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--replicas=")
    $flags += ("--resource-version=")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--timeout=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
                            
    $commands += $flags;
    return $commands;
}

function Get-set() {

    $commands = [System.Collections.ArrayList]@()
    $flags = [System.Collections.ArrayList]@()

    $commands += ("env")
    $commands += ("image")
    $commands += ("resources")
    $commands += ("selector")
    $commands += ("serviceaccount")
    $commands += ("subject")

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")     
    
    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-set-$resource"
    }
    
    $commands += $flags;
    return $commands;
}

function Get-taint() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--output=")
    $flags += ("--overwrite")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
             
    $commands += $flags;
    return $commands;
}

function Get-top() {

    $commands = [System.Collections.ArrayList]@()
    $flags = [System.Collections.ArrayList]@()
    $commands += ("node")
    $commands += ("pod")

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    if ($commands.Contains($cmdLn.Commands[2])) {
        $resource = $cmdLn.Commands[2];
        return Invoke-Expression "Get-top-$resource"
    }

    $commands += $flags;
    return $commands;
}

function Get-uncordon() {

    $flags = [System.Collections.ArrayList]@()

    $flags += ("--dry-run")
    $flags += ("--selector=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-version() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--client")
    $flags += ("--output=")
    $flags += ("--short")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-wait() {
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all")
    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--field-selector=")
    $flags += ("--filename=")
    $flags += ("--for=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--timeout=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
         
    $commands += $flags;
    return $commands;
}

function Get-KubectlGet() {
    
    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@()

    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--chunk-size=")
    $flags += ("--field-selector=")
    $flags += ("--filename=")
    $flags += ("--ignore-not-found")
    $flags += ("--kustomize=")
    $flags += ("--label-columns=")
    $flags += ("--no-headers")
    $flags += ("--output=")
    $flags += ("--output-watch-events")
    $flags += ("--raw=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--server-print")
    $flags += ("--show-kind")
    $flags += ("--show-labels")
    $flags += ("--sort-by=")
    $flags += ("--template=")
    $flags += ("--watch")
    $flags += ("-w")
    $flags += ("--watch-only")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += Get-CommonApiResources;
    
    if ($commands.Contains($cmdLn.Commands[2]) ) {

        if ($cmdLn.WordToComplete -eq $cmdLn.Commands[2]) {
            return $null;
        }
        return $flags;
    }
    

    $commands += $flags;
    return $commands;
}

function Get-CommonApiResources {
    return (
        "bindings",
        "componentstatuses",
        "configmaps",
        "endpoints",
        "events",
        "limitranges",
        "namespaces",
        "nodes",
        "persistentvolumeclaims",
        "persistentvolumes",
        "pods",
        "podtemplates",
        "replicationcontrollers",
        "resourcequotas",
        "secrets",
        "serviceaccounts",
        "services",
        "mutatingwebhookconfigurations.admissionregistration.k8s.io",
        "validatingwebhookconfigurations.admissionregistration.k8s.io",
        "customresourcedefinitions.apiextensions.k8s.io",
        "apiservices.apiregistration.k8s.io",
        "controllerrevisions.apps",
        "daemonsets.apps",
        "deployments.apps",
        "replicasets.apps",
        "statefulsets.apps",
        "tokenreviews.authentication.k8s.io",
        "localsubjectaccessreviews.authorization.k8s.io",
        "selfsubjectaccessreviews.authorization.k8s.io",
        "selfsubjectrulesreviews.authorization.k8s.io",
        "subjectaccessreviews.authorization.k8s.io",
        "horizontalpodautoscalers.autoscaling",
        "cronjobs.batch",
        "jobs.batch",
        "leases.coordination.k8s.io",
        "events.events.k8s.io",
        "daemonsets.extensions",
        "deployments.extensions",
        "ingresses.extensions",
        "networkpolicies.extensions",
        "podsecuritypolicies.extensions",
        "replicasets.extensions",
        "ingresses.networking.k8s.io",
        "networkpolicies.networking.k8s.io",
        "runtimeclasses.node.k8s.io",
        "poddisruptionbudgets.policy",
        "podsecuritypolicies.policy",
        "clusterrolebindings.rbac.authorization.k8s.io",
        "clusterroles.rbac.authorization.k8s.io",
        "rolebindings.rbac.authorization.k8s.io",
        "roles.rbac.authorization.k8s.io",
        "priorityclasses.scheduling.k8s.io",
        "csidrivers.storage.k8s.io",
        "csinodes.storage.k8s.io",
        "storageclasses.storage.k8s.io",
        "volumeattachments.storage.k8s.io"
    );
}

function Get-alpha-debug() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    
    $flags += ("--arguments-only")
    $flags += ("--attach")
    $flags += ("--container=")
    $flags += ("--env=")
    $flags += ("--image=")
    $flags += ("--image-pull-policy=")
    $flags += ("--quiet")
    $flags += ("--stdin")
    $flags += ("-i")
    $flags += ("--target=")
    $flags += ("--tty")
    $flags += ("-t")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-apply-edit-last-applied() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    
    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--windows-line-endings")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-apply-set-last-applied() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--create-annotation")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--output=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function Get-apply-view-last-applied() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all") 
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-auth-can-i() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--list")
    $flags += ("--no-headers")
    $flags += ("--quiet")
    $flags += ("-q")
    $flags += ("--subresource=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}
function Get-auth-reconcile() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--remove-extra-permissions")
    $flags += ("--remove-extra-subjects")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}
function Get-certificate-approve() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--force")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}
function Get-certificate-deny() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
 
    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--force")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}
function Get-cluster-info-dump() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--namespaces=")
    $flags += ("--output=")
    $flags += ("--output-directory=")
    $flags += ("--pod-running-timeout=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-current-context() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-delete-cluster() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function  Get-config-delete-context() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-get-clusters() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-get-contexts() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--no-headers")
    $flags += ("--output=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-rename-context() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-set-cluster() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--embed-certs")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-set-context() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--current")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-set-credentials() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--auth-provider=")
    $flags += ("--auth-provider-arg=")
    $flags += ("--embed-certs")
    $flags += ("--exec-api-version=")
    $flags += ("--exec-arg=")
    $flags += ("--exec-command=")
    $flags += ("--exec-env=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-unset() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-use-context() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function  Get-config-view() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--flatten")
    $flags += ("--merge")
    $flags += ("--minify")
    $flags += ("--output=")
    $flags += ("--raw")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-clusterrole() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--aggregation-rule=")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--non-resource-url=")
    $flags += ("--output=")
    $flags += ("--resource=")
    $flags += ("--resource-name=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--verb=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")   

    $commands += $flags;
    return $commands;
}

function Get-create-clusterrolebinding() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--clusterrole=")
    $flags += ("--dry-run")
    $flags += ("--group=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--serviceaccount=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-configmap() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--append-hash")
    $flags += ("--dry-run")
    $flags += ("--from-env-file=")
    $flags += ("--from-file=")
    $flags += ("--from-literal=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-cronjob() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--image=")
    $flags += ("--output=")
    $flags += ("--restart=")
    $flags += ("--save-config")
    $flags += ("--schedule=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-deployment() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--image=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    
    $commands += $flags;
    return $commands;
}

function Get-create-job() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--from=")
    $flags += ("--image=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-namespace() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-poddisruptionbudget() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--max-unavailable=")
    $flags += ("--min-available=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-priorityclass() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--description=")
    $flags += ("--dry-run")
    $flags += ("--global-default")
    $flags += ("--output=")
    $flags += ("--preemption-policy=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--value=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-quota() {
    
    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--hard=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--scopes=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function Get-create-role() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--output=")
    $flags += ("--resource=")
    $flags += ("--resource-name=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--verb=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
   
    $commands += $flags;
    return $commands;
}

function Get-create-rolebinding() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--clusterrole=")
    $flags += ("--dry-run")
    $flags += ("--group=")
    $flags += ("--output=")
    $flags += ("--role=")
    $flags += ("--save-config")
    $flags += ("--serviceaccount=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function Get-create-secret-docker-registry() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--append-hash")
    $flags += ("--docker-email=")
    $flags += ("--docker-password=")
    $flags += ("--docker-server=")
    $flags += ("--docker-username=")
    $flags += ("--dry-run")
    $flags += ("--from-file=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-secret-generic() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--append-hash")
    $flags += ("--dry-run")
    $flags += ("--from-env-file=")
    $flags += ("--from-file=")
    $flags += ("--from-literal=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--type=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-secret-tls() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--append-hash")
    $flags += ("--cert=")
    $flags += ("--dry-run")
    $flags += ("--key=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-secret() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    
    $commands += ("docker-registry")
    $commands += ("generic")
    $commands += ("tls")

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    
    if ($commands.Contains($cmdLn.Commands[3])) {
        return $flags;    
    }
    
    $commands += $flags;
    return $commands;
}

function Get-create-service-clusterip() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--clusterip=")
    $flags += ("--dry-run")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--tcp=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-service-externalname() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--external-name=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--tcp=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-service-loadbalancer() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--tcp=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-create-service-nodeport() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--node-port=")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--tcp=")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function Get-create-service() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
   
    $commands += ("clusterip")
    $commands += ("externalname")
    $commands += ("loadbalancer")
    $commands += ("nodeport")

    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function Get-create-serviceaccount() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--output=")
    $flags += ("--save-config")
    $flags += ("--template=")
    $flags += ("--validate")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

function Get-rollout-history() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $nouns = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--revision=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $nouns += ("daemonset")
    $nouns += ("deployment")
    $nouns += ("statefulset")
    
    if ($nouns.Contains($cmdLn.Commands[3])) {
        $commands += $flags;
        return $commands;
    }

    $commands += $nouns;
    $commands += $flags;
    return $commands;
}

function Get-rollout-pause() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $nouns = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $nouns += ("deployment")
    
    if ($nouns.Contains($cmdLn.Commands[3])) {
        $commands += $flags;
        return $commands;
    }

    $commands += $nouns;
    $commands += $flags;
    return $commands;
}

function Get-rollout-restart() {

    $commands = [System.Collections.ArrayList]@();
    $nouns = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $nouns += ("daemonset")
    $nouns += ("deployment")
    $nouns += ("statefulset")

    
    if ($nouns.Contains($cmdLn.Commands[3])) {
        $commands += $flags;
        return $commands;
    }

    $commands += $nouns;
    $commands += $flags;
    return $commands;
}

function Get-rollout-resume() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $nouns = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")   
   
    $nouns += ("deployment")
    
    if ($nouns.Contains($cmdLn.Commands[3])) {
        $commands += $flags;
        return $commands;
    }

    $commands += $nouns;
    $commands += $flags;
    return $commands;
}

function Get-rollout-status() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $nouns = [System.Collections.ArrayList]@();
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--revision=")
    $flags += ("--timeout=")
    $flags += ("--watch")
    $flags += ("-w")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $nouns += ("daemonset")
    $nouns += ("deployment")
    $nouns += ("statefulset")

    
    if ($nouns.Contains($cmdLn.Commands[3])) {
        $commands += $flags;
        return $commands;
    }
    
    $commands += $flags;
    $commands += $nouns;
    
    return $commands;
}

function Get-rollout-undo() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $nouns = [System.Collections.ArrayList]@();

    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--to-revision=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
    
    $nouns += ("daemonset")
    $nouns += ("deployment")
    $nouns += ("statefulset")
    
    if ($nouns.Contains($cmdLn.Commands[3])) {
        $commands += $flags;
        return $commands;
    }

    $commands += $nouns;
    $commands += $flags;

    return $commands;
}

function Get-set-env() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();

    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--containers=")
    $flags += ("--dry-run")
    $flags += ("--env=")
    $flags += ("--filename=")
    $flags += ("--from=")
    $flags += ("--keys=")
    $flags += ("--kustomize=")
    $flags += ("--list")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--overwrite")
    $flags += ("--prefix=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--resolve")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-set-image() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-set-resources() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--containers=")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--limits=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--requests=")
    $flags += ("--selector=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-set-selector() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--resource-version=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-set-serviceaccount() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--kustomize=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--record")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-set-subject() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all")
    $flags += ("--allow-missing-template-keys")
    $flags += ("--dry-run")
    $flags += ("--filename=")
    $flags += ("--group=")
    $flags += ("--kustomize=")
    $flags += ("--local")
    $flags += ("--output=")
    $flags += ("--recursive")
    $flags += ("-R")
    $flags += ("--selector=")
    $flags += ("--serviceaccount=")
    $flags += ("--template=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-top-node() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--heapster-namespace=")
    $flags += ("--heapster-port=")
    $flags += ("--heapster-scheme=")
    $flags += ("--heapster-service=")
    $flags += ("--no-headers")
    $flags += ("--selector=")
    $flags += ("--sort-by=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")

    $commands += $flags;
    return $commands;
}

function Get-top-pod() {

    $commands = [System.Collections.ArrayList]@();
    $flags = [System.Collections.ArrayList]@();
    $flags += ("--all-namespaces")
    $flags += ("-A")
    $flags += ("--containers")
    $flags += ("--heapster-namespace=")
    $flags += ("--heapster-port=")
    $flags += ("--heapster-scheme=")
    $flags += ("--heapster-service=")
    $flags += ("--no-headers")
    $flags += ("--selector=")
    $flags += ("--sort-by=")
    $flags += ("--add-dir-header")
    $flags += ("--alsologtostderr")
    $flags += ("--as=")
    $flags += ("--as-group=")
    $flags += ("--cache-dir=")
    $flags += ("--certificate-authority=")
    $flags += ("--client-certificate=")
    $flags += ("--client-key=")
    $flags += ("--cluster=")
    $flags += ("--context=")
    $flags += ("--insecure-skip-tls-verify")
    $flags += ("--kubeconfig=")
    $flags += ("--log-backtrace-at=")
    $flags += ("--log-dir=")
    $flags += ("--log-file=")
    $flags += ("--log-file-max-size=")
    $flags += ("--log-flush-frequency=")
    $flags += ("--logtostderr")
    $flags += ("--match-server-version")
    $flags += ("--namespace=")
    $flags += ("--password=")
    $flags += ("--profile=")
    $flags += ("--profile-output=")
    $flags += ("--request-timeout=")
    $flags += ("--server=")
    $flags += ("--skip-headers")
    $flags += ("--skip-log-headers")
    $flags += ("--stderrthreshold=")
    $flags += ("--tls-server-name=")
    $flags += ("--token=")
    $flags += ("--user=")
    $flags += ("--username=")
    $flags += ("--v=")
    $flags += ("--vmodule=")
   
    $commands += $flags;
    return $commands;
}

Export-ModuleMember Register-KubectlCompletion