--Codeman: Icicle Swordsman
function c1020021.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1020021,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c1020021.cost)
	e1:SetOperation(c1020021.operation)
	e1:SetCountLimit(1,1020021)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--LV Modulate
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1020021.target)
	e3:SetCountLimit(1,1020021)
	e3:SetOperation(c1020021.activate)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1020021,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c1020021.spcost)
	e4:SetTarget(c1020021.sptarget)
	e4:SetOperation(c1020021.spoperation)
	e4:SetCountLimit(1,1020021)
	c:RegisterEffect(e4)
end
function c1020021.csfilter(c)
	return c:IsSetCard(0x1ded) and c:IsType(TYPE_MONSTER) and not c:IsCode(1020021) and c:IsAbleToGraveAsCost()
end
function c1020021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1020021.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c1020021.csfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c1020021.tgfilter(c)
	return c:IsSetCard(0x1ded) and c:IsType(TYPE_MONSTER) and c:GetLevel()==7 and c:IsAbleToGraveAsCost()
end
function c1020021.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c1020021.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
				local c=g:GetFirst()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(4)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e1)
			end
		end
	end
end
function c1020021.filter(c)
	return c:IsFaceup() and c:GetLevel()>=5 and not c:IsStatus(STATUS_NO_LEVEL)
end
function c1020021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1020021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1020021.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
	e:SetLabel(lv)
end
function c1020021.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local g=Duel.GetMatchingGroup(c1020021.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
end
function c1020021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c1020021.spfilter(c,e,sp)
	return c:IsSetCard(0x1ded) and c:GetLevel()==3 and not c:IsCode(1020021) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c1020021.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020021.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1020021.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.SelectMatchingCard(tp,c1020021.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sc~=nil then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end