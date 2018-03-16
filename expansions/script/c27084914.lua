--Exostorm Katana
function c27084914.initial_effect(c)
    c:SetUniqueOnField(1,0,27084914)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,27084914)
    e1:SetCondition(c27084914.spcon)
    e1:SetOperation(c27084914.spop)
    c:RegisterEffect(e1)
    --pierce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
    --pos
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(27084914,1))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCost(c27084914.poscost)
    e3:SetTarget(c27084914.postg)
    e3:SetOperation(c27084914.posop)
    c:RegisterEffect(e3)
end
function c27084914.spfilter(c)
    return c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c27084914.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c27084914.spfilter,tp,LOCATION_DECK,0,1,nil)
end
function c27084914.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084914.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084914.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc1c) and c:IsAbleToDeckAsCost()
end
function c27084914.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084914.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c27084914.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c27084914.posfilter(c)
    return c:IsFaceup() and c:IsCanChangePosition()
end
function c27084914.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c27084914.posfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c27084914.posfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c27084914.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c27084914.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
    end
end