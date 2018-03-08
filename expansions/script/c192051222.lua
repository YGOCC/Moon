--coded by Lyris
--Steelus Toxicatem Ultima
function c192051222.initial_effect(c)
	c:EnableReviveLimit()
	--2: Level/Rank 3 EARTH, Level/Rank 6 Dragon
	aux.AddEvoluteProc(c,9,c192051222.mfilter1,c192051222.mfilter2)
	--If this card is Evolute Summoned using "Steelus Colarium", put 3 more E-Counters on it.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c192051222.matcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c192051222.tgcon)
	e2:SetOperation(c192051222.tgop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Once per turn: You can remove 3 E-Counters from this card; Place 1 Toxic Counter on all monsters your opponent controls.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c192051222.ctcost)
	e3:SetTarget(c192051222.cttg)
	e3:SetOperation(c192051222.ctop)
	c:RegisterEffect(e3)
	--When this card leaves the field, destroy all monsters with Toxic Counters on them, and if you do, inflict 400 damage to your opponent for each monster destroyed by this effect.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c192051222.desop)
	c:RegisterEffect(e4)
end
function c192051222.mfilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and aux.EvoluteValue(c)==3
end
function c192051222.mfilter2(c)
	return c:IsRace(RACE_DRAGON) and aux.EvoluteValue(c)==6
end
function c192051222.matcheck(e,c)
	e:SetLabel(0)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,192051209) then e:SetLabel(3) end
end
function c192051222.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c192051222.tgop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(388,RESET_EVENT+0x1ff0000,0,1,e:GetLabelObject():GetLabel())
end
function c192051222.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1088)>=3 end
	e:GetHandler():RemoveCounter(tp,0x1088,3,REASON_COST)
end
function c192051222.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c192051222.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1b9b,1)
		tc=g:GetNext()
	end
end
function c192051222.filter(c)
	return c:GetCounter(0x1b9b)>0
end
function c192051222.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c192051222.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(tp,ct*400,REASON_EFFECT)
	end
end
