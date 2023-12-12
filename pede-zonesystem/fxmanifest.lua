fx_version 'adamant'

game 'gta5'

author 'ledepede1'
description 'Pede Kørelærer'

--[[
Pede DriveSchool Job needs following dependencies:
ox_lib
ox_mysql
esx
]]--

version '1.0'

lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
}

shared_scripts {
  '@es_extended/imports.lua',
  'Locales/*'
}


client_scripts {
  'Configs/Config.lua',
  'Client/Main.lua',
  'Client/Menu.lua',
  'Client/Commands.lua',
  'Client/Selling.lua',
  'Client/Points.lua',
  'Client/Settings.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'Configs/Config.lua',
  'Server/Server.lua',
  'Server/Selling.lua',
  'Server/Settings.lua',
}

dependencies {
	'es_extended',
}