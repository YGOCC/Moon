--Wyndbreaker Betrayal
function c97671897.initial_effect(c)
--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1e0)
    e1:SetCountLimit(1,97671897)
    e1:SetCost(c97671897.cost)
    e1:SetTarget(c97671897.target)
    e1:SetOperation(c97671897.activate)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(97671897,0))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c97671897.drtg)
    e2:SetOperation(c97671897.drop)
    c:RegisterEffect(e2)
end
function c97671897.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function c97671897.costfilter(c,e,dg)
    if not c:IsSetCard(0xd70) then return false end
    local a=0
    if dg:IsContains(c) then a=1 end
    if c:GetEquipCount()==0 then return dg:GetCount()-a>=2 end
    local eg=c:GetEquipGroup()
    local tc=eg:GetFirst()
    while tc do
        if dg:IsContains(tc) then a=a+1 end
        tc=eg:GetNext()
    end
    return dg:GetCount()-a>=2
end
function c97671897.tgfilter(c,e)
    return c:IsCanBeEffectTarget(e)
end
function c97671897.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then
        if chkc then return chkc:IsOnField() end
        if e:GetLabel()==1 then
            e:SetLabel(0)
            local rg=Duel.GetReleaseGroup(tp)
            local dg=Duel.GetMatchingGroup(c97671897.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
            local res=rg:IsExists(c97671897.costfilter,1,e:GetHandler(),e,dg)
            return res
        else
            return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())
        end
    end
    if e:GetLabel()==1 then
        e:SetLabel(0)
        local rg=Duel.GetReleaseGroup(tp)
        local dg=Duel.GetMatchingGroup(c97671897.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local sg=rg:FilterSelect(tp,c97671897.costfilter,1,1,e:GetHandler(),e,dg)
        Duel.Release(sg,REASON_COST)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c97671897.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(sg,REASON_EFFECT)
end
function c97671897.drfilter(c,e)
    return c:IsSetCard(0xd70) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c97671897.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(c97671897.drfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and g:GetClassCount(Card.GetCode)>4 end
    local sg=Group.CreateGroup()
    for i=1,5 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        sg:Merge(g1)
    end
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c97671897.drop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==5 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end