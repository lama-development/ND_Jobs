NDCore = exports["ND_Core"]:GetCoreObject()

RegisterServerEvent('MailDelivery:DeliveryMade')
AddEventHandler("MailDelivery:DeliveryMade", function(payment)
    local player = source 
    -- add payment to players bank account
    NDCore.Functions.AddMoney(payment, player, "bank")
end)

RegisterServerEvent('MailDelivery:VanRented')
AddEventHandler("MailDelivery:VanRented", function(rentalAmount)
    local player = source 
    -- deduct rentalAmount from players bank account
	NDCore.Functions.DeductMoney(rentalAmount, player, "bank")
end)