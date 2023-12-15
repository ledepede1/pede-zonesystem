RegisterCommand(Config.ZoneMenuCommand, function()
    local hasJob = false

    if Config.UseAllowedGangs then
        for _, v in ipairs(Config.AllowedGangs) do
            if ESX.PlayerData.job.name == v then
                hasJob = true
                break
            end
        end
        if hasJob == true then
            ZoneMenu()
        end
    else
        ZoneMenu()
    end
end, false)
