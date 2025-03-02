-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Ovrwrld'
description 'Custom Gang System for QBCore, Built By Ovrwrld'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Remove if not using oxmysql
    'server.lua'
}

dependencies {
    'qb-core'
}

resource_name 'ovr-gangs'
