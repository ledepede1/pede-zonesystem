local lang = Config.Language

POLICECOUNT = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    TriggerServerEvent("playerSpawn:Zone:System")
end)
    
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent("get:all:zones:client")
AddEventHandler("get:all:zones:client", function(zones)
    Zones = zones
end)

RegisterNetEvent("get:allowned:zones:client")
AddEventHandler("get:allowned:zones:client", function(zones)
    OwnedZones = zones
end)

function GetLevel(points)
    return points / 10
end

function HasJob(Jobname, Grade)
    if Grade == nil then
        if ESX.PlayerData.job.name == Jobname then
            return true
        end
    else
        if ESX.PlayerData.job.name == Jobname then
            if ESX.PlayerData.job.grade_name == Grade then
                return true
            end
        end
    end
    return false
end


RegisterNetEvent('updatePoliceCount:client')
AddEventHandler('updatePoliceCount:client', function(onlinePoliceCount)
    POLICECOUNT = onlinePoliceCount
end)


function GetZones()
    local zones = {}

    for _, v in pairs(Zones) do
        table.insert(zones, {
            title = v.name,
            icon = "fa-solid fa-circle",
            metadata = {
                {label = Locales[lang]['zonelist']['metadata:zoneowner'], value = v.label},
                {label = Locales[lang]['zonelist']['metadata:zonepoints'], value = v.points}
              },
        })
    end

    return zones
end

function GetOwnedZones()
    local zones = {}
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local playerName = nil
    if closestPlayer == -1 or closestDistance > 3.0 then
        playerName = "Ingen spillere i nærheden"
    else
        playerName = ESX.GetPlayerFromId(closestPlayer).getName
    end

    for _, v in pairs(OwnedZones) do
        table.insert(zones, {
            title = v.name,
            icon = "fa-solid fa-circle",
            onSelect = function ()
                if ESX.PlayerData.job.grade_name == "boss" then
                    TriggerServerEvent("Get:Points:Zone", v.name)
                    Citizen.Wait(150)
                    local percentToTake = 0

                    for i = 1, Points, 1 do
                        percentToTake = i / 500
                        if percentToTake >= Config.MaxPercent then
                            break
                        end
                    end
                    
                    local percent = math.floor((percentToTake / Config.MaxPercent) * 100)

                    lib.registerContext({
                        id = v.name.."_menu",
                        title = v.name,
                        menu = 'owned_zones_menu',
                        options = {
                            {
                                title = Config.Menus.OwnedZonesMenu.percent.title..percentToTake.."%",
                                progress = percent,
                                colorScheme = Config.Menus.OwnedZonesMenu.percent.colorScheme,
                            },
                            {
                                title = Config.Menus.OwnedZonesMenu.changeOwner.title,
                                metadata = {
                                    {label = Config.Menus.OwnedZonesMenu.changeOwner.metadata, value = playerName}
                                },
                                onSelect = function ()
                                    if closestPlayer == -1 or closestDistance > 3.0 then
                                            lib.notify({
                                                title = Locales[lang]["changeZoneOwner"]["errNotify"].title,
                                                description = Locales[lang]["changeZoneOwner"]["errNotify"].desc,
                                                type = "error"
                                            })
                                        else

                                            local confirm = lib.alertDialog({
                                                header = Config.Menus.OwnedZonesMenu.changeOwner.confirmDialog.title,
                                                content = Config.Menus.OwnedZonesMenu.changeOwner.confirmDialog.desc..playerName,
                                                centered = true,
                                                cancel = true
                                            })

                                            if confirm == "confirm" then
                                            if ESX.GetPlayerFromId(closestPlayer).job.grade_name == "boss" then
                                                TriggerServerEvent("edit:owner:zone", v.name, ESX.GetPlayerFromId(closestPlayer).job.name)
                                            end
                                        end
                                    end
                                end,
                            },
                            {
                                title = "Tilføj alliance",
                                onSelect = function()
                                    local input = lib.inputDialog(v.name..Config.Menus.OwnedZonesMenu.addAlliance.title, {
                                        {type = 'input', label = Config.Menus.OwnedZonesMenu.addAlliance.gangName, description =  Config.Menus.OwnedZonesMenu.addAlliance.gangNameDesc, required = true, min = 4, max = 16},
                                        {type = 'checkbox', label = Config.Menus.OwnedZonesMenu.addAlliance.confirm},
                                      })
              

                                    if input == nil or input[1] == nil or input[2] == nil or input[2] == false or input[1] == "" then return end
                                    TriggerServerEvent("add:zone:alliance", v.name, input[1])
                                end
                            },
                            {
                                title = Config.Menus.OwnedZonesMenu.getEditAlliances.title,
                                onSelect = function()
                                    TriggerServerEvent("get:zone:alliances", v.name)
                                    while #AlliancesListMenu == 0 do
                                        Citizen.Wait(10)
                                    end

                                    lib.registerContext({
                                        id = v.name..'alliance_list',
                                        title = 'Alliancer '..v.name,
                                        menu =  v.name.."_menu",
                                        options = AlliancesListMenu
                                      })
                                     
                                      lib.showContext(v.name..'alliance_list')
                                      AlliancesListMenu = {}
                                end
                            }
                        }
                      })
                     
                      lib.showContext(v.name.."_menu")
                end
            end,
            metadata = {
                {label = 'Points', value = v.points}
              },
        })
    end

    return zones
end

local blips = {}

RegisterNetEvent("call:police:zonesystem:client")
AddEventHandler("call:police:zonesystem:client", function ()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == Config.PoliceJob then
        local coords = GetEntityCoords(GetPlayerPed(-1))
		local streetName = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		local streetString = GetStreetNameFromHashKey(streetName)
		ESX.ShowHelpNotification(Locales[lang]["police:called"]["notifyDesc"]..streetString, true, false, 170)


        local blip = AddBlipForRadius(vector3(coords), 50.0) 
        SetBlipHighDetail(blip, true) 
        SetBlipColour(blip, 1) 
        SetBlipAlpha (blip, 128)

		table.insert(blips, blip)
		Wait(50000)
		for i in pairs(blips) do
			RemoveBlip(blips[i])
			blips[i] = nil
		end
    end
end)

RegisterNetEvent("notify:zone")
AddEventHandler("notify:zone", function(title,desc,type)
    lib.notify({
        title = title,
        description = desc,
        type = type
    })
end)
