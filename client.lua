local ESX = nil
local Enabled = false

if Config.ESX then
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
end

if Config.ESX then
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        if Enabled and job.name ~= 'police' and job.name ~= 'offpolice' then
            SendNUIMessage({ ['action'] = "close" })
        end

        TriggerServerEvent("nv:officers:refresh")
    end)
end

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

--Chat Suggestions
Citizen.CreateThread(function()
    if Config.ESX then
        TriggerEvent('chat:addSuggestion', '/plist', 'Toggle or Drag Officer list', {{name = "Drag", help = "Don't enter to toggle or enter 0 to drag"}})
        TriggerEvent('chat:addSuggestion', '/callsign', 'Update your callsign', {{name = "New Callsign", help = "The new callsign to change to"}})
    else
        TriggerEvent('chat:addSuggestion', '/plist', 'Toggle or Drag Officer list', {{name = "Drag", help = "Don't enter to toggle or enter 0 to drag"}})
        if Config.UseRankStandalone then
            TriggerEvent('chat:addSuggestion', '/callsign', 'Update your callsign and/or name', {{name = "New Callsign", help = "The new callsign to change to"}, {name = "First Name", help = "The first name to display on the list"}, {name = "Last Name", help = "The last name/initial to display on the list"}, {name = "rank", help = "The rank to display on the list"}})
        else
            TriggerEvent('chat:addSuggestion', '/callsign', 'Update your callsign and/or name', {{name = "New Callsign", help = "The new callsign to change to"}, {name = "First Name", help = "The first name to display on the list"}, {name = "Last Name", help = "The last name/initial to display on the list"}})
        end
    end
end)
