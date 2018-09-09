--Subzero Crystal - Guardian Ecentramite
function c88890002.initial_effect(c)
    c:EnableReviveLimit()
    --(1) Special Summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c88890002.splimit)
    c:RegisterEffect(e1)
    --(2) add to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c88890002.condition)
    e2:SetCost(c88890002.cost)
    e2:SetTarget(c88890002.target)
    e2:SetOperation(c88890002.opperation)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetRange(LOCATION_SZONE)
    c:RegisterEffect(e3)
    --(3) Pay or Destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(88890002,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c88890002.paycon)
    e4:SetOperation(c88890002.payop)
    c:RegisterEffect(e4)
    --(4) To hand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(88890002,2))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_HAND)
    e5:SetCost(c88890002.thcost)
    e5:SetTarget(c88890002.thtg)
    e5:SetOperation(c88890002.thop)
    c:RegisterEffect(e5)
    --(5) Place in S/T Zone
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e6:SetCondition(c88890002.stzcon)
    e6:SetOperation(c88890002.stzop)
    c:RegisterEffect(e6)
    --(7) add
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(88890002,4))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetCondition(c88890002.thcon)
    e7:SetTarget(c88890002.thtg1)
    e7:SetOperation(c88890002.thop1)
    c:RegisterEffect(e7)
end
--(1) Special Summon condition
function c88890002.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x902)
end
--(2) add to hand
function c88890002.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or (c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS))
end
function c88890002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(88890002)<=0 end
    c:RegisterFlagEffect(88890002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
end
function c88890002.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
        local g=Duel.GetDecktopGroup(tp,3)
        local chkcount=g:Filter(Card.IsAbleToHand,nil)
        return chkcount:GetCount()>0
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c88890002.operation(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.ConfirmDecktop(p,3)
    local g=Duel.GetDecktopGroup(p,3)
    if g:GetCount()>0 then
        --set damage param
        local dg=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
        Duel.ConfirmCards(1-p,g)
        Duel.ShuffleDeck(p)
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
        local tg=g:Select(1-p,1,1,nil)
        local tc=tg:GetFirst()
        if tc:IsAbleToHand() then
            Duel.SendtoHand(tg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-p,tc)
            Duel.ShuffleHand(p)
        else
            Duel.SendtoGrave(tc,REASON_RULE)
        end
        Duel.ShuffleDeck(p)
        if dg>0 then
            Duel.Damage(1-p,dg*500,REASON_EFFECT)
        end
    end
end
--(3) Pay or Destroy
function c88890002.paycon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890002.payop(e,tp,eg,ep,ev,re,r,rp)
    Duel.HintSelection(Group.FromCards(e:GetHandler()))
    if Duel.CheckLPCost(tp,600) and Duel.SelectYesNo(tp,aux.Stringid(88890002,1)) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890002,5))
        Duel.PayLPCost(tp,600)
    else
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890002,6))
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
--(4) To hand
function c88890002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890002.thfilter(c)
    return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890002.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890002.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(5) Place in S/T Zone
function c88890002.stzcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890002.stzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --Continuous Spell
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.RaiseEvent(c,EVENT_CUSTOM+88890010,e,0,tp,0,0)
end
--(7) add
function c88890002.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890002.thfilter1(c)
    return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890002.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890002.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890002.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890002.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end