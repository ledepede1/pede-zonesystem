if not Locales then
    Locales = {}
end

Locales['dk'] = {
    noZone = "Ingen zone",

    ['police:called'] = {
        notifyDesc = "En person prøvede at sælge ~r~narkotika ~w~på ~r~"
    },
    ['npc:dontwant'] = {
        title = "Salg",
        desc = "Personen ringede til politiet!"
    },

    ['reward'] = {
        title = "Salg",
        desc = "Du modtog ",
    },

    ["currentzone"] = {
        ['notify'] = {
                title = "Zone System",
                desc = "Du befinder dig i zonen: ",
            }
        },
        ["changeZoneOwner"] = {
            ["errNotify"] = {
                title = "Zone System",
                desc = "Ingen spillere i nærheden",
            },
        },
        ["zonelist"] = {
        ['metadata:zoneowner'] = 'Ejer',
        ['metadata:zonepoints'] = 'Points',
    },
}