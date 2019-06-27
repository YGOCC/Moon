--Star Bearer's Sign
local m=888731
local cm=_G["c"..m]
function cm.initial_effect(c)
        --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --replace
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(21501505,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(cm.condition)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.tg)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()~=1 then return false end
    local tc=g:GetFirst()
    e:SetLabelObject(tc)
    return tc:IsOnField() and g:IsExists(cm.tfilter,1,nil,tp)
end
function cm.tfilter(c)
    return c:IsSetCard(0xff1)
end
function cm.tffilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
    return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ct=ev
    local label=Duel.GetFlagEffectLabel(0,21501505)
    if label then
        if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
    end
    local ce,cp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tf=ce:GetTarget()
    local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ct)
    if chkc then return chkc:IsOnField() and cm.tffilter(chkc,ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
    if chk==0 then return Duel.IsExistingTarget(cm.tffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.tffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),ce,cp,tf,ceg,cep,cev,cre,cr,crp)
    local val=ct+bit.lshift(ev+1,16)
    if label then
        Duel.SetFlagEffectLabel(0,21501505,val)
    else
        Duel.RegisterFlagEffect(0,21501505,RESET_CHAIN,0,1,val)
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangeTargetCard(ev,Group.FromCards(tc))
    end
end


