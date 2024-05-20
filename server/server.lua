local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('zlexif-drughits:giveReward')
AddEventHandler('zlexif-drughits:giveReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        local rewardItem = Config.Reward.item
        local amount = Config.Reward.amount

        if Player.Functions.AddItem(rewardItem, amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[rewardItem], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Mission completed, reward received!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Not enough space for the reward!', 'error')
        end
    end
end)
RegisterNetEvent('removedamoneyyy:Server:RemoveMoney')
AddEventHandler('removedamoneyyy:Server:RemoveMoney', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player and type == 'cash' and amount > 0 then
        Player.Functions.RemoveMoney(type, amount)
    end
end)

RegisterNetEvent('zlexif-drughits:giveDrugPackageItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        local drugPackageItem = Config.DrugPackageItem  
        Player.Functions.AddItem(drugPackageItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[drugPackageItem], "add")
        TriggerClientEvent('QBCore:Notify', src, "You have received a drug package.", "success")
    end
end)

RegisterNetEvent('zlexif-drughits:removeDrugPackageItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.RemoveItem(Config.DrugPackageItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.DrugPackageItem], "remove")
    end
end)
