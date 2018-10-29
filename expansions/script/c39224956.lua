--Grimheart Maiden
--Design by Reverie
--Script by NightcoreJack
function c39224956.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(39224956,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,39224956)
    e1:SetCost(c39224956.thcost)
    e1:SetTarget(c39224956.thtg)
    e1:SetOperation(c39224956.thop)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(39224956,ACTIVITY_CHAIN,c39224956.chainfilter)
    --copy effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(39224956,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,39224966)
    e2:SetCost(c39224956.cpcost)
    e2:SetTarget(c39224956.cptg)
    e2:SetOperation(c39224956.cpop)
    c:RegisterEffect(e2)
end
function c39224956.chainfilter(re,tp,cid)
    return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x37f))
end
function c39224956.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(39224956,tp,ACTIVITY_CHAIN)>0 end
end
function c39224956.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x37f) and c:IsAbleToHand()
end
function c39224956.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c39224956.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c39224956.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c39224956.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c39224956.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c39224956.cpfilter(c)
    return c:IsSetCard(0x37f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:CheckActivateEffect(true,true,false)~=nil
end
function c39224956.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        local tc=e:GetLabelObject()
        local tg=tc:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
    end
    if chk==0 then return Duel.IsExistingTarget(c39224956.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c39224956.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
    Duel.ClearTargetCard()
    g:GetFirst():CreateEffectRelation(e)
    local tg=tc:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    tc:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(tc)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c39224956.cpop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if not tc then return end
    if not tc:GetHandler():IsRelateToEffect(e) then return end
    e:SetLabelObject(tc:GetLabelObject())
    local op=tc:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
    Duel.BreakEffect()
    Duel.SSet(tp,tc:GetHandler())
        Duel.ConfirmCards(1-tp,tc:GetHandler())
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        tc:GetHandler():RegisterEffect(e1,tc:GetHandler())
end
