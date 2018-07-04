--Subzero Crystal - Crystalized Cavern
--Subzero Crystal - Crystalized Cavern
function c88890010.initial_effect(c)
    --(1) Send to GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88890010,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c88890010.tgtg)
    e1:SetOperation(c88890010.tgop)
    c:RegisterEffect(e1)
    --(2) Place in S/T Zone
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890010,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c88890010.stztg)
    e2:SetOperation(c88890010.stzop)
    c:RegisterEffect(e2)
    --(3) Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(88890010,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCost(c88890010.thcost)
    e3:SetCondition(c88890010.thcon)
    e3:SetTarget(c88890010.thtg)
    e3:SetOperation(c88890010.thop)
    c:RegisterEffect(e3)
end
--(1) Send to GY
function c88890010.tgfilter(c)
    return c:IsAbleToGrave()
end
function c88890010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c88890010.tgop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
    local g=Group.CreateGroup()
    if #g1>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g3=g1:Select(1-tp,1,1,nil)
        g:Merge(g3)
    end
    if #g2>0 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
        local g4=g2:Select(tp,1,1,nil)
        g:Merge(g4)
    end
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
--(2) Place in S/T Zone
function c88890010.stzfilter(c)
    return c:GetLevel()==6 and c:IsSetCard(0x902) and c:GetOriginalType()&0x81==0x81 and not c:IsForbidden()
end
function c88890010.stztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c88890010.stzfilter,tp,LOCATION_GRAVE,0,1,nil)
    and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c88890010.stzfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c88890010.stzop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if not e:GetHandler():IsRelateToEffect(e) or ft<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc then
        --Continuous Spell
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+99020150,e,0,tp,0,0)
    end
end
--(3) Search
function c88890010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDestructable() end
    Duel.Destroy(c,REASON_COST)
end 
function c88890010.desconfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x902) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:GetLevel()==6
end
function c88890010.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c88890010.desconfilter,tp,LOCATION_SZONE,0,3,nil)
end
function c88890010.thfilter(c)
    return c:IsSetCard(0x902) and not c:IsCode(88890010) and c:IsAbleToHand()
end
function c88890010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890010.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890010.thop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(c88890010.desconfilter,tp,LOCATION_SZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890010.thfilter,tp,LOCATION_DECK,0,1,ct,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end


