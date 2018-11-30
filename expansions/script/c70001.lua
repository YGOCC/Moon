--"Espadachim - Searcher"
local m=70001
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Search"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70001,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c70001.stg)
    e1:SetOperation(c70001.sop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --"ATK"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c70001.atkval)
    c:RegisterEffect(e3)
end
function c70001.sfilter(c)
    return c:IsSetCard(0x510) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c70001.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c70001.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c70001.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c70001.atfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c70001.atkval(e,c)
    return Duel.GetMatchingGroupCount(c70001.atfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end