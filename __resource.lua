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