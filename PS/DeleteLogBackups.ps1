$TLogShare = "\\backup{0}\backup\log"

function sendMail ($body){

     #SMTP server name
     $smtpServer = "smtp.domain.tld"

     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage

     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)

     #Email structure 
     $msg.From = "noreply@domain.tld"
     $msg.ReplyTo = "noreply@domain.tld"
     $msg.To.Add("dba@domain.tld")
     $msg.IsBodyHtml = $true
     $msg.subject = "Deleted LOG backups older then 2 days"
     $msg.body = $body

     #Sending email 
     $smtp.Send($msg)
  
}

$body = ""

foreach ($a in (1,2)) {
    $body += ls $($TLogShare -f $a) -Recurse -Include ('*.trn', '*.tlog') | Where-Object {$_.CreationTime -lt (get-date(Get-Date -Format D)).AddDays(-2)} | `
                    foreach { "Removing file: $($_.FullName) &nbsp;&nbsp;&nbsp;&nbsp; CreationTime: $("{0:yyyy-MM-dd} 00.00.00" -f $_.CreationTime ) <br />"; Remove-Item $_ }
}

sendMail($body)

