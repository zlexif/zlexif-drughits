local QBCore = exports['qb-core']:GetCoreObject()
local isMissionActive = false
local hasDrugPackage = false
local boxProp = nil
local crateProps = {}
local crateBlip = nil  

function spawnDrugHitNPC()
    local npc = Config.DrugHitNPC
    RequestModel(npc.model)
    while not HasModelLoaded(npc.model) do
        Wait(1)
    end

    local drugHitNPC = CreatePed(1, npc.model, npc.coords.x, npc.coords.y, npc.coords.z, npc.heading, false, true)
    SetPedCanPlayAmbientAnims(drugHitNPC, true)
    SetBlockingOfNonTemporaryEvents(drugHitNPC, true)
    SetEntityInvincible(drugHitNPC, true)
    FreezeEntityPosition(drugHitNPC, true)    
    TaskStartScenarioInPlace(drugHitNPC, npc.animation, 0, true)
    SetPedCombatAttributes(drugHitNPC, 46, true)
    SetPedFleeAttributes(drugHitNPC, 0, false)

    exports['qb-target']:AddTargetEntity(drugHitNPC, {
        options = {
            {
                event = "zlexif-drughits:startMission",
                icon = "fas fa-crosshairs",
                label = "Speak To Berry",
                canInteract = function()
                    return not isMissionActive
                end,
            },
            {
                event = "zlexif-drughits:completeMission",
                icon = "fas fa-gift",
                label = "Complete Mission",
                canInteract = function()
                    return hasDrugPackage
                end,
            },
        },
        distance = 2.5
    })
end

function startDrugHit()
    if isMissionActive then
        QBCore.Functions.Notify("You already have an active mission.", "error", 5000)
        return
    end

    local randomIndex = math.random(#Config.CrateSpawnLocations)
    local selectedLocation = Config.CrateSpawnLocations[randomIndex]

    isMissionActive = true
    spawnCrateProp(selectedLocation.crateCoords)
    spawnNPCs(selectedLocation.npcs)
    createCrateBlip(selectedLocation.crateCoords)

    local endTime = GetGameTimer() + Config.MissionTimer
    local timerId = "drugHitTimer"

    Citizen.CreateThread(function()
        while GetGameTimer() < endTime and isMissionActive do
            local remaining = math.floor((endTime - GetGameTimer()) / 1000)
            exports['qb-core']:DrawText("Time remaining: " .. remaining .. " seconds", timerId)

            Citizen.Wait(1000)  

            if GetGameTimer() >= endTime then
                QBCore.Functions.Notify("Mission failed: Time's up!", "error", 5000)
                resetMission()
                exports['qb-core']:HideText(timerId)
                resetMission()
                return
            end
        end
        exports['qb-core']:HideText(timerId)
    end)
end

function spawnNPCs(npcConfigs)
    for _, npcConfig in pairs(npcConfigs) do
        RequestModel(GetHashKey(npcConfig.model))
        while not HasModelLoaded(GetHashKey(npcConfig.model)) do
            Wait(1)
        end

        local npcPed = CreatePed(1, GetHashKey(npcConfig.model), npcConfig.coords.x, npcConfig.coords.y, npcConfig.coords.z, 0.0, false, true)
        SetPedCanPlayAmbientAnims(npcPed, true)
        SetBlockingOfNonTemporaryEvents(npcPed, true)
        GiveWeaponToPed(npcPed, GetHashKey(npcConfig.weapon), 255, true, true)

        SetPedFleeAttributes(npcPed, 0, false)
        SetPedAsEnemy(npcPed, true)
        TaskCombatPed(npcPed, PlayerPedId(), 0, 16)

    end
end

function spawnCrateProp(crateCoords)
    local crateModel = GetHashKey('ex_prop_crate_closed_bc')

    RequestModel(crateModel)
    while not HasModelLoaded(crateModel) do
        Wait(1)
    end

    local crateProp = CreateObject(crateModel, crateCoords.x, crateCoords.y, crateCoords.z, true, true, true)
    PlaceObjectOnGroundProperly(crateProp)
    table.insert(crateProps, crateProp)


    exports['qb-target']:AddTargetModel(crateModel, {
        options = {
            {
                event = "zlexif-drughits:collectDrugPackage",
                icon = "fas fa-box",
                label = "Collect Drug Package",
            }
        },
        distance = 2.5
    })
end
function createCrateBlip(coords)
    if crateBlip then  
        RemoveBlip(crateBlip)
    end

    crateBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(crateBlip, 501)  
    SetBlipColour(crateBlip, 1)   
    SetBlipScale(crateBlip, 0.8)  
    SetBlipAsShortRange(crateBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Drug Package") 
    EndTextCommandSetBlipName(crateBlip)
end

RegisterNetEvent('zlexif-drughits:collectDrugPackage', function()
    if hasDrugPackage then
        QBCore.Functions.Notify("You already have the drug package.", "error", 5000)
        return
    end


    QBCore.Functions.Progressbar("collect_drug_package", "Collecting Drug Package...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "pickup_object",
        anim = "pickup_low",
        flags = 48,
    }, {}, {}, function() -- On Done
        collectDrugPackage()
    end, function() -- On Cancel
        QBCore.Functions.Notify("Cancelled", "error")
    end)
end)

function collectDrugPackage()
    QBCore.Functions.Notify("You have collected the drug package.", "success", 5000)
    TriggerServerEvent('zlexif-drughits:giveDrugPackageItem')
    hasDrugPackage = true
end

Citizen.CreateThread(function()
    while true do
        Wait(1000) 
        local hasDrugPackage = QBCore.Functions.HasItem(Config.DrugPackageItem)
        manageBoxProp(hasDrugPackage)
    end
end)

local isHoldingBox = false

function manageBoxProp(hasDrugPackage)
    local playerPed = PlayerPedId()
    if hasDrugPackage and not isHoldingBox then
        RequestAnimDict("anim@heists@box_carry@")
        while not HasAnimDictLoaded("anim@heists@box_carry@") do
            Wait(10)
        end
        TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 50, 0, false, false, false)

        boxProp = CreateObject(GetHashKey('prop_cs_cardbox_01'), 0, 0, 0, true, true, true)
        AttachEntityToEntity(boxProp, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

        isHoldingBox = true
    elseif not hasDrugPackage and isHoldingBox then
        ClearPedTasks(playerPed)

        if DoesEntityExist(boxProp) then
            DeleteObject(boxProp)
            boxProp = nil
        end

        isHoldingBox = false
    end
end
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isHoldingBox then
            local playerPed = PlayerPedId()
            
            local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
            if vehicle and vehicle ~= 0 then
                DisableControlAction(0, 23, true) 
               if GetVehicleDoorLockStatus(vehicle) ~= 2 then
                    ClearPedTasks(playerPed)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if boxProp then
            local playerPed = PlayerPedId()
            if IsPedRunning(playerPed) then
                SetPedToRagdoll(playerPed, 1000, 1000, 0, false, false, false)  
            end
        end
    end
end)
RegisterNetEvent('zlexif-drughits:startMission', function()
    if Config.EnableCashDeduction then
        local playerData = QBCore.Functions.GetPlayerData()
        if playerData.money.cash >= Config.JobStartFee then
            TriggerServerEvent('removedamoneyyy:Server:RemoveMoney', 'cash', Config.JobStartFee)
            startDrugHit()
        else
            QBCore.Functions.Notify("Not enough cash to start the job.", "error")
        end
    else
        startDrugHit()
    end
end)


