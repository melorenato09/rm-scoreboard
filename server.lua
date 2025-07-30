local QBCore = exports['qb-core']:GetCoreObject()

-- Callback principal com todos os dados necessários para a scoreboard
QBCore.Functions.CreateCallback('qb-scoreboard:server:GetFullData', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    local MechanicCount = 0
    local players = QBCore.Functions.GetPlayers()
    local maxPlayers = GetConvarInt("sv_maxclients", 48)

    for _, v in pairs(players) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player then
            local job = Player.PlayerData.job
            if job.name == "police" and job.onduty then
                PoliceCount = PoliceCount + 1
            elseif (job.name == "ambulance" or job.name == "doctor") and job.onduty then
                AmbulanceCount = AmbulanceCount + 1
            elseif job.name == "mechanic" and job.onduty then
                MechanicCount = MechanicCount + 1
            end
        end
    end

    cb({
        players = #players,
        maxPlayers = maxPlayers,
        currentCops = PoliceCount,
        currentAmbulance = AmbulanceCount,
        currentMechanic = MechanicCount
    })
end)

-- Configuração adicional do scoreboard (atividades ilegais)
QBCore.Functions.CreateCallback('qb-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

-- Callback para obter os jogadores e as permissões (optin de staff/admin)
QBCore.Functions.CreateCallback('qb-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player then 
            players[Player.PlayerData.source] = {
                permission = QBCore.Functions.IsOptin(Player.PlayerData.source)
            }
        end
    end
    cb(players)
end)

-- Evento para definir se uma atividade ilegal está ocupada
RegisterServerEvent('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)


--- Update Alerts
local updatePath
local resourceName

local function checkVersion(err, responseText, headers)
    local curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
    if responseText == nil then 
        print("^1"..resourceName.." check for updates failed ^7") 
        return 
    end
    if curVersion ~= nil and responseText ~= nil then
        local Color = "^1"
        if curVersion == responseText then Color = "^2" end
        print("\n^1----------------------------------------------------------------------------------^7")
        print(resourceName.."'s latest version is: ^2"..responseText.."!\n^7Your current version: "..Color..""..curVersion.."^7!\nIf needed, update from https://github.com"..updatePath)
        print("^1----------------------------------------------------------------------------------^7")
    end
end

CreateThread(function()
    updatePath = "/melorenato09/RM-Scoreboard" -- <=== O teu repositório do GitHub
    resourceName = "RM-Scoreboard ("..GetCurrentResourceName()..")"
    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)
