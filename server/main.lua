local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPclient = Tunnel.getInterface("vRP", "sut") 
vRP = Proxy.getInterface("vRP")

HT = nil

TriggerEvent('HT_base:getBaseObjects', function(obj) 
    HT = obj 
end)

RegisterNetEvent('99kr-shops:Cashier')
AddEventHandler('99kr-shops:Cashier', function(price, basket, account)
    local src = source
    local xPlayer = vRP.getUserId({src})

    if account == "cash" then
        vRP.tryGetInventoryItem({xPlayer,"phone",price,true})
    else
        vRP.tryFullPayment({xPlayer,price})
    end
    
    for i=1, #basket do
        vRP.giveInventoryItem({xPlayer,basket[i]["value"],basket[i]["amount"],true})
    end
    pNotify('You bought products for <span style="color: green">$' .. price .. '</span>', 'success', 3000)
end)

HT.RegisterServerCallback('99kr-shops:CheckMoney', function(source, cb, price, account)
    local src = source
    local xPlayer = vRP.getUserId({src})
    local money
    if account == "cash" then
        money = vRP.getMoney({xPlayer})
    else
        money = vRP.getMoney({xPlayer})
    end

    if money >= price then
        cb(true)
    end
    cb(false)
end)

pNotify = function(message, messageType, messageTimeout)
	TriggerClientEvent("pNotify:SendNotification", source, {
		text = message,
		type = messageType,
		queue = "shop_sv",
		timeout = messageTimeout,
		layout = "topRight"
	})
end