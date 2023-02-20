local enabled = false
if enabled == false then return end

wait(5)

local owner = 255266623
local alts = {
    [1] = 2317523580,
    [2] = 2053170175
} -- order isn't important unless you plan on needing order.

local ps = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = ps.LocalPlayer
local character = plr.Character
local humanoid = character.Humanoid

if owner == plr.UserId then 
    print("User is the owner.")
    return
end

print("This user is an alt.")

local myOwner = ps:GetPlayerByUserId(owner)
local followF;

local commands = {
    jump = function(args) --easy example
        if args[1] ~= nil then
            plr.Character.Humanoid.JumpPower = args[1]  
        end
        plr.Character.Humanoid.Jump = true
    end,
    chat = function(args)
        if #args > 0 then
            local newString = string.gsub(args[1], "_", " ")
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(newString,"All")
        else
            print("Chat requires 1 Argument.")
        end
    end,
    follow = function(args)
        local tablePlace = table.find(alts,plr.UserId) -- 1
        if args[1] == "true" then
            followF = RunService.Heartbeat:Connect(function(step)
                local targetPosition = myOwner.Character.HumanoidRootPart.Position
                humanoid.WalkSpeed = myOwner.Character.Humanoid.WalkSpeed + 5
                humanoid:MoveTo((myOwner.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2.5*tablePlace)).Position)
                character.HumanoidRootPart.CFrame = CFrame.lookAt(
                    character.HumanoidRootPart.Position,
                    Vector3.new(targetPosition.X, character.HumanoidRootPart.Position.Y, targetPosition.Z)
                )
                wait(0.000001)
            end)
        elseif args[1] == "false" then
            if followF ~= nil then
                followF:Disconnect()
            end
        end
    end
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
