local player = player

local PlayerIterator = player.Iterator

local EVENT = {}

EVENT.Title = "Wait... What's my ability again?"
EVENT.Description = "Everyone has a randomly generated Amnesiac ability."
EVENT.id = "amnesiac"
EVENT.Categories = {"fun", "moderateimpact"}

function EVENT:Begin()
    for _, p in PlayerIterator() do
        -- Do this for everyone, even Amnesiacs and dead players in case they change roles or get respawned later
        p:SetNWBool("TTTAmnesiacNonAmnesiacAbility", true)

        -- Don't assign an ability to someone who is already an amnesiac
        if p:GetRole() == ROLE_AMNESIAC then continue end

        AMNESIAC:AssignAbility(p)
    end
end

function EVENT:End()
    for _, p in PlayerIterator() do
        if not p:GetNWBool("TTTAmnesiacNonAmnesiacAbility") then continue end
        p:SetNWBool("TTTAmnesiacNonAmnesiacAbility", false)

        -- Amnesiacs keep their ability after the event ends
        if p:GetRole() == ROLE_AMNESIAC then continue end

        local abilityText = AMNESIAC:GetAbilityText(p, true)
        if abilityText then
            p:QueueMessage(MSG_PRINTTALK, "Your ability was: " .. abilityText)
        end

        AMNESIAC:Cleanup(p)
    end
end

function EVENT:Condition()
    if not AMNESIAC then return false end
end

Randomat:register(EVENT)
