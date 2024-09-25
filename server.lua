lib.locale()

RegisterNetEvent('ejj_businesscard:businesscardbestilling')
AddEventHandler('ejj_businesscard:businesscardbestilling', function(frontImage, backImage, amount)
    local playerSource = source
    local item = 'money'
    local cost = 250 * amount
    local inventoryId = playerSource
    local ox_inventory = exports.ox_inventory

    local moneyItem = ox_inventory:GetItem(inventoryId, item)
    
    if moneyItem and moneyItem.count >= cost then

        ox_inventory:RemoveItem(inventoryId, item, cost)

        local cardItem = 'businesscard'
        local count = amount

        local metadata = {
            frontImage = frontImage,
            backImage = backImage,
        }

        ox_inventory:AddItem(inventoryId, cardItem, count, metadata, nil, function(success, response)
            if success then
                local slot = ox_inventory:GetSlotForItem(inventoryId, cardItem, nil)
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