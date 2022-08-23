NDCore = exports["ND_Core"]:GetCoreObject()

RegisterServerEvent('FoodDelivery:success')
AddEventHandler('FoodDelivery:success', function(pay)
    local player = source
    NDCore.Functions.AddMoney(pay, player, "cash")
end)

RegisterServerEvent("FoodDelivery:penalty")
AddEventHandler("FoodDelivery:penalty", function(money)
    local player = source
    NDCore.Functions.DeductMoney(money, player, "cash")
end)