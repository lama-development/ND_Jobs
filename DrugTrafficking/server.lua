NDCore = exports["ND_Core"]:GetCoreObject()

RegisterServerEvent('DrugTrafficking:GiveReward')
AddEventHandler('DrugTrafficking:GiveReward', function(price)
	local player = source 
	NDCore.Functions.AddMoney(price, player, "cash")
end)