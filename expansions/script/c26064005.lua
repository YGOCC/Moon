--Sidereal Over-wind Marshall - Saeculum
function c26064005.initial_effect(c)
    c:EnableReviveLimit()
--flip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(c26064005.fliptg)
    e1:SetOperation(c26064005.flipop)
    c:RegisterEffect(e1)
--flip
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetOperation(c26064005.flip)
    c:RegisterEffect(e2)
--search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26064005,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DRAW)
    e3:SetCost(c26064005.thcost)
    e3:SetTarget(c26064005.thtg)
    e3:SetOperation(c26064005.thop)
    c:RegisterEffect(e3)
--leave field
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c26064005.setcon1)
    e3:SetOperation(c26064005.setop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(c26064005.setcon2)
    c:RegisterEffect(e4)
end
function c26064005.flip(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():RegisterFlagEffect(26064001,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    if c:GetFlagEffect(26064004)~=0 then
        Duel.SetChainLimit(aux.FALSE)
        Duel.Hint(HINT_CARD,0,26064004)
    end
end
function c26064005.topfilter(c)
    return c:IsAbleToDeck() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c26064005.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local gp=Duel.GetTurnPlayer()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    local g=Duel.GetMatchingGroup(c26064005.topfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,c)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=g:Select(tp,1,1,nil)
        Duel.ConfirmCards(1-tp,sg)
        tg=sg:GetFirst()
        if tg and Duel.SendtoDeck(tg,nil,0,REASON_EFFECT) and gp~=tp and Duel.SelectYesNo(tp,aux.Stringid(26064005,0)) then 
            Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
            Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
            Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
            Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
            Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_CANNOT_BP)
            e1:SetTargetRange(0,1)
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function c26064005.setcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064005.setcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064005.filter(c,e,sp)
    return c:IsSetCard(0x664) and c:IsAbleToHand()
end
function c26064005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26064005.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c26064005.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectTarget(tp,c26064005.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c26064005.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c26064005.thfilter(c)
    return c:IsFaceup() and not c:IsSetCard(0x664) and c:IsAbleToHand()
end
function c26064005.setop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c26064005.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
end