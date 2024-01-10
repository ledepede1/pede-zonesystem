---- # POLICE # ----

function CountOnlinePolice()
    local policeCount = 0

    for _, player in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer and xPlayer.job.name == 'police' then
            policeCount = policeCount + 1
        end
    end

    return policeCount
end

RegisterNetEvent('updatePoliceCount')
AddEventHandler('updatePoliceCount', function()
    local onlinePoliceCount = CountOnlinePolice()
    TriggerClientEvent('updatePoliceCount:client', -1, onlinePoliceCount)
end)

---# Command stuff #---
ESX.RegisterCommand({'zonecreate'}, 'admin', function(xPlayer, args, showError)
    if args.navn ~= nil and args.owner ~= nil and args.ownerlabel ~= nil then
        local coords = args.x..","..args.y..","..args.z
        TriggerEvent("create:new:zone", args.navn, args.owner, args.ownerlabel, coords)
    end
end, false, {help = "Opret en ny zone", arguments = {
    {name = 'navn', help = "navn på zonen", type = 'any'},
    {name = 'owner', help = "banden som ejer zonen (Job Navn)", type = 'any'},
    {name = 'ownerlabel', help = "label på banden", type = 'any'},
    {name = 'x', help = "x koordinater", type = 'any'},
    {name = 'y', help = "y koordinater", type = 'any'},
    {name = 'z', help = "z koordinater", type = 'any'},
}})

ESX.RegisterCommand({'zoneremove'}, 'admin', function(xPlayer, args, showError)
    if args.navn ~= nil then
        TriggerEvent("remove:zone", args.navn)
    end
end, false, {help = "Fjern en eksiterende zone", arguments = {
    {name = 'navn', help = "navn på zonen", type = 'any'},
}})

--- Zone Database handling ---
RegisterNetEvent("create:new:zone")
AddEventHandler("create:new:zone", function(name, owner, label, coords)
    local isEmpty = MySQL.query.await('SELECT `name` FROM `zone-system` WHERE `name` = ?', {
        name
    })

    if isEmpty[1] == nil then
        MySQL.insert.await('INSERT INTO `zone-system` (name, owner, label, coords) VALUES (?, ?, ?, ?)', {
            name, owner, label, coords
        })
        print("Created new zone")
    else
        print("Zone already exists")
    end
end)

RegisterNetEvent("remove:zone")
AddEventHandler("remove:zone", function(name, owner, label)
    local isEmpty = MySQL.query.await('SELECT `name` FROM `zone-system` WHERE `name` = ?', {
        name
    })

    if isEmpty[1] ~= nil then
        MySQL.query.await('DELETE FROM `zone-system` WHERE name=?', {
            name
        })
        print("Removed a zone")
    else
        print("Zone dosent exist")
    end
end)

---# Utils #---

RegisterNetEvent("get:all:zones:server")
AddEventHandler("get:all:zones:server", function()
    local zones = MySQL.query.await('SELECT * FROM `zone-system`')
    TriggerClientEvent("get:all:zones:client", -1, zones)
end)

RegisterNetEvent("get:allowned:zones:server")
AddEventHandler("get:allowned:zones:server", function(job)
    local zones = MySQL.query.await('SELECT * FROM `zone-system` where owner=?', {
        job
    })

    TriggerClientEvent("get:allowned:zones:client", -1, zones)
end)

RegisterNetEvent("get:zone:alliances")
AddEventHandler("get:zone:alliances", function (name)
    local alliances = MySQL.query.await('SELECT alliances FROM `zone-system` WHERE name=?', {
        name
    })
    
    --print(alliances[1].alliances)
    TriggerClientEvent("get:alliances:client", -1, json.decode(alliances[1].alliances), name)
end)

local function capitalizeFirstLetter(inputString)
    return inputString:sub(1, 1):upper() .. inputString:sub(2)
end

RegisterNetEvent("edit:owner:zone")
AddEventHandler("edit:owner:zone", function (zone, newowner)
    local label = capitalizeFirstLetter(newowner)

    MySQL.query.await('UPDATE `zone-system` SET owner=?, label=? WHERE name=?', {
        newowner, label, zone
    })
end)

--- Get Zone Coords ---
RegisterNetEvent("get:zone:coords")
AddEventHandler("get:zone:coords", function()
    local src = source
    MySQL.ready(function ()
        MySQL.Async.fetchAll(
          'SELECT name, coords FROM `zone-system`',
          function(result)
            data = result

            TriggerClientEvent("zones:list", src, data)
        end)
    end)
end)

--- Give Points ---

RegisterNetEvent("update:points:zone")
AddEventHandler("update:points:zone", function (points, zone)
    local currentPointsResult = MySQL.query.await('SELECT points FROM `zone-system` WHERE name=?', {
        zone
    })

    if currentPointsResult[1] then
        local currentPoints = tonumber(currentPointsResult[1].points)
        if currentPoints ~= nil then
            local newPoints = currentPoints + points

            MySQL.query.await('UPDATE `zone-system` SET points=? WHERE name=?', {
                newPoints, zone
            })
        end
    end
end)


-- Remove alliance & add alliance

RegisterNetEvent("add:zone:alliance")
AddEventHandler("add:zone:alliance", function(zone, allianceToAdd)

    local currentAlliances = {}
    local doesAllianceExist = false
    local Alliances = {}

    MySQL.ready(function ()
        MySQL.Async.fetchAll(
          'SELECT alliances FROM `zone-system` WHERE name = @zone', {['@zone'] = zone},
          function(result)
            Alliances = json.decode(result[1].alliances)

                for _, alliances in ipairs(Alliances) do
                    if alliances == allianceToAdd then 
                        doesAllianceExist = true 
                        break 
                    end
                    table.insert(currentAlliances, alliances)
                end


            if doesAllianceExist == false then
                table.insert(currentAlliances, allianceToAdd)
                MySQL.Async.execute('UPDATE `zone-system` SET alliances = @alliances WHERE name = @zone', {['@alliances'] = json.encode(currentAlliances), ['@zone'] = zone})
            end
        end)
        

    end)
end)

RegisterNetEvent("remove:zone:alliance")
AddEventHandler("remove:zone:alliance", function(zone, allianceToRemove)
    local currentAlliances = {}
    local updatedAlliances

    MySQL.ready(function ()
        MySQL.Async.fetchAll(
            'SELECT alliances FROM `zone-system` WHERE name = @zone', {['@zone'] = zone},
            function(result)
                    currentAlliances = json.decode(result[1].alliances)
                    
                    for i, alliance in ipairs(currentAlliances) do
                        if alliance == allianceToRemove then
                            table.remove(currentAlliances, i)
                            break
                        end
                    end

                    updatedAlliances = json.encode(currentAlliances)

            MySQL.Async.execute('UPDATE `zone-system` SET alliances = @alliances WHERE name = @zone', {['@alliances'] = updatedAlliances, ['@zone'] = zone})
        end)
    end)
end)
