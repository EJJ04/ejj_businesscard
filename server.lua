lib.locale()

local ESX = nil
local QBCore = nil

if GetResourceState('es_extended') == 'started' then
    ESX = exports["es_extended"]:getSharedObject()
end

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('ejj_businesscard:businesscardbestilling')
AddEventHandler('ejj_businesscard:businesscardbestilling', function(frontImage, backImage, amount)
    local xPlayer = nil
    local item = 'money'  
    local cost = 250 * amount
    local moneyItem, playerSource, inventoryId = nil, nil, nil

    if ESX then
        xPlayer = ESX.GetPlayerFromId(source)
        playerSource = xPlayer.source
        inventoryId = playerSource
        moneyItem = xPlayer.getInventoryItem(item)
    elseif QBCore then
        xPlayer = QBCore.Functions.GetPlayer(source)
        playerSource = xPlayer.PlayerData.source
        inventoryId = playerSource
        moneyItem = xPlayer.Functions.GetItemByName(item)
    end

    if moneyItem and moneyItem.count >= cost then
        if ESX then
            xPlayer.removeInventoryItem(item, cost)
        elseif QBCore then
            xPlayer.Functions.RemoveItem(item, cost)
        end

        local item = 'businesscard' 
        local count = amount
        local ox_inventory = exports.ox_inventory

        local metadata = {
            frontImage = frontImage,
            backImage = backImage,
        }

        exports.ox_inventory:AddItem(inventoryId, item, count, metadata, nil, function(success, response)
            if success then
                local slot = ox_inventory:GetSlotForItem(inventoryId, item, nil)
                ox_inventory:SetMetadata(inventoryId, slot, metadata)

                local notificationData = {
                    title = string.format(locale('order_success'), amount, cost),
                    type = 'success',
                    position = 'bottom'
                }
                TriggerClientEvent('ox_lib:notify', playerSource, notificationData)
            else
                print('Failed to add item. Response: ' .. response)
            end
        end)
    else
        local notificationData = {
            title = locale('not_enough_money'), 
            description = string.format(locale('not_enough_money_description'), amount), 
            type = 'error',
            position = 'bottom'
        }
        TriggerClientEvent('ox_lib:notify', playerSource, notificationData)
    end
end)