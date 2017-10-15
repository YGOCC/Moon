--Xyz-Knight-Summoner Darkness
function c249000664.initial_effect(c)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,249000664)
	e1:SetCost(c249000664.cost)
	e1:SetTarget(c249000664.target)
	e1:SetOperation(c249000664.operation)
	c:RegisterEffect(e1)
end
function c249000664.costfilter2(c)
	return c:IsSetCard(0x6073) and not c:IsPublic()
end
function c249000664.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000664.costfilter2,tp,LOCATION_HAND,0,1,c)
		and c:IsAbleToRemoveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c249000664.costfilter2,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
end
function c249000664.filter1(c,e,tp)
	return c:IsSetCard(0x6073) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c249000664.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,c:GetOriginalAttribute(),e,tp) and not c:IsPublic()
end
function c249000664.filter2(c,att,e,tp)
	return c:GetOriginalLevel() > 0 and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c249000664.filter3,tp,LOCATION_EXTRA,0,1,nil,att,c:GetOriginalLevel()+2,e,tp)
end
function c249000664.filter3(c,att,rk,e,tp)
	return (c:GetRank()==rk or c:GetRank()==rk-1) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000664.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000664.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000664.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.SelectMatchingCard(tp,c249000664.filter2,tp,LOCATION_HAND,0,1,1,nil,e:GetLabel(),e,tp)
	if g1:GetCount() > 0 and Duel.SendtoGrave(g1,REASON_EFFECT) then
		local g2=Duel.SelectMatchingCard(tp,c249000664.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel(),g1:GetFirst():GetOriginalLevel()+2,e,tp)
		local sc=g2:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
			tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
			local e1=Effect.CreateEffect(sc)
			e1:SetDescription(aux.Stringid(88240808,0))
			e1:SetCategory(CATEGORY_REMOVE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
			e1:SetCode(EVENT_BATTLE_DAMAGE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(c249000664.rmcon)
			e1:SetTarget(c249000664.rmtg)
			e1:SetOperation(c249000664.rmop)
			sc:RegisterEffect(e1,true)
			if not sc:IsType(TYPE_EFFECT) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e2,true)
			end
			sc:CompleteProcedure()
		end
	end
end
function c249000664.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c249000664.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c249000664.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c249000664.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000664.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c249000664.filter,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c249000664.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end