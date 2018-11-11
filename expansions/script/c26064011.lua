--Over-wind Accel
function c26064011.initial_effect(c)
--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
--inactivatable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_INACTIVATE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetValue(c26064011.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISEFFECT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetValue(c26064011.efilter)
    c:RegisterEffect(e3)
    --cannot disable summon
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
    e4:SetRange(LOCATION_SZONE)
    e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FLIP))
    c:RegisterEffect(e4)
--trap setup
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x664))
    e5:SetTargetRange(LOCATION_SZONE,0)
    c:RegisterEffect(e5)
--rewrite and draw
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCode(EVENT_CHAIN_SOLVING)
    e6:SetOperation(c26064011.reop)
    c:RegisterEffect(e6)
--singularity
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetCode(26064011)
    e7:SetRange(LOCATION_SZONE)
    e7:SetTargetRange(1,1)
    c:RegisterEffect(e7)
end

function c26064011.efilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return te:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_FLIP)
end
function c26064011.reop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) and not rc:IsSetCard(0x664) and
        (re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_SEARCH)) then
        local g=Group.CreateGroup()
        Duel.ChangeTargetCard(ev,g)
        Duel.ChangeChainOperation(ev,c26064011.repop)
    end
end
function c26064011.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
        c:CancelToGrave(false)
    end
    Duel.Draw(tp,1,REASON_EFFECT)
end