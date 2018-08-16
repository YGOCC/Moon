--Root's Crimson Queen
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
    aux.AddFusionProcCodeFun(c,52894703,cod.ffilter,1,true,false)
    --Sp Summon Con
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.fuslimit)
    c:RegisterEffect(e0)
    --Direct Attacks
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    c:RegisterEffect(e1)
    --Direct Effects
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_CHAIN_ACTIVATING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cod.tgcon)
    e2:SetTarget(cod.tgtg)
    e2:SetOperation(cod.tgop)
    c:RegisterEffect(e2)
    --BGM Music
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(cod.bgmop)
    c:RegisterEffect(e3)
end

--Fusion Filter
function cod.ffilter(c)
    return c:GetAttackAnnouncedCount()~=0
end

--Effect Redirect
function cod.tgcon(e,tp,eg,ep,ev,re,r,rp)
    if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    e:SetLabelObject(g)
    return g and g:FilterCount(Card.IsOnField,nil)>0
end

function cod.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tf=re:GetTarget()
    local tg=e:GetLabelObject()
    if chkc then return false end
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.HintSelection(Group.FromCards(re:GetHandler()))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,#tg,nil)
end
function cod.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if #g>0 then
        Duel.ChangeTargetCard(ev,g)
    end
end

--BGM Music
function cod.bgmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(11,0,aux.Stringid(id,0))
end