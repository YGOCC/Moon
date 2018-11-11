--Synodic Over-wind Ruler - Lustrum
function c26064004.initial_effect(c)
    c:EnableReviveLimit()
--flip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(c26064004.fliptg)
    e1:SetOperation(c26064004.flipop)
    c:RegisterEffect(e1)
--flip
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetOperation(c26064004.flip)
    c:RegisterEffect(e2)
--search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26064004,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DRAW)
    e3:SetCost(c26064004.thcost)
    e3:SetTarget(c26064004.thtg)
    e3:SetOperation(c26064004.thop)
    c:RegisterEffect(e3)
--leave field
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c26064004.setcon1)
    e3:SetTarget(c26064004.fltg)
    e3:SetOperation(c26064004.flop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(c26064004.setcon2)
    c:RegisterEffect(e4)
end
function c26064004.flip(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():RegisterFlagEffect(26064001,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064004.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c26064004.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local gp=Duel.GetTurnPlayer()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    if gp~=tp and Duel.SelectYesNo(tp,aux.Stringid(26064004,0)) then 
        if     Duel.GetCurrentPhase()==PHASE_MAIN1 then
            Duel.SkipPhase(gp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) return
        elseif Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE then
            Duel.SkipPhase(gp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1,1) return
        elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
            Duel.SkipPhase(gp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1) return
        end
    end
end
function c26064004.setcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064004.setcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064004.filter(c,e,sp)
    return c:IsCode(26064006) and c:IsAbleToHand()
end
function c26064004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26064004.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    if e:GetHandler():GetFlagEffect(26064004)~=0 then
        Duel.SetChainLimit(aux.FALSE)
    end
end
function c26064004.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26064004.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c26064004.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsFacedown() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
    local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function c26064004.flop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFacedown() then
        Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
        if tc:IsSetCard(0x664) then
            tc:RegisterFlagEffect(26064004,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        end
    end
end