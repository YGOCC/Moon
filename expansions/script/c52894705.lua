--Root's Pierre
--Keddy was here~
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
    --Fusion Summon
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,52894703,cod.mfilter,1,true,false)
    --Sp Summon Con
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.fuslimit)
    c:RegisterEffect(e0)
    --Adjust
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_ADJUST)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(cod.adjustop)
    c:RegisterEffect(e1)
    --Cannot Activate
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,1)
    e2:SetValue(cod.aclimit)
    c:RegisterEffect(e2)
    --Cannot Summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1,1)
    e3:SetTarget(cod.splimit)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e5)
    --BGM Music
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetOperation(cod.bgmop)
    c:RegisterEffect(e6)
end
function cod.ffilter(c)
    return (c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) or c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET) or c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET))
end
function cod.mfilter(c)
    if c:IsFaceup() then
        return c:IsHasEffect(EFFECT_INDESTRUCTABLE) or c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
            or c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or c:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)
            or c:IsHasEffect(EFFECT_IMMUNE_EFFECT) or c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)
            or c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) or c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
    else return false end
end
function cod.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
    local sg=Group.CreateGroup()
    for p=0,1 do
        local g=Duel.GetMatchingGroup(cod.mfilter,p,LOCATION_MZONE,0,nil)
        if #g>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local dg=g:Select(p,#g,#g,nil)
            sg:Merge(dg)
        end
    end
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,REASON_RULE)
        Duel.Readjust()
    end
end

--Cannot Activate
function cod.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e) and (re:IsHasProperty(EFFECT_FLAG_CANNOT_NEGATE) or re:IsHasProperty(EFFECT_FLAG_CANNOT_DISABLE))
end

--Cannot Summon
function cod.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    local spcon=c:IsHasEffect(EFFECT_CANNOT_DISABLE_SPSUMMON) or c:IsHasEffect(EFFECT_CANNOT_DISABLE_SUMMON)
    if not spcon then
        if not se then
            return false
        else
            local effect=se:GetCode()
            if effect and effect==(EFFECT_CANNOT_DISABLE_SPSUMMON or effect==EFFECT_CANNOT_DISABLE_SUMMON) then
                return true
            end
        end
    elseif spcon then
        return true
    end
end

--BGM Music
function cod.bgmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(11,0,aux.Stringid(id,0))
end