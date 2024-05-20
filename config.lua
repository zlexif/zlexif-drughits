Config = {}

Config.DrugHitNPC = {
    coords = vector3(742.21, 1312.73, 359.1), 
    heading = 132.77,
    model = 'a_m_m_business_01', -- NPC model
    animation = 'WORLD_HUMAN_SMOKING' -- NPC animation
}
Config.CrateSpawnLocations = {
    {
        crateCoords = { x = 2391.04, y = 3297.9, z = 47.55 },
        npcs = {
            { coords = { x = 2376.09, y = 3286.04, z =  47.3 }, model = 'g_m_y_ballasout_01', weapon = 'WEAPON_PISTOL' },
            { coords = { x = 2411.11, y = 3278.33, z =  51.82 }, model = 'g_m_y_ballasout_01', weapon = 'WEAPON_SNIPERRIFLE' },
            { coords = { x = 2380.81, y = 3296.79, z =  47.65 }, model = 'g_m_y_ballasout_01', weapon = 'WEAPON_HEAVYRIFLE' },
            -- Add more NPCs as needed for this location
        }
    },
    {
        crateCoords = { x = 1457.97, y = 1111.58, z = 114.33 },
        npcs = {
            { coords = { x = 1480.84, y = 1117.24, z = 114.33 }, model = 'cs_manuel', weapon = 'WEAPON_SNIPERRIFLE' },
            { coords = { x = 1486.86, y = 1131.3, z = 114.34 }, model = 'cs_manuel', weapon = 'WEAPON_HEAVYRIFLE' },
            { coords = { x = 1486.92, y = 1128.34, z = 114.34 }, model = 'cs_manuel', weapon = 'WEAPON_HEAVYRIFLE' },
            { coords = { x = 1463.63, y = 1133.7, z = 114.32 }, model = 'cs_martinmadrazo', weapon = 'WEAPON_HEAVYRIFLE' },
            { coords = { x = 1486.7, y = 1123.99, z = 114.33 }, model = 'g_m_y_salvagoon_01', weapon = 'WEAPON_HEAVYRIFLE' },
            { coords = { x = 1442.63, y = 1101.94, z = 114.31 }, model = 'g_m_y_famdnf_01', weapon = 'WEAPON_CARBINERIFLE' },
            { coords = { x = 1476.76, y = 1100.29, z = 114.33 }, model = 'g_m_y_ballasout_01', weapon = 'WEAPON_PISTOL' },
            { coords = { x = 1452.3, y = 1087.82, z = 114.85 }, model = 'g_m_y_ballasout_01', weapon = 'WEAPON_SNIPERRIFLE' },
            { coords = { x = 1484.24, y = 1095.23, z = 114.33 }, model = 'g_m_y_ballasout_01', weapon = 'WEAPON_PISTOL' },
            { coords = { x = 1476.73, y = 1123.27, z = 114.33 }, model = 'g_m_y_mexgoon_01', weapon = 'WEAPON_PISTOL' },
            { coords = { x = 1450.39, y = 1112.46, z = 114.33 }, model = 'g_m_y_mexgoon_01', weapon = 'WEAPON_PISTOL' },
            { coords = { x = 1426.33, y = 1113.11, z = 114.42 }, model = 'g_m_y_mexgoon_01', weapon = 'WEAPON_PISTOL' },
            -- Add more NPCs as needed for this location
        }
    },
    -- Add more crate locations with NPCS likewise
}

-- Mission timer configuration ( time in milliseconds )
Config.MissionTimer = 60000  -- Example : 1 minute

-- fee to start the job
Config.EnableCashDeduction = false -- set to false to disable cash deduction
Config.JobStartFee = 500 
Config.DrugPackageItem = 'drug_package'  -- the item that will be given upon collecting the package

-- reward for completing the job
Config.Reward = {
    item = 'markedbills', 
    amount = 1           
}
