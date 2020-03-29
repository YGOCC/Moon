--Legendary Shark
local cid,id=GetID()
function cid.initial_effect(c)
	 aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
 aux.AddEvoluteProc(c,nil,5,cid.filter1,cid.filter2,2,99)  

--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,id)
	e0:SetCondition(cid.hspcon)
	e0:SetOperation(cid.hspop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+388)
	c:RegisterEffect(e0)
  --immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cid.econ)
	e1:SetValue(cid.efilter)
	c:RegisterEffect(e1)
end
function cid.econ(e)
	return Duel.IsEnvironment(22702055)
end

function cid.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cid.filter2(c,ec,tp)
	return c:IsRace(RACE_AQUA+RACE_FISH+RACE_SEASERPENT)
end

function cid.spfilter(c)
	return c:IsFaceup() and c:GetOriginalLevel() => 5  and c:IsAttribute(ATTRIBUTE_WATER) 
end
function cid.check()
	return Duel.IsEnvironment(22702055)
end
function cid.hspcon(e,c)
  if c==nil then return true end
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_MZONE,0,1,nil)  and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and cid.check()
end
function cid.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
