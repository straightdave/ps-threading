##
## ps-threading scaffold
## REAL threading in PowerShell
## Dave Wu, eyaswoo@gmail.com, Mar 2014
##

#=======================
# parameters
$min = 1  # min runspace(s) in the pool
$max = 5  # max runspace(s) in the pool

$block = {
  param($p)
  
  # what you want to do in threads
  $p >> .\log.txt
}


$pool = [RunspaceFactory]::CreateRunspacePool($min,$max)
$pool.open()

(1..10) | %{
  $t = [powershell]::create()
  $t.RunspacePool = $pool
  [void]$t.AddScript($block)
  [void]$t.AddParameter("p",$_)
  
  $job = $t.BeginInvoke()

  # you can call endinvoke in/out this loop
  # $t.EndInvoke($job)
}
