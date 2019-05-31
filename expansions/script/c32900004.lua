--Magician of the Fae
function c32900004.initial_effect(c)
   --search
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(32900004,0))
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
   e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetTarget(c32900004.thtg)
   e1:SetOperation(c32900004.thop)
   c:RegisterEffect(e1)
   --recover
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(32900004,2))
   e2:SetCategory(CATEGORY_TOHAND)
   e2:SetType(EFFECT_TYPE_IGNITION)
   e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
   e2:SetRange(LOCATION_MZONE)
   e2:SetCountLimit(1)
   e2:SetTarget(c32900004.target)
   e2:SetOperation(c32900004.operation)
   c:RegisterEffect(e2)
   --tograve
   local e3=Effect.CreateEffect(c)
   e3:SetDescription(aux.Stringid(32900004,3))
   e3:SetCategory(CATEGORY_TOGRAVE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
   e3:SetCountLimit(1)
   e3:SetRange(LOCATION_GRAVE)
   e3:SetCondition(c32900004.tgcon)
   e3:SetCost(aux.bfgcost)
   e3:SetTarget(c32900004.tgtg)
   e3:SetOperation(c32900004.tgop)
   c:RegisterEffect(e3)
   c32900004.banish_effect=e3
end
function c32900004.thfilter1(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c32900004.thfilter2(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32900004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32900004.ththfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32900004.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32900004.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    local sg=Duel.GetMatchingGroup(c32900004.thfilter2,tp,LOCATION_DECK,0,nil)
    if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(32900004,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        g:AddCard(sg:Select(tp,1,1,nil):GetFirst())
    end
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c32900004.thfilter3(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32900004.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32900004.thfilter3,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c32900004.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32900004.thfilter3),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
    if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,tc)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(c32900004.sumlimit)
        e1:SetLabel(tc:GetCode())
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        Duel.RegisterEffect(e2,tp)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_MSET)
        Duel.RegisterEffect(e3,tp)
    end
end
function c32900004.sumlimit(e,c)
    return c:IsCode(e:GetLabel())
end
function c32900004.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c32900004.tgfilter(c)
    return c:IsSetCard(0x13b) and not c:IsCode(32900004) and c:IsAbleToGrave()
end
function c32900004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c32900004.tgfilter,tp,LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c32900004.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c32900004.tgfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        Duel.SendtoGrave(g1,REASON_EFFECT)
    end
end