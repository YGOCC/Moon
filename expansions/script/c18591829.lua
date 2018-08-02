--EQUIVALENT DESTRUCTION
function c18591829.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c18591829.target)
    e1:SetOperation(c18591829.activate)
    c:RegisterEffect(e1)
    --NegateActivation
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591829,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c18591829.discon)
    e1:SetCost(aux.bfgcost)
    e1:SetTarget(c18591829.distg)
    e1:SetOperation(c18591829.disop)
    c:RegisterEffect(e1)
end
function c18591829.ctfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x50e)
end
function c18591829.schfilter(c)
    return c:IsSetCard(0x50e) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and c:IsAbleToHand()
end
function c18591829.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c18591829.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local ct=Duel.GetMatchingGroupCount(c18591829.ctfilter,tp,LOCATION_MZONE,0,c)
        local sel=0
        if ct>0 and Duel.IsExistingMatchingCard(c18591829.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then sel=sel+1 end
        if Duel.IsExistingMatchingCard(c18591829.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then sel=sel+2 end
        e:SetLabel(sel)
        return sel~=0
    end
    local sel=e:GetLabel()
    if sel==3 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18591829,0))
        sel=Duel.SelectOption(tp,aux.Stringid(18591829,1),aux.Stringid(18591829,2))+1
    elseif sel==1 then
        Duel.SelectOption(tp,aux.Stringid(18591829,1))
    else
        Duel.SelectOption(tp,aux.Stringid(18591829,2))
    end
    e:SetLabel(sel)
    if sel==1 then
        local g=Duel.GetMatchingGroup(c18591829.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        e:SetCategory(CATEGORY_DESTROY)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    else
        e:SetCategory(CATEGORY_TOHAND)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    end
end
function c18591829.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sel=e:GetLabel()
    if sel==1 then
        local ct=Duel.GetMatchingGroupCount(c18591829.ctfilter,tp,LOCATION_MZONE,0,c)
        local g=Duel.GetMatchingGroup(c18591829.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if ct>0 and g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local dg=g:Select(tp,1,ct,nil)
            Duel.HintSelection(dg)
            Duel.Destroy(dg,REASON_EFFECT)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c18591829.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c18591829.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c18591829.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c18591829.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
