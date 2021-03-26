$ORIGIN progetto.com.
$TTL 60000
@ IN		SOA	ns.progetto.com.	admin.progetto.com. (1 28800 14400 36000000 0)
@ IN		NS	ns.progetto.com.
ns.progetto.com.	IN	A	100.0.0.1

SMTP			IN	A	100.0.0.3
HTTP			IN	A	100.0.0.4
@			IN	MX	10	SMTP.progetto.com. 
