import smtplib
from email.mime.text import MIMEText

def send_email(subject, body, to_email):
    from_email = 'your-email@example.com'
    from_password = 'your-email-password'
    
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = from_email
    msg['To'] = to_email

    server = smtplib.SMTP_SSL('smtp.example.com', 465)
    server.login(from_email, from_password)
    server.sendmail(from_email, to_email, msg.as_string())
    server.quit()

send_email('Test Subject', 'Test Body', 'recipient@example.com')
