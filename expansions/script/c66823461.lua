--Dokurorider's Jade Contract
--Script by TaxingCorn117
function c66823461.initial_effect(c)
    aux.AddRitualProcGreater(c,c66823461.ritual_filter)
	--destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(c66823461.reptg)
    e2:SetValue(c66823461.repval)
    e2:SetOperation(c66823461.repop)
    c:RegisterEffect(e2)
end
--filters
function c66823461.ritual_filter(c)
    return c:IsType(TYPE_RITUAL) and (c:IsCode(99721536) or c:IsSetCard(0x1e0))
end
function c66823461.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (c:IsCode(99721536) or  c:IsSetCard(0x1e0))
        and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
--
function c66823461.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c66823461.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c66823461.repval(e,c)
    return c66823461.repfilter(c,e:GetHandlerPlayer())
end
function c66823461.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end