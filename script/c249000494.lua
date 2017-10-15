--Chroma-Distortion Xyz Distorter
function c249000494.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,249000494)
	e1:SetCost(c249000494.cost)
	e1:SetOperation(c249000494.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c249000494.costfilter(c)
	return c:IsSetCard(0x1C4) and c:IsAbleToRemoveAsCost()
end
function c249000494.costfilter2(c,e)
	return c:IsSetCard(0x1C4) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000494.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000494.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000494.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000494.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000494.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000494.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000494.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000494.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000494.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000494.filterx(c)
	return c:IsType(TYPE_XYZ) and c:GetRank() < 12 and c.minxyzct and not (c:IsRace(RACE_WINDBEAST) and c:GetRank()==10)
end
function c249000494.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c249000494.filterx,c:GetControler(),LOCATION_EXTRA,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(1063)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetValue(SUMMON_TYPE_XYZ)
		e1:SetCondition(c249000494.xyzcon)
		e1:SetOperation(c249000494.xyzop)
		e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()	
	end
end
function c249000494.mfilter(c,rk)
	return c:GetLevel() < rk and c:GetLevel() > 0 and not (c:IsFacedown() and c:IsLocation(LOCATION_MZONE))
end
function c249000494.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rk=c:GetRank()
	local mg=Duel.GetMatchingGroup(c249000494.mfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,rk)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:CheckWithSumEqual(Card.GetLevel,rk,c.minxyzct,c.minxyzct,c)
end
function c249000494.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local mg=Duel.GetMatchingGroup(c249000494.mfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,rk)
	local g1=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:SelectWithSumEqual(tp,Card.GetLevel,rk,c.minxyzct,c.minxyzct,c)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end