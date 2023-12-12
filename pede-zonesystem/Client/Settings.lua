-- Settings siden

local ONorOFF
IsBlipEnabled = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerServerEvent("fetchPlayerSettings")

    while IsBlipEnabled == nil do
        Citizen.Wait(10)
    end

    if IsBlipEnabled == true then
        TriggerServerEvent("get:zone:coords")
        
        while #vectorList == 0 do
            Citizen.Wait(10)
        end
    
        CreateBlips(vectorList)    
        IsBlipEnabled = nil
    else
        if #vectorList ~= 0 then
            RemoveBlips()
            IsBlipEnabled = nil
        end
    end

    TriggerServerEvent("playerSpawn:Zone:System")
end)

RegisterNetEvent("ReturnToClient")
AddEventHandler("ReturnToClient", function(blips)
    if blips == 1 then
        IsBlipEnabled = true
        ONorOFF = "til"
    else
        IsBlipEnabled = false
        ONorOFF = "fra"
    end
end)


-- Blip stuff
local blips = {}


function CreateBlips(blipList)
    for _, blipData in ipairs(blipList) do
        local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)

        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 49)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipData.name)
        EndTextCommandSetBlipName(blip)

        table.insert(blips, blip)
    end
end

function RemoveBlips()
    for _, blip in ipairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}  -- Clear the blips table
end

-- Menu
function SettingsMenu()
    lib.registerContext({
      id = 'zones_settings_menu',
      title = 'Settings',
      menu = 'zones_main_menu',
      options = {
        {
            title = "Blips",
            arrow = true,
            onSelect = function ()
                TriggerServerEvent("fetchPlayerSettings")

                while IsBlipEnabled == nil do
                    Citizen.Wait(10)
                end

                BlipSettingsMenu()
            end,
        },
        {
            title = "Made by Ledepede1",
        }
      }
    })
   
    lib.showContext('zones_settings_menu')
end

function BlipSettingsMenu()
    lib.registerContext({
      id = 'zones_settings_menu_blips',
      title = 'Settings | Blips',
      menu = 'zones_settings_menu',
      options = {
        {
            title = "Slået: "..ONorOFF,
            arrow = true,
            onSelect = function ()
                if IsBlipEnabled == true then
                    IsBlipEnabled = false
                    RemoveBlips()
                else
                    IsBlipEnabled = true

                    TriggerServerEvent("get:zone:coords")
        
                    while #vectorList == 0 do
                        Citizen.Wait(10)
                    end
                
                    CreateBlips(vectorList)    
                end

                TriggerServerEvent("save:zone:blips", IsBlipEnabled)
                IsBlipEnabled = nil
            end,
        },
      }
    })
   
    lib.showContext('zones_settings_menu_blips')
end
