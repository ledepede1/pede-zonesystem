vectorList = {}

RegisterNetEvent("zones:list")
AddEventHandler("zones:list", function(zones)
    vectorList = {} -- Clear the previous contents
    for _, v in pairs(zones) do
        local x, y, z = string.match(v.coords, "([^,]+),([^,]+),([^,]+)")
        local coords = vector3(tonumber(x), tonumber(y), tonumber(z))

        table.insert(vectorList, {
            name = v.name,
            coords = coords,
            radius = Config.ZoneRadius
        })
    end
end)

function IsPlayerInRadius(playerCoords, targetCoords, radius)
    local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z)
    return distance <= radius
end

-- Function to check which zone the player is in
function CheckPlayerZones(playerCoords)
    for _, zone in ipairs(vectorList) do
        local distanceSquared = Vdist2(playerCoords.x, playerCoords.y, playerCoords.z, zone.coords.x, zone.coords.y, zone.coords.z)
        if distanceSquared <= (zone.radius * zone.radius) then
            return zone.name
        else
            return Locales[Config.Language].noZone
        end
    end
end