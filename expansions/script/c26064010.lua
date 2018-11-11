--Over-wind Fluctuation
function c26064010.initial_effect(c)
--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c26064010.target)
    c:RegisterEffect(e1)
--indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(c26064010.indfilter)
    e2:SetValue(c26064010.indct)
    c:RegisterEffect(e2)
--singularity
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(26064010)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(1,1)
    c:RegisterEffect(e3)
end
function c26064010.indfilter(e,c)
    return c:IsFaceup() and c:IsSetCard(0x664)
end
function c26064010.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
        return 1
    else return 0 end
end
function c26064010.filter(c)
    return c:IsFacedown() and c:IsSetCard(0x664)
end
function c26064010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
    if chk==0 then return true end
    if Duel.IsExistingTarget(c26064010.filter,tp,LOCATION_MZONE,0,1,nil)
    and Duel.IsExistingTarget(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(26064010,0)) then
        e:SetCategory(CATEGORY_POSITION)
        e:SetOperation(c26064010.activate)
        Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
    else
        e:SetCategory(0)
        e:SetProperty(0)
        e:SetOperation(nil)
    end
end
function c26064010.activate(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(c26064010.filter,tp,LOCATION_MZONE,0,nil)
    local g2=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
    local gc1,gc2=g1:GetCount(),g2:GetCount()
    local gc=math.min(gc1,gc2)
    if gc>0 then
        tg1=g1:Select(tp,1,gc,nil)
        Duel.ChangePosition(tg1,POS_FACEUP_DEFENSE)
        tgc=tg1:GetCount()
        Duel.BreakEffect()
        tg2=g2:Select(tp,tgc,tgc,nil)
        Duel.ChangePosition(tg2,POS_FACEDOWN_DEFENSE)
    end
end