--Greenbloom
local ref=_G['c'..28915107]
local id=28915107
function ref.initial_effect(c)
	--Corona Card
	--aux.EnableCorona(c,ref.matfilter,3,99,TYPE_MONSTER+TYPE_EFFECT,ref.refilter)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter,ref.matfilter2)
	--NS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--ToGrave
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,id)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
function ref.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function ref.matfilter2(c)
	return c:IsLevelBelow(3)
end

--Summon
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,15341822,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND) then return end
	local i=e:GetLabel()
	local token=Duel.CreateToken(tp,15341821+i)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()
end
