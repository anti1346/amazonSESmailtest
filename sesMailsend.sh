#!/bin/bash

SMTPDomain=sangchul.kr
SMTPServer=email-smtp.ap-northeast-2.amazonaws.com
SMTPPort=587
SMTPUsername=`echo -n "SMTPUSERNAME" | openssl enc -base64`
SMTPPassword=`echo -n "SMTPPASSWORD" | openssl enc -base64`
MAILFrom=noreply@${SMTPDomain}
MAILTo=${1:-testadmin@gmail.com}

cat <<EOF > input.txt
EHLO ${SMTPDomain}
AUTH LOGIN
${SMTPUsername}
${SMTPPassword}
MAIL FROM: ${MAILFrom}
RCPT TO: ${MAILTo}
DATA
From: Sender Name <noreply@${SMTPDomain}>
To: ${MAILTo}
Subject: Amazon SES SMTP 테스트

이 메시지는 Amazon SES SMTP 인터페이스를 사용하여 전송되었습니다.
.
QUIT
EOF

openssl s_client -crlf -quiet -starttls smtp -connect ${SMTPServer}:${SMTPPort} < input.txt
