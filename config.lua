Config = {}

Config.ESX = true

Config.IdentifierType = 0 -- Choose what type of identifier to use: 0 - discord, 1 - steam, 2 - license

Config.UseRankStandalone = false -- Only applies to non-ESX installations, will add the ability to set your rank through /callsign

Config.UsePermissions = true -- Setting to false allows all players to use this system (NOT RECOMMENDED)

Config.PermissionSystemToUse = 0 -- Which permission system to use, only applies if UsePermissions is true: 0 - AcePerms, 1 - Discord --- Discord Perms will require an extra resource called Discordroles(https://forum.cfx.re/t/discordroles-a-proper-attempt-this-time/1579427) it must be called "discordroles"

Config.BlockUnconfiguredRanks = false -- Set to true to disallow ranks that aren't configured in the permission system of your choice

Config.AcePermsSettings = {
    --[[
        USAGE:
            ["RANK"] = "PermissionName",
        ────────────────────────────────────────────────────────────────
        "RANK" is the rank the user enters
        "PermissionName" is the ace perm that will be required to use that rank, no spaces
        The "USE" perm is the base perm used to allow users to use the commands at all, if you remove it and don't set UsePermissions to false the script will NOT work.
        All perms will be prefixed with "ao" e.g. "ao.use"
        Enter all ranks in all uppercase e.g. "RANK", not "RaNK" or "Rank"
        Permission names should be all lowercase
    ]]
    ["USE"] = "use",
    ["COMMANDER"] = "commander"
}

Config.DiscordPermsSettings = {
    --[[
        USAGE:
            ["RANK"] = "RoleID",
        ────────────────────────────────────────────────────────────────
        "RANK" is the rank the user enters
        "RoleID" is the ID of the Discord role that will be required to use that rank
        The "USE" perm is the base perm used to allow users to use the commands at all, if you remove it and don't set UsePermissions to false the script will NOT work.
        Enter all ranks in all uppercase e.g. "RANK", not "RaNK" or "Rank"
    ]]
    ["USE"] = "1234567890", -- MUST CONFIGURE TO USE DISCORD PERMS!!
    ["COMMANDER"] = "1234567890"
}