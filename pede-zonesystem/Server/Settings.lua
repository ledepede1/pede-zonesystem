function GetPlayerCFXID(player)
    local value = -1
    for _,v in pairs(GetPlayerIdentifiers(player)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            value = v
            return value
        end
    end
    return value
end

RegisterNetEvent("playerSpawn:Zone:System") 
AddEventHandler("playerSpawn:Zone:System", function ()
    local source = source
    local license = GetPlayerCFXID(source)
    local list = MySQL.Sync.fetchAll('SELECT * FROM `zone-settings` WHERE `fivem-license` = ?', {
        license
    })
    if not list[1] then
        MySQL.Sync.execute("INSERT INTO `zone-settings` (`fivem-license`, `zone-blips`) VALUES (@license, @blips)",
        {
            ['@license'] = license,
            ['@blips'] = 0
        })
    end 
end)

RegisterNetEvent("save:zone:blips")
AddEventHandler("save:zone:blips", function(enabled)
    local source = source
    local enabledInt = nil

    if enabled == true then
        enabledInt = 1
    else
        enabledInt = 0
    end

    MySQL.Sync.execute("UPDATE `zone-settings` SET `zone-blips`=@enabled WHERE `fivem-license`=@license",
	{
        ['@license'] = GetPlayerCFXID(source),
		['@enabled'] = enabledInt,
	})
end)

RegisterServerEvent("fetchPlayerSettings")
AddEventHandler("fetchPlayerSettings", function()
    local source = source
    MySQL.Async.fetchAll('SELECT `zone-blips` FROM `zone-settings` WHERE `fivem-license`=@license', {
        ['@license'] = GetPlayerCFXID(source)
    },
    function(result)
        TriggerClientEvent("ReturnToClient", source, result[1]['zone-blips'])
    end)
end)
