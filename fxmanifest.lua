fx_version 'bodacious'

games {"gta5"}

author "Nevo#2020"
description "Advanced Active Officers System"
version "1.0.0"

ui_page "html/index.html"

shared_script "config.lua"
client_script "client.lua"
server_script '@mysql-async/lib/MySQL.lua'
server_script "server.lua"

files {
    "html/*.html",
    "html/*.css",
    "html/*.js",
}