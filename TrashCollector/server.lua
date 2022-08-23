NDCore = exports["ND_Core"]:GetCoreObject()

RegisterServerEvent('TrashCollector:GiveReward')
AddEventHandler('TrashCollector:GiveReward', function(pay)
	local player = source 
	NDCore.Functions.AddMoney(pay, player, "bank")
end)