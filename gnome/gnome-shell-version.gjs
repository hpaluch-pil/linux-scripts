#!/usr/bin/gjs -m
// query GNOME Shell version, adapted from: https://gjs.guide/guides/gio/dbus.html (example broken)
// fixed usin call-sync from gnome-shell-47.2/js/dbusServices/dbusService.js
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';

const reply = Gio.DBus.session.call_sync(
        'org.gnome.Shell',
        '/org/gnome/Shell',
        'org.freedesktop.DBus.Properties',
        'Get',
        new GLib.Variant('(ss)', [
            'org.gnome.Shell',
            'ShellVersion',
        ]),
        null,
        Gio.DBusCallFlags.NONE,
        -1,
        null);

const [version] = reply.recursiveUnpack();

console.log(`GNOME Shell Version: ${version}`);

