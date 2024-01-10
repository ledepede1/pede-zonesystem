Config = {}

Config.Language = "dk"

Config.ZoneMenuCommand = "zonemenu" -- Command på zone menuen
Config.ZoneRadius = 500 -- Hvor stor en radius en zone gælder for

Config.SellMin = 4 -- Minimum man kan sælge af gangen
Config.SellMax = 15 -- Maksimum man kan sælge af gangen

Config.MinPoints = 3 -- Minmum points man kan få per salg
Config.MaxPoints = 12 -- Maximum points man kan få per salg

Config.MaxPercent = 30 -- Hvor mange procent af salgsprisen man kan få oven i.

Config.PoliceJob = "police" -- Politi job navnet
Config.MinPolice = 1 -- Hvor mange betjente der skal være på før at zonen modtager points. 
Config.CallPoliceChance = {
    chanceMin = 1, 
    chanceMax = 10,
    callat = 1 -- Ringer til politiet hvis det tilfældige tal er 1
}


Config.InteractDistance = 3.0 -- Hvor langt væk fra npcen man skal være for at kunne sælge
Config.InteractKey = 38 -- Hvilken knap man skal trykke på for at sælge

Config.UseAllowedGangs = true -- Hvis sat til false så vil man ikke skulle have Config.AllowedGangs job for at tilgå menuen!
Config.AllowedGangs = { -- Job navne på alle de bander som skal have adgang til at tilgå zonemenuen!
    "ballas",
    "families",
    "vagos",
}

Config.SellableItems = {
    ["marijuana"] = {
        item = "marijuana", -- item navn
        minReward = 150, -- minimums salgspris
        maxReward = 350, -- maksimums salgspris
        prop = nil -- Hvis det er nil så vil den bruge "hei_prop_pill_bag_01" som standard
    },
    ["cannabis"]= {
        item = "cannabis",  -- item navn
        minReward = 250, -- minimums salgspris
        maxReward = 550, -- maksimums salgspris
        prop = nil -- Hvis det er nil så vil den bruge "hei_prop_pill_bag_01" som standard
    },
}

Config.Menus = {
   MainMenu = {
    options = {
        ["currentzone"] = {
            title = "Nurværende zone",
            icon = "fa-solid fa-map-location-dot"
        },
        ["zonelist"] = {
            title = "Liste over zoner",
            icon = "fa-solid fa-map"
        },
        ["ownedzones"] = {
            title = "Dine zoner",
            icon = "fa-solid fa-list"
        },
        ["settings"] = {
            title = "Indstillinger",
            icon = "fa-solid fa-gear"
        },
    }
   },
   ZoneListMenu = {
    title = "Liste over zoner"
   },
   OwnedZonesMenu = {
    title = "Dine zoner",
    percent = {
        title = "Procent: ",
        colorScheme = "blue",
    },
    changeOwner = {
        title = "Overfør Ejerskab",
        metadata = "Overfør zone til nærmeste person",
        confirmDialog = {
            title = "Zone System",
            desc = "Overfør ejerskab til ",
        },
    },
    addAlliance = {
        title = " | Opret Alliance",
        gangName = "Bandenavn",
        gangNameDesc = "Job navnet på den bande som du vil oprette alliance med",
        confirm = "Godkend alliancen"
    },
    getEditAlliances = {
        title = "Se og Redigér alliancer"
    },
    deleteAllianceFromZone = {
        title = " vil blive fjernet fra zonen | "
    },
   },
}

Config.BlockedPeds = {
    "a_c_boar",
    "a_c_cat_01",
    "a_c_chickenhawk",
    "a_c_chimp",
    "a_c_chop",
    "a_c_cormorant",
    "a_c_cow",
    "a_c_coyote",
    "a_c_crow",
    "a_c_deer",
    "a_c_dolphin",
    "a_c_fish",
    "a_c_hen",
    "a_c_humpback",
    "a_c_husky",
    "a_c_killerwhale",
    "a_c_mtlion",
    "a_c_pig",
    "a_c_pigeon",
    "a_c_poodle",
    "a_c_pug",
    "a_c_rabbit_01",
    "a_c_rat",
    "a_c_retriever",
    "a_c_rhesus",
    "a_c_rottweiler",
    "a_c_seagull",
    "a_c_sharkhammer",
    "a_c_sharktiger",
    "a_c_shepherd",
    "a_c_stingray",
    "a_c_westy",
}

