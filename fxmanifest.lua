fx_version 'adamant'

game 'gta5'

name 'RoJea Property'
description 'ESX based property script without instancing'
author 'RoJea'
version 'v1.0.1'

ui_page 'html/index.html'

lua54 'yes'

client_scripts {
  '@es_extended/locale.lua',
  'decorate.lua',
  'locales/lt.lua',
  'config.lua',
  'properties.lua',
  'client.lua'
}

server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/lt.lua',
  'config.lua',
  'properties.lua',
  'server.lua'
}

files {
  'html/index.html',
  'html/reset.css',
  'html/style.css',
  'html/script.js',
  'html/img/dynasty8-logo.png'
}

dependencies {
  'es_extended'
}
