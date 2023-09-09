repeat task.wait() until game.IsLoaded
repeat task.wait() until game.GameId ~= 0

if Vortic and Vortic.Loaded then
    Vortic.Utilities.UI:Notification({
        Title = "Vortic Hub",
        Description = "Script already running!",
        Duration = 5
    }) return
end

if Vortic and (Vortic.Game and not Vortic.Loaded) then
    Vortic.Utilities.UI:Notification({
        Title = "Vortic Hub",
        Description = "Something went wrong!",
        Duration = 5
    }) return
end

local PlayerService = game:GetService("Players")
repeat task.wait() until PlayerService.LocalPlayer
local LocalPlayer = PlayerService.LocalPlayer

local Branch,NotificationTime,IsLocal = ...
local QueueOnTeleport = queue_on_teleport
or (syn and syn.queue_on_teleport)

local function GetFile(File)
    return IsLocal and readfile("Vortic/" .. File)
    or game:HttpGet(("%s%s"):format(Vortic.Source,File))
end

local function LoadScript(Script)
    return loadstring(GetFile(Script .. ".lua"),Script)()
end

local function GetGameInfo()
    for Id,Info in pairs(Vortic.Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end

    return Vortic.Games.Universal
end

getgenv().Vortic = {
    Source = "https://raw.githubusercontent.com/Nexiss5/Vortic/" .. Branch .. "/",

    Games = {
        ["Universal" ] = {Name = "Universal",                 Script = "Universal" },
        ["358276974" ] = {Name = "Apocalypse Rising 2",       Script = "Games/AR2" },
        ["3495983524"] = {Name = "Apocalypse Rising 2 Dev.",  Script = "Games/AR2" },
    }
}

Vortic.Utilities = LoadScript("Utilities/Main")
Vortic.Utilities.UI = LoadScript("Utilities/UI")
Vortic.Utilities.Physics = LoadScript("Utilities/Physics")
Vortic.Utilities.Drawing = LoadScript("Utilities/Drawing")

Vortic.Cursor = GetFile("Utilities/ArrowCursor.png")
Vortic.Loadstring = GetFile("Utilities/Loadstring")
Vortic.Loadstring = Vortic.Loadstring:format(
    Vortic.Source,Branch,NotificationTime,
    tostring(IsLocal)
)

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        QueueOnTeleport(Vortic.Loadstring)
    end
end)

Vortic.Game = GetGameInfo()
LoadScript(Vortic.Game.Script)
Vortic.Utilities.UI:Notification({
    Title = "Vortic Hub",
    Description = Vortic.Game.Name .. " loaded!\n\nThis script is open sourced\nIf you have paid for this script\nOr had to go thru ads\nYou have been scammed.",
    Duration = 20
}) Vortic.Loaded = true