RegisterNetEvent('zlexif-drughits:completeMission', function()
    Citizen.CreateThread(function()
        local hasDrugPackage = QBCore.Functions.HasItem(Config.DrugPackageItem)
        if not hasDrugPackage then
            QBCore.Functions.Notify("You need to collect the drug package first.", "error", 5000)
            return
        end

        TriggerServerEvent('zlexif-drughits:removeDrugPackageItem')

        despawnNearbyCrates(1000)  
        resetMission()
    end)
end)

function removeCrateBlip()
    if crateBlip then
        RemoveBlip(crateBlip)
        crateBlip = nil
    end
end

function resetMission()
    isMissionActive = false
    if boxProp then
        DeleteObject(boxProp)
        boxProp = nil
    end
    if hasDrugPackage then
        TriggerServerEvent('zlexif-drughits:removeDrugPackageItem')
        hasDrugPackage = false
    end
    removeCrateBlip()
end

function despawnNearbyCrates(radius)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local crateModel = GetHashKey('ex_prop_crate_closed_bc')
    local objects = GetGamePool('CObject')
    local despawnedCrates = 0

    for _, obj in ipairs(objects) do
        if DoesEntityExist(obj) and GetEntityModel(obj) == crateModel then
            local objCoords = GetEntityCoords(obj)
            local distance = #(playerCoords - objCoords)
            if distance < radius then
                DeleteObject(obj)
                despawnedCrates = despawnedCrates + 1
            end
        end
    end

    print("Despawned " .. despawnedCrates .. " crates.") -- debug print if the crates fuck up and dont despawn.
end

function removeBoxProp()
    if DoesEntityExist(boxProp) then
        DetachEntity(boxProp, true, true)
        DeleteObject(boxProp)
        boxProp = nil
    end
end

Citizen.CreateThread(function()
    spawnDrugHitNPC()
end)