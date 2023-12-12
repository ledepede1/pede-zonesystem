local lang = Config.Language

function ZoneMenu()
    lib.registerContext({
      id = 'zones_main_menu',
      title = 'Zone System',
      options = {
        {
          title = Config.Menus.MainMenu.options.currentzone.title,
          icon = Config.Menus.MainMenu.options.currentzone.icon,
          onSelect = function ()
            TriggerServerEvent("get:zone:coords")
            
            local zone = nil
            local playerPed = GetPlayerPed(-1)
            local playerCoords = GetEntityCoords(playerPed)

            while zone == nil do
              Citizen.Wait(10)
              zone = CheckPlayerZones(playerCoords)
            end

            lib.notify({
              title = Locales[lang]['currentzone']['notify'].title,
              description = Locales[lang]['currentzone']['notify'].desc..zone,
              type = "inform"
            })
          end,
        },
        {
          title = Config.Menus.MainMenu.options.zonelist.title,
          icon = Config.Menus.MainMenu.options.zonelist.icon,
          onSelect = function ()
            TriggerServerEvent("get:all:zones:server")
            Citizen.Wait(200)
            ZoneListMenu()
          end,
        },
        {
          title = Config.Menus.MainMenu.options.ownedzones.title,
          icon = Config.Menus.MainMenu.options.ownedzones.icon,
          onSelect = function ()
            TriggerServerEvent("get:allowned:zones:server", ESX.PlayerData.job.name)
            Citizen.Wait(200)
            OwnedZonesMenu()
          end,
        },
        {
          title = Config.Menus.MainMenu.options.settings.title,
          icon = Config.Menus.MainMenu.options.settings.icon,
          onSelect = function()
            SettingsMenu()
          end
        },
      }
    })
   
    lib.showContext('zones_main_menu')
end

function ZoneListMenu()
  lib.registerContext({
    id = 'zone_list_menu',
    title = Config.Menus.ZoneListMenu.title,
    menu = 'zones_main_menu',
    options = GetZones()
  })
 
  lib.showContext('zone_list_menu')
end

function OwnedZonesMenu()
  lib.registerContext({
    id = 'owned_zones_menu',
    title = Config.Menus.OwnedZonesMenu.title,
    menu = 'zones_main_menu',
    options = GetOwnedZones()
  })
 
  lib.showContext('owned_zones_menu')
end