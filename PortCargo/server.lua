NDCore = exports["ND_Core"]:GetCoreObject()

RegisterServerEvent('PortCargo:GiveReward')
AddEventHandler('PortCargo:GiveReward', function(pay)
    local player = source
    NDCore.Functions.AddMoney(pay, player, "bank")
end)