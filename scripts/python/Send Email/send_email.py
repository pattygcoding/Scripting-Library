#!/usr/bin/env python3
"""Send an email through an SMTP server.

Credentials are read from arguments or environment variables so they never have
to be hard-coded: SMTP_HOST, SMTP_PORT, SMTP_USER and SMTP_PASSWORD.
"""

from __future__ import annotations

import argparse
import os
import smtplib
import sys
from email.mime.text import MIMEText


def send_email(
    subject: str,
    body: str,
    to_email: str,
    *,
    host: str,
    port: int,
    from_email: str,
    password: str,
) -> None:
    """Send a plain-text email."""
    message = MIMEText(body)
    message["Subject"] = subject
    message["From"] = from_email
    message["To"] = to_email

    with smtplib.SMTP_SSL(host, port) as server:
        server.login(from_email, password)
        server.sendmail(from_email, to_email, message.as_string())


def main() -> int:
    parser = argparse.ArgumentParser(description="Send an email from Python.")
    parser.add_argument("subject", help="Email subject.")
    parser.add_argument("body", help="Email body.")
    parser.add_argument("to", help="Recipient address.")
    parser.add_argument("--host", default=os.environ.get("SMTP_HOST", "smtp.example.com"), help="SMTP host.")
    parser.add_argument("--port", type=int, default=int(os.environ.get("SMTP_PORT", "465")), help="SMTP port.")
    parser.add_argument("--from", dest="from_email", default=os.environ.get("SMTP_USER", ""), help="Sender address.")
    parser.add_argument("--password", default=os.environ.get("SMTP_PASSWORD", ""), help="Sender password.")
    args = parser.parse_args()

    if not args.from_email or not args.password:
        print("Error: set --from/--password or SMTP_USER/SMTP_PASSWORD.", file=sys.stderr)
        return 1

    send_email(
        args.subject,
        args.body,
        args.to,
        host=args.host,
        port=args.port,
        from_email=args.from_email,
        password=args.password,
    )
    print("Email sent.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
