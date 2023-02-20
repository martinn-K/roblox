wait(5)

local owner = 255266623
local alts = {
    [1] = 2317523580
} -- order isn't important unless you plan on needing order.

local ps = game:GetService("Players")
local plr = ps.LocalPlayer

if owner == plr.UserId then 
    print("User is the owner.")
    return
end

print("This user is an alt.")

local myOwner = ps:GetPlayerByUserId(owner)

local commands = {
    jump = function(args) --easy example
        if args[1] ~= nil then
            plr.Character.Humanoid.JumpPower = args[1]  
        end
        plr.Character.Humanoid.Jump = true
    end --/jump 50
}

myOwner.Chatted:Connect(function(cmd) --/jump 1 2
    local baseCmd = string.split(cmd:sub(2)," ")[1] -- "jump"
    if commands[baseCmd] == nil then
        print("Not a command.")
        return
    end
    local wOut = string.gsub(cmd, "%b/ ", "", 1) --"1 2"
    local args = string.split(wOut, " ") -- {"/jump","1","2"}
    if args[1] == "/"..baseCmd then
        args = {}
    end
    commands[baseCmd](args)
end)
