--Grimheart Priestess
--Design by Reverie
--Script by NightcoreJack
function c39224954.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(39224954,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,39224954)
    e1:SetCost(c39224954.spcost)
    e1:SetTarget(c39224954.sptg)
    e1:SetOperation(c39224954.spop)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(39224954,ACTIVITY_CHAIN,c39224954.chainfilter)
    --copy effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(39224954,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,39224964)
    e2:SetCost(c39224954.cpcost)
    e2:SetTarget(c39224954.cptg)
    e2:SetOperation(c39224954.cpop)
    c:RegisterEffect(e2)
end
function c39224954.chainfilter(re,tp,cid)
    return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x37f))
end
function c39224954.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(39224954,tp,ACTIVITY_CHAIN)>0 end
end
function c39224954.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0x37f) and not c:IsCode(39224954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c39224954.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c39224954.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c39224954.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tg=Duel.SelectMatchingCard(tp,c39224954.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
    if tg then
        Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
function c39224954.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c39224954.cpfilter(c)
    return c:IsSetCard(0x37f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:CheckActivateEffect(true,true,false)~=nil
end
function c39224954.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        local tc=e:GetLabelObject()
        local tg=tc:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
    end
    if chk==0 then return Duel.IsExistingTarget(c39224954.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c39224954.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
    Duel.ClearTargetCard()
    g:GetFirst():CreateEffectRelation(e)
    local tg=tc:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    tc:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(tc)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c39224954.cpop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if not tc then return end
    if not tc:GetHandler():IsRelateToEffect(e) then return end
    e:SetLabelObject(tc:GetLabelObject())
    local op=tc:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
    Duel.BreakEffect()
    Duel.SSet(tp,tc:GetHandler())
        Duel.ConfirmCards(1-tp,tc:GetHandler())
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        tc:GetHandler():RegisterEffect(e1,tc:GetHandler())
end