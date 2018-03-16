--Exostorm Tankbuster
function c27084916.initial_effect(c)
    c:SetUniqueOnField(1,0,27084916)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,27084916)
    e1:SetCondition(c27084916.spcon)
    e1:SetOperation(c27084916.spop)
    c:RegisterEffect(e1)
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(27084916,1))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCost(c27084916.atkcost)
    e3:SetTarget(c27084916.atktg)
    e3:SetOperation(c27084916.atkop)
    c:RegisterEffect(e3)
end
function c27084916.spfilter(c)
    return c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c27084916.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c27084916.spfilter,tp,LOCATION_DECK,0,1,nil)
end
function c27084916.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084916.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084916.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc1c) and c:IsAbleToDeckAsCost()
end
function c27084916.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084916.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c27084916.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c27084916.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c27084916.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
