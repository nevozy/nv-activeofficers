local ESX = nil
local HTML = ""
local CallSigns = {}
local Tracked = {}
local IdentifierPrefixes = {"discord:", "steam:", "license:"}

if Config.ESX then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end
RegisterCommand("plist", function(source, args)
    if Config.ESX then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice') then
            local type = "toggle"

            if args[1] == "0" then
                type = "drag"
            end

            TriggerClientEvent("nv:officers:open", src, type)
        end
    else
        if Config.UsePermissions then
            if Config.PermissionSystemToUse == 1 then
                if not exports['discordroles']:isRolePresent(source, Config.DiscordPermsSettings["USE"]) then
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = { "Error", "You don't have permissions to run this command!" }
                    })
                    return
                end
            else
                if not IsPlayerAceAllowed(source, Config.AcePermsSettings["USE"]) then
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = { "Error", "You don't have permissions to run this command!" }
                    })
                    return
                end
            end
        end
        local type = "toggle"

        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("nv:officers:open", src, type)
    end
end)

RegisterCommand("callsign", function(source, args)
    if Config.ESX then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice') and args[1] then
            CallSigns[xPlayer.getIdentifier()] = args[1]
            SaveResourceFile(GetCurrentResourceName(), "callsigns.json", json.encode(CallSigns))
            TriggerEvent("nv:officers:refresh")
        end
    else
        if args[1] == nil then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = { "Error", "Callsign is required!" }
            })
            return
        end
        if args[2] == nil then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = { "Error", "First name is required!" }
            })
            return
        end
        if args[3] == nil then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = { "Error", "Last name/initial is required!" }
            })
            return
        end
        if Config.UseRankStandalone and args[4] == nil then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = { "Error", "Rank is required!" }
            })
            return
        end
        if Config.UsePermissions then
            if Config.PermissionSystemToUse == 1 then
                if exports['discordroles']:isRolePresent(source, Config.DiscordPermsSettings["USE"]) then
                    if Config.UseRankStandalone then
                        if Config.BlockUnconfiguredRank and Config.DiscordPermsSettings[string.upper(args[4])] == nil then
                            TriggerEvent('chat:addMessage', {
                                color = { 255, 0, 0},
                                multiline = true,
                                args = { "Error", "That rank hasn't been configured!" }
                            })
                            return
                        elseif Config.DiscordPermsSettings[string.upper(args[4])] ~= nil then
                            if not exports['discordroles']:isRolePresent(source, Config.DiscordPermsSettings[string.upper(args[4])]) then
                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = { "Error", "You don't have permissions to use this rank!" }
                                })
                                return
                            end
                        end
                    end
                else
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = { "Error", "You don't have permissions to run this command!" }
                    })
                    return
                end
            else
                if IsPlayerAceAllowed(source, "ao."..Config.AcePermsSettings["USE"]) then
                    if Config.UseRankStandalone then
                        if Config.BlockUnconfiguredRank and Config.AcePermsSettings[string.upper(args[4])] == nil then
                            TriggerEvent('chat:addMessage', {
                                color = { 255, 0, 0},
                                multiline = true,
                                args = { "Error", "That rank hasn't been configured!" }
                            })
                            return
                        elseif Config.AcePermsSettings[string.upper(args[4])] ~= nil then
                            if not IsPlayerAceAllowed(source, Config.AcePermsSettings[string.upper(args[4])]) then
                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = { "Error", "You don't have permissions to use this rank!" }
                                })
                                return
                            end
                        end
                    end
                else
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = { "Error", "You don't have permissions to run this command!" }
                    })
                    return
                end
            end
        end
        identifiers = GetPlayerIdentifiers(source)
        local identifier = ""
        for i in ipairs(identifiers) do
            if string.match(i, IdentifierPrefixes[Config.IdentifierType]) then
                identifier = i
                break
            end
        end
        Tracked[identifier] = args[2].." "..args[3]
        if Config.UseRankStandalone then
            CallSigns[identifier] = {}
            CallSigns[identifier]["CallSign"] = args[1]
            CallSigns[identifier]["Rank"] = args[4]
        else
            CallSigns[identifier] = args[1]
        end
    end
end)

RegisterServerEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function()
    local new = ""

    if Config.ESX then
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
    else
        if Config.UseRankStandalone then
            for k,v in pairs(Tracked) do
                local name = v
                local rank = CallSigns[identifier]["Rank"]
                local callSign = CallSigns[identifier]["CallSign"]
                new = new .. '<div class="officer"><span class="callsign">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. rank .. '</span></div>'
            end
        else
            for k,v in pairs(Tracked) do
                local name = v
                local callSign = CallSigns[identifier]
                new = new .. '<div class="officer"><span class="callsign">' .. callSign .. '</span> <span class="name">' .. name .. '</span></div>'
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
    if Config.ESX then
        local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "callsigns.json"))

        if result then
            CallSigns = result
        end
    end
end)
