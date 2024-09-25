lib.locale()

ESX = exports["es_extended"]:getSharedObject()

exports('businesscard', function(data, slot)
    local jsonData = json.encode(data)

    if slot.metadata then
        local frontImage = slot.metadata.frontImage  
        local backImage = slot.metadata.backImage 
        
        SendNUIMessage({
            action = 'show',
            frontImage = frontImage,
            backImage = backImage
        })
        SetNuiFocus(true, true)
    else
        
    end
end)

exports.ox_target:addBoxZone({
    coords = Config.Ped.PedCoords,
    size = vector3(1.0, 1.0, 1.0),
    options = {
        {
            label = locale('order_business_card'), 
            icon = 'fa-solid fa-address-card',
            distance = 1,
            onSelect = function()
                local input = lib.inputDialog(locale('order_business_card_title'), { 
                    { type = 'input', label = locale('front'), description = locale('front_image_description'), required = true, min = 1, max = 100 }, 
                    { type = 'input', label = locale('back'), description = locale('back_image_description'), required = true, min = 1, max = 100 }, 
                    { type = 'number', label = locale('number_of_cards'), description = locale('card_quantity_description'), icon = 'address-card' }, 
                })

                if input then
                    local frontImage = input[1]
                    local backImage = input[2]
                    local amount = tonumber(input[3])

                    if not string.match(frontImage, 'r2.fivemanage.com') or not string.match(backImage, 'r2.fivemanage.com') then
                        lib.notify({
                            title = locale('image_url_error'), 
                            type = 'error',
                            position = 'bottom'
                        })
                        return
                    end

                    TriggerServerEvent('ejj_businesscard:businesscardbestilling', frontImage, backImage, amount)
                end
            end
        },                        
    },
})

function ejj_businesscardlavped()
    RequestModel(Config.Ped.PedModel)
    while not HasModelLoaded(Config.Ped.PedModel) do
        Wait(1)
    end 

    ped = CreatePed(4, Config.Ped.PedModel, Config.Ped.PedCoords.x, Config.Ped.PedCoords.y, Config.Ped.PedCoords.z - 1, Config.Ped.PedHeading, false, true)
    
    SetEntityAsMissionEntity(ped, true, true)
    
    SetEntityInvincible(ped, true)
    
    FreezeEntityPosition(ped, true)
    
    SetBlockingOfNonTemporaryEvents(ped, true)
end

ejj_businesscardlavped()

RegisterNUICallback('close', function(data, cb)
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
    cb('ok')
end)