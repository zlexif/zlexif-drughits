fx_version 'cerulean'
games { 'gta5' }

author 'ZDevelopment'
description 'A lucid city inspired script by ZDevelopment'
version '1.0.0'

server_scripts {
    'config.lua',
    'server/server.lua'
}

client_scripts {
    'config.lua',
    'client/client.lua'
}

dependencies {
    'qb-core',
    'qb-target'
}
