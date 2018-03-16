--Exostorm Raider
function c27084915.initial_effect(c)
    c:SetUniqueOnField(1,0,27084915)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,27084915)
    e1:SetCondition(c27084915.spcon)
    e1:SetOperation(c27084915.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27084915,1))
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c27084915.rmtg)
    e2:SetOperation(c27084915.rmop)
    c:RegisterEffect(e2)
end
function c27084915.spfilter(c)
    return c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c27084915.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c27084915.spfilter,tp,LOCATION_DECK,0,1,nil)
end
function c27084915.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084915.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084915.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg=Duel.GetDecktopGroup(tp,3)
    if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==3 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
end
function c27084915.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetDecktopGroup(tp,3)
    if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0
        and c:IsFaceup() and c:IsRelateToEffect(e) then
        local og=Duel.GetOperatedGroup()
        local oc=og:FilterCount(Card.IsSetCard,nil,0xc1c)
        if oc==0 then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(oc*300)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end