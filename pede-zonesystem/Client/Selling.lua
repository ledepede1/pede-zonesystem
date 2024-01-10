local interactingNPCs = {}

local attachedProp = nil

function AttachPropToPlayer(propModel)
    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed))

    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(500)
    end

    local prop = CreateObject(GetHashKey(propModel), x, y, z, true, false, false)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.12, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
    attachedProp = prop
    Wait(500)
    SetModelAsNoLongerNeeded(propModel)
end

function RemoveAttachedProp()
    if attachedProp then
        DeleteEntity(attachedProp)
        attachedProp = nil
    end
end

function IsEntityAnAnimal(entity)
    local model = GetEntityModel(entity)
    local modelName = GetHashKey(model)
    for _, animalModel in ipairs(Config.BlockedPeds) do
        if GetHashKey(animalModel) == modelName then
            return true
        end
    end
    return false
end

HasItem = false
Emote = "hei_prop_pill_bag_01"
Item = nil
Amount = nil

RegisterNetEvent("check:players:items:client")
AddEventHandler("check:players:items:client", function (bool, emote, item, amount)
    Emote = emote
    Item = item
    Amount = amount

    if bool == true then
        HasItem = true
    else
        HasItem = false
    end  
end)

Points = 0

RegisterNetEvent("Get:Zone:Points")
AddEventHandler("Get:Zone:Points", function (points)
    Points = points
end)

local isAlliance = nil
AlliancesString = nil
AlliancesListMenu = {}

RegisterNetEvent("get:alliances:client")
AddEventHandler("get:alliances:client", function (alliances, name)
        if alliances ~= nil then
        for _, job in ipairs(alliances) do
            
            table.insert(AlliancesListMenu, {
                title = job,
                onSelect = function()
                    local confirmDelete = lib.alertDialog({
                        header = job..Config.Menus.OwnedZonesMenu.deleteAllianceFromZone.title..name,
                        centered = true,
                        cancel = true
                    })
                    
                    if confirmDelete == nil then return end
                    if confirmDelete == "confirm" then
                    TriggerServerEvent("remove:zone:alliance", name, job)
                    end
                end,
            })

            if job == ESX.PlayerData.job.name then
                isAlliance = true
            end
        end
    end

    if not isAlliance then
        isAlliance = false
    end
end)

function InteractWithNPC(npc)
    local cancled = false

    if not IsPedInAnyVehicle(npc, true) then
    if not IsPedDeadOrDying(npc, true) then


    TriggerServerEvent("check:players:items")
    TriggerServerEvent("get:zone:coords")

    Citizen.Wait(100)
    if not DoesEntityExist(npc) then
        return
    end

    if IsEntityAnAnimal(npc) then
        return
    end
 
    if not interactingNPCs[npc] then
    if HasItem then
	if math.random(Config.CallPoliceChance.chanceMin, Config.CallPoliceChance.chanceMax) == Config.CallPoliceChance.callat then
        TriggerServerEvent("call:police:zonesystem")

            lib.notify({
                title = Locales[Config.Language]['npc:dontwant'].title,
                description = Locales[Config.Language]['npc:dontwant'].desc,
                type = "error"
            })

            cancled = true
            interactingNPCs[npc] = true
        end
        
    if cancled == false then
        TriggerServerEvent("Get:Points:Zone", CheckPlayerZones(GetEntityCoords(GetPlayerPed(-1))))

        interactingNPCs[npc] = true
        AttachPropToPlayer(Emote)

        RequestAnimDict("mp_common")
        while not HasAnimDictLoaded("mp_common") do
            Wait(100)
        end

        FreezeEntityPosition(GetPlayerPed(-1), true)

        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        TaskGoToCoordAnyMeans(npc, playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 0, 0, 0)

        TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        TaskPlayAnim(npc, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(2000)

        ClearPedTasksImmediately(GetPlayerPed(-1))
        ClearPedTasksImmediately(npc)

        FreezeEntityPosition(GetPlayerPed(-1), false)
        FreezeEntityPosition(npc, false)

        RemoveAttachedProp()
        
        
                local zoneName = nil
                while zoneName == nil do
                    Citizen.Wait(10)
                    zoneName = CheckPlayerZones(playerCoords)
                end

                if zoneName ~= Locales[Config.Language].noZone then

                TriggerServerEvent("get:zone:alliances", zoneName)
                while isAlliance == nil do
                    Citizen.Wait(10)
                end
            
                local points = math.random(Config.MinPoints, Config.MaxPoints)
    
                TriggerServerEvent("get:allowned:zones:server", ESX.PlayerData.job.name)
            
                while OwnedZones == nil do
                    Citizen.Wait(100)
                end
    
                local isZoneOwned = false
                for _, v in pairs(OwnedZones) do
                    if zoneName == v.name then
                        isZoneOwned = true
                        break
                    end
                end
    
                if not isZoneOwned and isAlliance == false then
                    TriggerServerEvent("give:reward", Item, Amount)
                else
                    if Config.MinPolice == 0 or POLICECOUNT >= Config.MinPolice then
                        TriggerServerEvent("update:points:zone", points, zoneName)
            
                        while Points == nil do
                            Citizen.Wait(20)
                        end
                        TriggerServerEvent("give:reward:zone", Points, Item, Amount)
            
                        lib.notify({
                            title = 'Zone system',
                            description = zoneName..' modtog, '..points..' points!',
                            type = 'inform'
                        })
                    else
                        lib.notify({
                            title = 'Zone system',
                            description = "Ingen point optjent da der ikke er nok betjente på arbejde!",
                            type = 'inform'
                        })
                        TriggerServerEvent("give:reward", Item, Amount)
                    end
                end
            else
                TriggerServerEvent("give:reward", Item, Amount)
            end
        end
    
                OwnedZones = nil
                isAlliance = nil
    
                    for otherNPC, _ in pairs(interactingNPCs) do
                        if otherNPC ~= npc then
                            interactingNPCs[otherNPC] = false
                            cancled = false
                        end
                    end
                end
            end
        end
    end
end

local InteractDistance = Config.InteractDistance
local InteractKey = Config.InteractKey

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15)

        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)

        local distance = InteractDistance
        local npcs = GetNearbyNPCs(coords, distance)

        for _, npc in ipairs(npcs) do
            if not interactingNPCs[npc] and IsControlJustReleased(0, InteractKey) then
                InteractWithNPC(npc)
            end
        end
    end
end)

function GetNearbyNPCs(coords, radius)
    local npcs = {}
    local pedEnum, ped = FindFirstPed()

    repeat
        local pedCoords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, pedCoords, true)

        if distance <= radius and not IsPedAPlayer(ped) and not IsEntityDead(ped) then
            table.insert(npcs, ped)
        end

        success, ped = FindNextPed(pedEnum)
    until not success

    EndFindPed(pedEnum)
    return npcs
end