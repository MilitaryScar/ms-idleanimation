local isIdlePlaying = false
local lastActionTime = 0
local idleTimeout = 300000  -- Set your desired idle timeout in milliseconds (5 minutes)
local interval = 30000  -- Set your desired interval in milliseconds

local maleAnimDicts = {
    "move_m@generic_idles@std",
    "additional_male_anim_dict_1",
    "additional_male_anim_dict_2"
}

local femaleAnimDicts = {
    "move_f@generic_idles@std",
    "additional_female_anim_dict_1",
    "additional_female_anim_dict_2"
}

local currentAnimIndex = 1

Citizen.CreateThread(function()
    while true do
        Wait(interval) 
        InvalidateIdleCam()
        InvalidateVehicleIdleCam()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            CheckPlayerInput(playerPed)
            CheckIdleAnimation(playerPed)
        end
    end
end)

function CheckPlayerInput(playerPed)
    if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then -- Checks if player is pressing W A S or D
        lastActionTime = GetGameTimer()

        if isIdlePlaying then
            ClearPedTasks(playerPed)
            isIdlePlaying = false
        end
    end
end

function CheckIdleAnimation(playerPed)
    if GetGameTimer() - lastActionTime > idleTimeout and not isIdlePlaying then
        local animDicts = IsPedMale(playerPed) and maleAnimDicts or femaleAnimDicts
        local animDict = animDicts[currentAnimIndex]

        RequestAnimDict(animDict)
        if HasAnimDictLoaded(animDict) then
            TaskPlayAnim(playerPed, animDict, "idle", 8.0, -8, -1, 49, 0, false, false, false)
            isIdlePlaying = true

            -- Cycle to the next animation dictionary
            currentAnimIndex = (currentAnimIndex % #animDicts) + 1
        end
    end
end
