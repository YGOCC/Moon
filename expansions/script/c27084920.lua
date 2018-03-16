--Exostorm Preperations
function c27084920.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(27084920,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Recover
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27084920,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_REMOVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCondition(c27084920.hpcon)
    e2:SetOperation(c27084920.hpop)
    c:RegisterEffect(e2)
    --banish
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(27084920,2))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_DECK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,27084920)
    e3:SetCondition(c27084920.rmcon)
    e3:SetTarget(c27084920.rmtg)
    e3:SetOperation(c27084920.rmop)
    c:RegisterEffect(e3)
end
function c27084920.recfilter(c)
    return c:IsSetCard(0xc1c) 
end
function c27084920.hpcon(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c27084920.recfilter,nil)
    return g:GetCount()>0
end
function c27084920.hpop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Recover(tp,500,REASON_EFFECT)
end
function c27084920.cfilter(c,tp)
    return c:IsSetCard(0xc1c) and c:IsLocation(LOCATION_DECK)
        and c:GetPreviousControler()==tp
end
function c27084920.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c27084920.cfilter,1,nil,tp) and eg:GetCount()==1
end
function c27084920.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c27084920.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end