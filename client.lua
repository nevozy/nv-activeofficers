local ESX = nil
local Enabled = false

CreateThread(function()
    while ESX == nil do
        Wait(1)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

    while not ESX.GetPlayerData().job do
        Wait(1)
    end

    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if Enabled and job.name ~= 'police' and job.name ~= 'offpolice' then
        SendNUIMessage({ ['action'] = "close" })
    end

    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent("nv:officers:open")
AddEventHandler("nv:officers:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ ['action'] = 'close' })
            print("close")
        else
            Enabled = true
            SendNUIMessage({ ['action'] = 'open' })
            print("open")
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ ['action'] = 'drag' })
    end
end)

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function(data)
    SendNUIMessage({ ['action'] = 'refresh', ['data'] = data })
end)

