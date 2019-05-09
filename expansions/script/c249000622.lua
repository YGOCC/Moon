--Spell-Disciple Gravity Sorcerer
function c249000622.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000622.spcon)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,249000622)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c249000622.cost)
	e2:SetTarget(c249000622.sptg2)
	e2:SetOperation(c249000622.spop2)
	c:RegisterEffect(e2)
end
function c249000622.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c249000622.costfilter(c)
	return c:IsSetCard(0x1D9) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000622.costfilter2(c)
	return c:IsSetCard(0x1D9) and not c:IsPublic()
end
function c249000622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000622.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000622.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000622.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000622.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000622.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000622.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		local g=Duel.SelectMatchingCard(tp,c249000622.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000622.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000622.filter(c,e,tp)
	return (not c:IsReason(REASON_RULE)) and c:IsRace(RACE_SPELLCASTER) and 
	c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000622.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c249000622.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c249000622.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:FilterSelect(tp,c249000622.filter,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end