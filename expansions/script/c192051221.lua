--coded by Lyris
--Steelus Toxicatem
function c192051221.initial_effect(c)
	c:EnableReviveLimit()
	--2: Level/Rank 3 EARTH, Level/Rank 3 Dragon
	aux.AddEvoluteProc(c,6,c192051221.mfilter1,c192051221.mfilter2)
	--If this card was Evolute Summoned using "Steelus Colarium", place 2 more E-Counters on it.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c192051221.matcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c192051221.tgcon)
	e2:SetOperation(c192051221.tgop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--During each of your Standby Phases: Monsters your opponent controls gain 500 ATK and DEF. During each of your opponent's Standby Phases: monsters they control lose 700 ATK and DEF.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetOperation(c192051221.atkop)
	c:RegisterEffect(e3)
	--During each of your End Phases: Remove one E-Counter from this card.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c192051221.rmcon)
	e4:SetOperation(c192051221.rmop)
	c:RegisterEffect(e4)
	--Negate this card's effects while it has no E-Counters.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetCondition(function(e) return e:GetHandler():GetCounter(0x1088)==0 end)
	c:RegisterEffect(e5)
end
function c192051221.mfilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and aux.EvoluteValue(c)==3
end
function c192051221.mfilter2(c)
	return c:IsRace(RACE_DRAGON) and aux.EvoluteValue(c)==3
end
function c192051221.matcheck(e,c)
	e:SetLabel(0)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,192051209) then e:SetLabel(2) end
end
function c192051221.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c192051221.tgop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(388,RESET_EVENT+0x1ff0000,0,1,e:GetLabelObject():GetLabel())
end
function c192051221.atkop(e,tp,eg,ep,ev,re,r,rp)
	local val=500
	if Duel.GetTurnPlayer()~=tp then val=-700 end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c192051221.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c192051221.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x1088)>0 then c:RemoveCounter(tp,0x1088,1,REASON_EFFECT) end
end
