--Over-wind singularity
function c26064008.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_DRAW)
    e1:SetCondition(c26064008.regcon)
    e1:SetOperation(c26064008.regop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e2:SetCondition(c26064008.qpcond)
    c:RegisterEffect(e2)
--search
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH)
    e3:SetDescription(aux.Stringid(26064008,1))
    e3:SetCountLimit(1,26064008)
    e3:SetCost(c26064008.cost)
    e3:SetTarget(c26064008.target)
    e3:SetOperation(c26064008.activate)
    c:RegisterEffect(e3)
--draw
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetDescription(aux.Stringid(26064008,2))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetCountLimit(1,26064007)
    e4:SetLabel(3)
    e4:SetCondition(c26064008.e1cond)
    e4:SetCost(c26064008.cost)
    e4:SetTarget(c26064008.e1tg)
    e4:SetOperation(c26064008.e1op)
    c:RegisterEffect(e4)
--to hand/Leap
    local e5=e4:Clone()
    e5:SetType(EFFECT_TYPE_ACTIVATE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetDescription(aux.Stringid(26064008,3))
    e5:SetCountLimit(1,26064009)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetLabel(6)
    e5:SetCondition(c26064008.e2cond)
    e5:SetTarget(c26064008.e2tg)
    e5:SetOperation(c26064008.e2op)
    c:RegisterEffect(e5)
--slow down/Fluctuation
    local e6=e4:Clone()
    e6:SetDescription(aux.Stringid(26064008,4))
    e6:SetCode(EVENT_CHAINING)
    e6:SetCategory(CATEGORY_TODECK)
    e6:SetCountLimit(1,26064010)
    e6:SetLabel(12)
    e6:SetCondition(c26064008.e3cond)
    e6:SetTarget(c26064008.e3tg)
    e6:SetOperation(c26064008.e3op)
    c:RegisterEffect(e6)
--flip down/Accel
    local e7=e4:Clone()
    e7:SetDescription(aux.Stringid(26064008,5))
    e7:SetCategory(CATEGORY_POSITION)
    e7:SetCountLimit(1,26064011)
    e7:SetLabel(0)
    e7:SetCondition(c26064008.e4cond)
    e7:SetTarget(c26064008.e4tg)
    e7:SetOperation(c26064008.e4op)
    c:RegisterEffect(e7)
--Draw overflow
    local e8=e4:Clone()
    e8:SetCode(EVENT_DRAW)
    e8:SetDescription(aux.Stringid(26064008,6))
    e8:SetLabel(50)
    e8:SetCountLimit(1,26064007)
    e8:SetCondition(c26064008.e5cond)
    e8:SetTarget(c26064008.e5tg)
    e8:SetOperation(c26064008.e5op)
    c:RegisterEffect(e8)
end
function c26064008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26064008.filter(c)
    return c:IsSetCard(0x664) and not c:IsCode(26064008) and c:IsAbleToHand()
end
function c26064008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26064008.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26064008.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c26064008.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c26064008.regcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPublic()
end
function c26064008.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetTurnCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(26064008,0)) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
    end
end
function c26064008.ctfilter(c,ctv)
    return c:GetCounter(0xb6)>=ctv
end
function c26064008.qpcond(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and e:GetHandler():IsPublic()
end
function c26064008.e1cond(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,26064007)
end
function c26064008.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ctv=e:GetLabel()
    if chk==0 then return Duel.IsExistingTarget(c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,ctv) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil,ctv)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064008.e1op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local ct=e:GetLabel()
    if ct>0 then
        tc:RemoveCounter(tp,0xb6,ct,REASON_EFFECT)
        local gp=Duel.GetTurnPlayer()
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Draw(p,d,REASON_EFFECT)
    end
end
function c26064008.e2cond(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,26064009)
end
function c26064008.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ctv=e:GetLabel()
    if chk==0 then return Duel.IsExistingTarget(c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,ctv) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil,ctv)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c26064008.e2op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local ct=e:GetLabel()
    if ct>0 then
        tc:RemoveCounter(tp,0xb6,ct,REASON_EFFECT)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
        if g:GetCount()>0 then
            tg=g:GetFirst()
            Duel.SendtoHand(tg,nil,REASON_EFFECT)
        end
    end
end
function c26064008.e3cond(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.IsPlayerAffectedByEffect(tp,26064010)
end
function c26064008.e3filter(c)
    return c:IsSetCard(0x664) and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_TRAP+TYPE_CONTINUOUS)) and c:IsCanTurnSet()
end
function c26064008.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ctv=e:GetLabel()
    if chk==0 then return Duel.IsExistingTarget(c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,ctv) and Duel.IsExistingMatchingCard(c26064008.e3filter,rp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil,ctv)
end
function c26064008.e3op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local ct=e:GetLabel()
    if ct>0 then
        tc:RemoveCounter(tp,0xb6,ct,REASON_EFFECT)
        local g=Group.CreateGroup()
        Duel.ChangeTargetCard(ev,g)
        Duel.ChangeChainOperation(ev,c26064008.repop)
    end
end
function c26064008.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
        c:CancelToGrave(false)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil,e)
    if g:GetCount()>0 then
        tg=g:GetFirst()
        Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
        Duel.RegisterEffect(e1,tp)
    end
end
function c26064008.e4cond(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,26064011)
end
function c26064008.e4filter(c)
    return c:IsCanTurnSet() and c:IsSetCard(0x664) and
        (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5))
end
function c26064008.e4pfilter(c)
    return c:IsFaceup() and c:IsCode(26064007) and c:IsCanAddCounter(0xb6,1)
end
function c26064008.e4tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    ctv=e:GetLabel()
    if chk==0 then return Duel.IsExistingTarget(c26064008.e4pfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ctv) and Duel.IsExistingMatchingCard(c26064008.e4filter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c26064008.e4pfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil,ctv)
end
function c26064008.e4op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local g=Duel.GetMatchingGroup(c26064008.e4filter,tp,LOCATION_ONFIELD,0,e:GetHandler(),tc)
    local gc=g:GetCount()
    if gc>0 then
        g1=g:Select(tp,1,gc,nil)
        tct=g1:GetCount()
        tg=g1:GetFirst()
        while tg do
            local s1=tg:IsType(TYPE_MONSTER)
            if s1 then
                Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
            else
                Duel.ChangePosition(tg,POS_FACEDOWN)
            end
            tg=g1:GetNext()
        end
        Duel.BreakEffect()
        tc:AddCounter(0xb6,tct)
    end
end
function c26064008.e5cond(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c26064008.e5tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ctv=e:GetLabel()
    if chk==0 then return Duel.IsExistingTarget(c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,ctv) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_SKIP_TURN) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c26064008.ctfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil,ctv)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
    
end
function c26064008.e5op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local sct=tc:GetCounter(0xb6)
    local dct=0
    if sct>0 then
        while sct>dct*2 do
            if sct>=2 then
                dct=dct+1
            end
        end
        tc:RemoveCounter(tp,0xb6,sct,REASON_EFFECT)
        local gp=Duel.GetTurnPlayer()
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Draw(p,dct,REASON_EFFECT)
    end
end