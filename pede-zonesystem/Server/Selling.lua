function RandomAmount()
    return math.random(Config.SellMin,Config.SellMax)
end

function RandomReward(drugtype)
    return math.random(Config.SellableItems[drugtype].minReward, Config.SellableItems[drugtype].maxReward)     
end


function math.round(num)
    return math.floor(num + 0.5)
end

RegisterNetEvent("check:players:items")
AddEventHandler("check:players:items", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasAnyItem = false
    local amount = RandomAmount()
    local item = nil
    local emote = "hei_prop_pill_bag_01"

    for _, v in pairs(Config.SellableItems) do
        if xPlayer.getInventoryItem(v.item).count > amount then
            hasAnyItem = true
            item = v.item
            if v.prop ~= nil then
            emote = v.prop
            end
            break
        end
    end
    TriggerClientEvent("check:players:items:client", source, hasAnyItem, emote, item, amount)
end)

RegisterNetEvent("give:reward:zone")
AddEventHandler("give:reward:zone", function(points, item, itemamount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local percentToTake = 0

    for i = 1, points, 1 do
        percentToTake = i / 500
        if percentToTake > Config.MaxPercent then
            break
        end
    end

    print(percentToTake)

    local reward = RandomReward(item)
    
    local ammountToAddOn = math.round(reward * (percentToTake / 100))
    
    local addedAmount = ammountToAddOn


    if addedAmount < 1 then
        addedAmount = 0
    end

    xPlayer.removeInventoryItem(item, itemamount)
    xPlayer.addAccountMoney("black_money", reward+addedAmount*itemamount)

    TriggerClientEvent("notify:zone", source, Locales[Config.Language]['reward'].title, Locales[Config.Language]['reward'].desc..reward.." + "..addedAmount.." DKK")
end)

RegisterNetEvent("give:reward")
AddEventHandler("give:reward", function(item, itemamount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = RandomReward(item)

    xPlayer.removeInventoryItem(item, itemamount)
    xPlayer.addAccountMoney("black_money", reward*itemamount)

    TriggerClientEvent("notify:zone", source, Locales[Config.Language]['reward'].title, Locales[Config.Language]['reward'].desc..reward.." DKK")
end)

RegisterNetEvent("call:police:zonesystem")
AddEventHandler("call:police:zonesystem", function ()
    TriggerClientEvent("call:police:zonesystem:client", -1)
end)

RegisterNetEvent("Get:Points:Zone")
AddEventHandler("Get:Points:Zone", function(zoneName)
    local source = source

    while zoneName == nil do
        Citizen.Wait(20)
    end

    MySQL.ready(function ()
        MySQL.Async.fetchAll(
            'SELECT points FROM `zone-system` WHERE name='.."'"..zoneName.."'",
            function(result)
                if result ~= nil then
                    if type(result) == "table" and #result > 0 then
                        local points = result[1].points
                        if points ~= nil then
                            TriggerClientEvent("Get:Zone:Points", source, points)
                        end
                    else
                        TriggerClientEvent("Get:Zone:Points", source, 0)
                    end
                end
            end
        )
    end)
end)


