# Test that SSL sample programs can interoperate with OpenSSL and GnuTLS.

# Copyright The Mbed TLS Contributors
# SPDX-License-Identifier: Apache-2.0 OR GPL-2.0-or-later

: ${PROGRAMS_DIR:=../programs/ssl}

requires_protocol_version tls12
run_test    "Sample: ssl_client1, openssl server, TLS 1.2" \
            -P 4433 \
            "$O_SRV -tls1_2" \
            "$PROGRAMS_DIR/ssl_client1" \
            0 \
            -c "New, TLSv1.2, Cipher is" \
            -S "ERROR" \
            -C "error"

requires_protocol_version tls12
run_test    "Sample: ssl_client1, gnutls server, TLS 1.2" \
            -P 4433 \
            "$G_SRV --priority=NORMAL:-VERS-TLS-ALL:+VERS-TLS1.2" \
            "$PROGRAMS_DIR/ssl_client1" \
            0 \
            -s "Version: TLS1.2" \
            -c "<TD>Protocol version:</TD><TD>TLS1.2</TD>" \
            -S "Error" \
            -C "error"

requires_protocol_version tls13
run_test    "Sample: ssl_client1, openssl server, TLS 1.3" \
            -P 4433 \
            "$O_SRV -tls1_3" \
            "$PROGRAMS_DIR/ssl_client1" \
            0 \
            -c "New, TLSv1.3, Cipher is" \
            -S "ERROR" \
            -C "error"

requires_protocol_version tls13
run_test    "Sample: ssl_client1, gnutls server, TLS 1.3" \
            -P 4433 \
            "$G_SRV --priority=NORMAL:-VERS-TLS-ALL:+VERS-TLS1.3" \
            "$PROGRAMS_DIR/ssl_client1" \
            0 \
            -s "Version: TLS1.3" \
            -c "<TD>Protocol version:</TD><TD>TLS1.3</TD>" \
            -S "Error" \
            -C "error"

requires_protocol_version dtls12
run_test    "Sample: dtls_client, openssl server, DTLS 1.2" \
            -P 4433 \
            "$O_SRV -dtls1_2" \
            "$PROGRAMS_DIR/dtls_client" \
            0 \
            -s "Echo this" \
            -s "DONE" \
            -c "Echo this" \
            -c "[1-9][0-9]* bytes written" \
            -c "[1-9][0-9]* bytes read" \
            -S "ERROR" \
            -C "error"

requires_protocol_version dtls12
run_test    "Sample: dtls_client, gnutls server, DTLS 1.2" \
            -P 4433 \
            "$G_SRV -u --echo --priority=NORMAL:-VERS-TLS-ALL:+VERS-TLS1.2" \
            "$PROGRAMS_DIR/dtls_client" \
            0 \
            -s "Server listening" \
            -s "[1-9][0-9]* bytes command:" \
            -c "Echo this" \
            -c "[1-9][0-9]* bytes written" \
            -c "[1-9][0-9]* bytes read" \
            -S "Error" \
            -C "error"
