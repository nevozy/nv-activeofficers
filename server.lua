local ESX = nil
local HTML = ""
local CallSigns = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("plist", function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice') then
        local type = "toggle"

        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("nv:officers:open", src, type)
    end
end)

RegisterCommand("callsign", function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice') and args[1] then
        CallSigns[xPlayer.getIdentifier()] = args[1]
        SaveResourceFile(GetCurrentResourceName(), "callsigns.json", json.encode(CallSigns))
    end
end)

RegisterServerEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function()
    local new = ""

    for k,v in pairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice') then
            local name = GetName(v)
            local dutyClass = xPlayer.job.name == 'police' and 'duty' or 'offduty'
            local duty = xPlayer.job.name == 'police' and 'On Duty' or 'Off Duty'
            local callSign = CallSigns[xPlayer.getIdentifier()] ~= nil and CallSigns[xPlayer.getIdentifier()] or "No Sign"
            new = new .. '<div class="officer"><span class="callsign">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.job.grade_label .. '</span> - <span class="' .. dutyClass .. '">' .. duty .. '</span></div>'
        end
    end

    HTML = new
    TriggerClientEvent("nv:officers:refresh", -1, HTML)
end)

function GetName(source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
    {
        ['@identifier'] = GetPlayerIdentifiers(source)[1]
    })

    if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
         return result[1].firstname .. ' ' .. result[1].lastname
    else
        return ""
    end
end

CreateThread(function()
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "callsigns.json"))

    if result then
        CallSigns = result
    end
end)
