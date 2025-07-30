fx_version 'cerulean'
game 'gta5'
version '1.0.0'

author 'RMScripts'
description 'Redesign by RMScripts'

ui_page "html/ui.html"

client_scripts {
    'client.lua',
	'config.lua',
}

server_scripts {
	'config.lua',
	'server.lua',
}

files {
    "html/*"
}