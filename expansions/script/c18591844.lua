--Light Of The Assassins - Kaiser
function c18591844.initial_effect(c)
    --Link summon
    aux.AddLinkProcedure(c,c18591844.matfilter,2)
    c:EnableReviveLimit()
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591844,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(1)
    e1:SetCondition(c18591844.reccon)
    e1:SetTarget(c18591844.rectg)
    e1:SetOperation(c18591844.recop)
    c:RegisterEffect(e1)
end
function c18591844.matfilter(c)
    return c:IsSetCard(0x50e)
end
function c18591844.reccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c18591844.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x50e)
end
function c18591844.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetMatchingGroupCount(c18591844.filter,tp,LOCATION_MZONE,0,nil)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct*500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c18591844.recop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(c18591844.filter,tp,LOCATION_MZONE,0,nil)
    Duel.Recover(tp,ct*500,REASON_EFFECT)
end
