Hi! This directory is reserved for e3v-watchtower configuration files.
Explanation of files below:


* watchtower.db  watchtower.db-shm  watchtower.db-wal

This is a sqlite3 database (and write-ahead-log) that keeps track of camera
settings, interface settings, users, sessions, and additional program-specific
data across running instances. These files will be created if they do not
exist.

Advanced usage: You can run standard SQL(ITE) queries on the sqlite3 database.


* watchtowerid.key

This is a json file containing a Watchtower identity key. Watchtower will load
this keypair at startup (or randomly generate a keypair if does not exist),
which determines the Watchtower ID, and is used for the cryptographic binding
of each e3vision camera.

Advanced usage: If this key is moved to another installation of Watchtower,
it can be used to "resume" a "bound" session elsewhere. If you do choose to
migrate the key file, please make sure you don't duplicate Watchtower IDs/
keys, as they can interfere with each other if they're all trying to control
the same set of cameras.


* pubcert.pem  privkey.pem

These are the public and private files of webserver TLS certificates. By default
we provide a self-signed cert to provide https:// service out of the box even
for completely offline usage.

Advanced usage: They can be replaced by any X509 certificate pair of your choice
if you are running this over public internet and have a CA-signed certificate
chain back to the browser root of trust. (Or use mkcert, minisign, etc.)
