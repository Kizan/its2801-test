#eMail Everyone is John Powers and Goals

#Douglas Bowie

Clear-Host

#Import Custom Functions
$basepath             = "R:\My Drive\Scripts\PS\"
Import-Module -Name $basepath"Modules\drb-mods.psm1" #-Verbose

$timestamp = Get-Date -Format FileDateTime | ForEach-Object {$_ -replace ":", "."}
$logfile             = $basepath+"log\$timestamp - EiJ-eMail.log"
$data_source_folder  = $basepath+"Everyone is John\Data"

$src_goal_list           = $data_source_folder+"\goals.csv"
$src_power_list          = $data_source_folder+"\powers.csv"

$mail_server = "mailrelay.oit.ohio.edu"

$msg_subject  = "Everyone is John! A Problem Solving Party Game!"

$from_email = "bowie@ohio.edu"

$goal_list = Import-CSV $src_goal_list
$power_list = Import-CSV $src_power_list

$goal_list = Randomize-List -InputList $goal_list
$power_list = Randomize-List -InputList $power_list

$studentnamefile = Get-FileName -initialDirectory $data_source_folder
if ($studentnamefile -eq "") { 
    exit 
} else {
    $StudentName_CSV = Import-CSV $studentnamefile
}

Clear-Content $logfile -ErrorAction SilentlyContinue

$timestamp=$(Get-Date -f yyyy-MM-dd-HH:mm:ss)
Write-Log "START - EiJ eMail Process: $timestamp"

$i = 25

foreach($guestlist in $StudentName_CSV){
    if ($i -lt 25) {
        $i = $i +1
    } else {
        $goal_list = Randomize-List -InputList $goal_list
        $power_list = Randomize-List -InputList $power_list
        $i = 0
    }

    $msg_body1 = " "
        
    $guest_first = $guestlist.first
    $guest_last = $guestlist.last
    $guest_email = $guestlist.email
    $power = $power_list[$i].powers
    $goal = $goal_list[$i].goal

    $msg_body1 = 
"<h0>Dear $guest_first $guest_last,</h0><br>
<br>
<h0>Everyone is John! A Problem Solving Party Game!</h0><br>
<br>
<h0>You will need this information for a class excercise!</h0><br>
<br>
<h0>Your Super-Power: <b>$power</b></h0><br>
<br>
<h0>Your current Minor Goal: <b>$goal</b><h0><br>
<br>
<br>
<h0>Good luck this semester,</h0><br>
<h0>Douglas Bowie</h0><br>"

        Send-MailMessage -To $guest_email -From $from_email -Subject $msg_subject -Body $msg_body1 -BodyAsHtml -SmtpServer $mail_server -Port 25 -UseSsl 
        #Write-Host $msg_body1
        #Pause

        $timestamp=$(Get-Date -f yyyy-MM-dd-HH:mm:ss)
        Write-Log "$timestamp - eMail sent to: $guest_email, $power, $goal"

        write-host "eMail sent to: $guest_email, $power, $goal"  -foreground green 
        #Start-Sleep -Seconds 5
    }

$timestamp=$(Get-Date -f yyyy-MM-dd-HH:mm:ss)
Write-Log "Finish - EiJ eMail Process: $timestamp"