--Over-Wind Rasmus
function c26064003.initial_effect(c)
--flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26064001,1))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(c26064003.fltg)
    e1:SetOperation(c26064003.flipop)
    c:RegisterEffect(e1)
--flip
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetOperation(c26064003.flip)
    c:RegisterEffect(e2)
--leave field
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26064001,2))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c26064003.setcon1)
    e3:SetTarget(c26064003.settg)
    e3:SetOperation(c26064003.setop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(c26064003.setcon2)
    c:RegisterEffect(e4)
--tribute set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26064003,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_PROC)
    e1:SetCondition(c26064003.otcon)
    c:RegisterEffect(e1)
end
function c26064003.otcon(e,c,minc)
    if c==nil then return true end
    return c:GetLevel()>4 and minc<=1
end
function c26064003.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if e:GetHandler():GetFlagEffect(26064004)~=0 then
        Duel.SetChainLimit(aux.FALSE)
        Duel.Hint(HINT_CARD,0,26064004)
    end
end
function c26064003.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x664)
    if c:IsSummonType(SUMMON_TYPE_ADVANCE) then
        g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil,c)
    end
    if g:GetCount()>0 then 
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064003,1))
        local sg=g:Select(tp,1,1,nil)
        tg=sg:GetFirst()
        if tg then
            Duel.ShuffleDeck(tp)
            Duel.MoveSequence(tg,0)
            Duel.ConfirmDecktop(tp,1)
        end
    end
end
function c26064003.flip(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():RegisterFlagEffect(26064003,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064003.setcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064003.setcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064003.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c26064003.setfilter,tp,LOCATION_HAND,0,1,nil,tp) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064003.setfilter(c)
    return c:IsMSetable(true,nil) or c:IsSSetable()
end
function c26064003.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cc=00
    local g=Duel.GetMatchingGroup(c26064003.setfilter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()>0 and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,527)
        local sg=g:Select(tp,1,2,nil)
        local tc=sg:GetFirst()
        while tc do
            local s1=tc:IsMSetable(true,nil)
            local s2=tc:IsSSetable()
            if (s1 and s2) or not s2 then
                Duel.MSet(tp,tc,true,nil)
                cc=cc+01
            else
                Duel.SSet(tp,tc)
                cc=cc+10
            end
            tc=sg:GetNext()
        end
        Duel.BreakEffect()
        if cc==11 then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end