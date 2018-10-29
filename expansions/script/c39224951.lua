--Grimheart Oracle
--Design by Reverie
--Script by NightcoreJack
function c39224951.initial_effect(c)
    --normal summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(39224951,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c39224951.otcon)
    e1:SetOperation(c39224951.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    --copy effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(39224951,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,39224951)
    e2:SetCost(c39224951.cpcost)
    e2:SetTarget(c39224951.cptg)
    e2:SetOperation(c39224951.cpop)
    c:RegisterEffect(e2)
     --cannot be target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.tgoval)
    e3:SetCondition(c39224951.tgcon)
    c:RegisterEffect(e3)
    --Activate
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(39224951,2))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,39224961)
    e4:SetCost(c39224951.tgcost)
    e4:SetTarget(c39224951.tgtg)
    e4:SetOperation(c39224951.tgop)
    c:RegisterEffect(e4)
    Duel.AddCustomActivityCounter(39224951,ACTIVITY_CHAIN,c39224951.chainfilter)
end
function c39224951.chainfilter(re,tp,cid)
    return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x37f))
end
function c39224951.otfilter(c,tp)
    return c:IsSetCard(0x37f) and (c:IsControler(tp) or c:IsFaceup())
end
function c39224951.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c39224951.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c39224951.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c39224951.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)
end
function c39224951.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x37f)
end
function c39224951.tgcon(e)
    return Duel.IsExistingMatchingCard(c39224951.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c39224951.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(39224951,tp,ACTIVITY_CHAIN)>0 end
end
function c39224951.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c39224951.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
        local sg=g:Select(1-tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.SendtoGrave(sg,REASON_RULE)
    end
end
function c39224951.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c39224951.cpfilter(c)
    return c:IsSetCard(0x37f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:CheckActivateEffect(true,true,false)~=nil
end
function c39224951.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        local tc=e:GetLabelObject()
        local tg=tc:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
    end
    if chk==0 then return Duel.IsExistingTarget(c39224951.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c39224951.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
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
function c39224951.cpop(e,tp,eg,ep,ev,re,r,rp)
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