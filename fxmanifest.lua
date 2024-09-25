fx_version 'cerulean'
game 'gta5'

name 'ejj_businesscard'
description 'EJJ_04'
author 'EJJ_04'
version '1.0.0'
lua54 'yes'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
    '@mysql-async/lib/MySQL.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/image.png',
    'html/image2.png',
    'locales/*.json'
}