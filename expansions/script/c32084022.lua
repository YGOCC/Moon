--Dark Hyde
function c32084022.initial_effect(c)
	c:EnableUnsummonable()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c32084022.spcon)
	e1:SetOperation(c32084022.spop)
	c:RegisterEffect(e1)
		--avoid damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c32084022.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e7)
end
function c32084022.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),500)
end
function c32084022.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c32084022.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end