--BF－黒槍のブラスト
function c15077703.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c15077703.spcon)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c15077703.atkcon)
    e2:SetOperation(c15077703.atkop)
    c:RegisterEffect(e2)
end

function c15077703.filter(c)
	return c:IsFaceup() and c:IsSetCard(341) and c:IsType(TYPE_SYNCHRO)
end
function c15077703.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c15077703.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c15077703.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO
end
function c15077703.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sync=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    sync:RegisterEffect(e1)
end