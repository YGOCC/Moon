--Roots of Corruption
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
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cod.actcon)
    e1:SetOperation(cod.actop)
    c:RegisterEffect(e1)
    --Adjust
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(function (e) return Duel.IsExistingMatchingCard(cod.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end)
    e2:SetOperation(cod.adjustop)
    c:RegisterEffect(e2)
--[[   --SP Restrict
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetCondition(cod.mcon)
    e3:SetTarget(cod.sumlimit)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetTargetRange(0,1)
    e4:SetCondition(cod.mcon2)
    c:RegisterEffect(e4)]]
end
cod[0]=0
cod[1]=0
--Activate
function cod.actcon(e)
    return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,id)
end
function cod.thfilter(c)
    return c:IsCode(52894703) and c:IsAbleToHand()
end
function cod.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(cod.thfilter,tp,LOCATION_DECK,0,nil)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        if #sg<=0 then return end
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end

--Adjust
function cod.mcon(e)
    if cod[0]==0 then return false end
    local ct=Duel.GetMatchingGroupCount(cod.mfilter,tp,LOCATION_MZONE,0,nil)
    if cod[0]>ct then
        return false
    else
       return cod[0]==ct
    end
end
function cod.mcon2(e)
    if cod[1]==0 then return false end
    local g=Duel.GetMatchingGroup(cod.mfilter,tp,0,LOCATION_MZONE,nil)
    if cod[1]==1 then
        return g:IsExists(cod.mat,1,nil,c)
    elseif cod[1]>#g then
        return false
    else
        return cod[1]==#g
    end
end
function cod.rfilter(c)
    return c:IsSetCard(0xf07a)
end
function cod.mfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_XYZ+TYPE_LINK+TYPE_SYNCHRO) and not c:IsSetCard(0xf07a)
end
function cod.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
    local sg=Group.CreateGroup()
    local rg=Duel.GetMatchingGroup(cod.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    for p=0,1 do
        local g=Duel.GetMatchingGroup(cod.mfilter,p,LOCATION_MZONE,0,nil)
        if #rg==0 then
            cod[p]=0
        elseif #g~=#rg and #g>#rg then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local dg=g:Select(p,#g-#rg,#g-#rg,nil)
            sg:Merge(dg)
            cod[p]=#g-#rg
        else
            cod[p]=#rg
        end
    end
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,REASON_RULE)
        Duel.Readjust()
    end
end

function cod.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x7fa) and c:IsType(TYPE_FUSION+TYPE_XYZ+TYPE_LINK+TYPE_SYNCHRO)
end