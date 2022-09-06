local JobStarted = false
local pay = 0
local bliplocation = vector3(2196.65, 5609.89, 53.56)
local blip = AddBlipForCoord(bliplocation.x, bliplocation.y, bliplocation.z)

SetBlipSprite(blip, 457)
SetBlipDisplay(blip, 4)
SetBlipColour(blip, 21)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Drug Trafficking Job")
EndTextCommandSetBlipName(blip)

function NewBlip()
    local objectif = math.randomchoice(Config.Positions)
    local ped = GetPlayerPed(-1)

    local blip = AddBlipForCoord(objectif.x, objectif.y, objectif.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 2)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 2)

    local coords = GetEntityCoords(ped)
    local distance = Vdist2(coords, objectif.x, objectif.y, objectif.z)

    while true do
        local opti = 5000
        coords = GetEntityCoords(ped)
        distance = Vdist2(coords, objectif.x, objectif.y, objectif.z)
        AddTextEntry("press_collect_drugs2", 'Press ~INPUT_CONTEXT~ to deliver the drugs')
        if distance <= 50 then
            opti = 1000
            if distance <= 10 then
                opti = 2
                DisplayHelpTextThisFrame("press_collect_drugs2")
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("DrugTrafficking:DrugsDelivered", objectif)
                    pay = pay + Config.Pay
                    RemoveBlip(blip)
                    ChoiceNotif()
                    break
                end
            end
        end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
            drawnotifcolor("Bring back the van.", 25)
            StopService()
            break
        end
        Wait(opti)
    end
end

function ChoiceNotif()
    drawnotifcolor("Press ~g~E~w~ for more drug deliveries.\nPress ~r~X~w~ if you want to stop the job", 140)

    local timer = 1500
    while timer >= 1 do
        Wait(10)
        timer = timer - 1

        if IsControlJustPressed(1, 38) then
            NewChoice()
            break
        end

        if IsControlJustPressed(1, 73) then
            drawnotifcolor("Bring back the van.", 25)
            StopService()
            break
        end

        if timer == 1 then
            drawnotifcolor("You took too much time! The deal is off, bring back the drugs.", 208)
            StopService()
            break
        end

    end
end

function NewChoice()
    local route = math.randomchoice(Config.Positions)
    local ped = GetPlayerPed(-1)

    local blip = AddBlipForCoord(route.x, route.y, route.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 3)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)

    drawnotifcolor("New location is set, press ~r~X~w~ if you want to stop the job.", 140)
    local coords = GetEntityCoords(ped)
    local distance = Vdist2(coords, route.x, route.y, route.z)

    while true do
        local opti = 5000
        coords = GetEntityCoords(ped)
        distance = Vdist2(coords, route.x, route.y, route.z)
        AddTextEntry("press_collect_drugs", 'Press ~INPUT_CONTEXT~ to collect the drugs')
        if distance <= 60 then
            opti = 1000
            if distance <= 10 then
                opti = 2
                DisplayHelpTextThisFrame("press_collect_drugs")
                if IsControlJustPressed(1, 38) then
                    RemoveBlip(blip)
                    NewBlip()
                    break
                end
            end
        end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
            drawnotifcolor("Bring back the van to get the money.", 140)
            StopService()
            break
        end
        Wait(opti)
    end
end

function StopService()
    local coordsEndService = Config.StartingPosition
    local ped = GetPlayerPed(-1)
    AddTextEntry("press_ranger_ha420", 'Press ~INPUT_CONTEXT~ to return the van and get the money.')

    local blip = AddBlipForCoord(coordsEndService)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)

    while true do
        local opti = 5000
        local coords = GetEntityCoords(ped)
        local distance = Vdist2(coordsEndService, coords)
        if distance <= 50 then
            opti = 1000
            if distance <= 10 then
                opti = 2
                DisplayHelpTextThisFrame("press_ranger_ha420")
                if IsControlJustPressed(1, 38) then
                    local playerPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if GetEntityModel(vehicle) == GetHashKey("rumpo2") then
                        DeleteEntity(vehicle)
                        TriggerServerEvent("DrugTrafficking:NeedsPayment", coordsEndService)
                        drawnotifcolor("You've received ~g~$" .. pay .. "~w~ for completing the job.", 140)
                        RemoveBlip(blip)
                        JobStarted = false
                        pay = 0
                        break
                    else
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if GetEntityModel(vehicle) ~= GetHashKey("rumpo2") then
                            drawnotifcolor("Bring back the van to get the money.", 140)
                            JobStarted = true
                            break
                        end
                    end
                end
            end
        end
        Wait(opti)
    end
end

function StartJob()
    local ped = GetPlayerPed(-1)
    local vehicleName = 'rumpo2'

    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Wait(500)
    end

    local vehicle = CreateVehicle(vehicleName, 2201.32, 5616.51, 53.78, 325.27, true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetVehicleFixed(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetModelAsNoLongerNeeded(vehicleName)
    JobStarted = true
    TriggerServerEvent("DrugTrafficking:StartedCollecting")
    NewChoice()
end

CreateThread(function()
    AddTextEntry("press_start_job", "Press ~INPUT_CONTEXT~ to start the job")
    while true do
        local opti = 5000
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local distance = Vdist2(vector3(2196.65, 5609.89, 52.4), coords)
        if distance <= 50 and not JobStarted then
            opti = 1000
            if distance <= 10 then
                opti = 2
                DrawMarker(1, 2196.65, 5609.89, 52.4, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 1.5001, 255, 255, 255, 200, 0, 0, 0, 0)
                if distance <= 2 then
                    DisplayHelpTextThisFrame("press_start_job")
                    if IsControlJustPressed(1, 38) then
                        StartJob()
                    end
                end
            end
        end
        Wait(0)
    end
end)

function drawnotifcolor(text, color)
    Citizen.InvokeNative(0x92F0DA1E27DB96DC, tonumber(color))
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end

function math.randomchoice(d)
    return d[math.random(1, #d)]
end