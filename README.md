SkyCam
======

This camera consists of two parts:

* The `broadcast` command -- this streams camera output to an RMTP server.
* The `broadcast.service` systemd service runs the aforementioned command at system start and keeps it alive if it crashes. This is symlinked into `/lib/systemd/system`.

The file `.skycamrc` is sourced by the `broadcast` command to set the ID of the stream. This ID is the UUID component of the RTMP URL to which the stream is pushed.
