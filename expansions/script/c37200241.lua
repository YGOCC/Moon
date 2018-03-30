--Brain Washing
--Script by XGlitchy30
function c37200241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c37200241.cttg)
	e1:SetOperation(c37200241.ctop)
	c:RegisterEffect(e1)
end
--filters
function c37200241.ctfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:IsDefenseBelow(1000)
end
function c37200241.targetchk(c,tg)
	return c==tg and c:IsFaceup()
end
function c37200241.spfilter(c,e,tp,typ,lv)
	return (c:IsLocation(LOCATION_DECK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetRace()==typ and c:GetLevel()==lv)
		or (c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp)>0 and c:GetRace()==typ and c:GetLevel()==lv)
end
--Activate
function c37200241.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c37200241.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c37200241.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c37200241.tcfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c37200241.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		e:GetHandler():RegisterFlagEffect(37200241,RESET_PHASE+PHASE_END,0,0)
		if Duel.GetControl(tc,tp)~=0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetLabelObject(tc)
			e2:SetCondition(c37200241.spcon)
			e2:SetCost(c37200241.spcost)
			e2:SetTarget(c37200241.sptg)
			e2:SetOperation(c37200241.spop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
--special summon
function c37200241.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	return Duel.IsExistingMatchingCard(c37200241.targetchk,tp,LOCATION_MZONE,0,1,nil,tg) and e:GetHandler():GetFlagEffect(37200241)>0
end
function c37200241.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c37200241.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetLabelObject()
	local typ=tg:GetRace()
	local lv=tg:GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c37200241.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,typ,lv) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c37200241.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local typ=tg:GetRace()
	local lv=tg:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37200241.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,typ,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
	