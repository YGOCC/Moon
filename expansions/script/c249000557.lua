--Transcended Reverser
function c249000557.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--revive
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000557,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,249000557)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c249000557.sumcon)
	e1:SetCost(c249000557.sumcost)
	e1:SetTarget(c249000557.sumtg)
	e1:SetOperation(c249000557.sumop)
	c:RegisterEffect(e1)
end
function c249000557.ctfilter(c)
	return c:IsSetCard(0x1CD) and c:IsType(TYPE_MONSTER)
end
function c249000557.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000557.ctfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000557.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c249000557.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000557.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c249000557.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000557.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000557.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000557.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 and tc:IsType(TYPE_XYZ) then
			Duel.Overlay(tc,tc2)
		end 
	end
end