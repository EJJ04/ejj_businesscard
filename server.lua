ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('ejj_businesscard:businesscardbestilling')
AddEventHandler('ejj_businesscard:businesscardbestilling', function(frontImage, backImage, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = 'money'  

    local cost = 250 * amount

    local moneyItem = xPlayer.getInventoryItem(item)

    if moneyItem.count >= cost then

        xPlayer.removeInventoryItem(item, cost)

        local inventoryId = xPlayer.source
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
                TriggerClientEvent('ox_lib:notify', xPlayer.source, notificationData)

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
        TriggerClientEvent('ox_lib:notify', xPlayer.source, notificationData)
    end
end)