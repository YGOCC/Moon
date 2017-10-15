--Tranquil Puriela, of Virtue
function c9945365.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(9945365)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9945365)
	e1:SetCondition(c9945365.spcon)
	e1:SetOperation(c9945365.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945365,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9945366)
	e2:SetCost(c9945365.cost)
	e2:SetTarget(c9945365.target)
	e2:SetOperation(c9945365.operation)
	c:RegisterEffect(e2)
	--Change Card Type
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9945365,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9945367)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9945365.ctcon)
	e3:SetTarget(c9945365.cttg)
	e3:SetOperation(c9945365.ctop)
	c:RegisterEffect(e3)
end
function c9945365.spfilter1(c)
	return c:IsSetCard(0x204F) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
	and Duel.IsExistingMatchingCard(c9945365.spfilter2,tp,LOCATION_GRAVE,0,1,c,c)
end
function c9945365.spfilter2(c)
	return c:IsSetCard(0x2050) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9945365.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9945365.spfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c9945365.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c9945365.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c9945365.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1,true)
end
function c9945365.cfilter(c)
	return c:IsSetCard(0x204F) and c:IsAbleToRemoveAsCost()
end
function c9945365.thfilter(c)
	return c:IsSetCard(0x204F) and c:IsType(TYPE_RITUAL)
end
function c9945365.tdfilter(c)
	return c:IsSetCard(0x204F) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c9945365.spfilter(c,e,tp)
	return c:IsSetCard(0x204F) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945365.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945365.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9945365.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9945365.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945365.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9945365.tdfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9945365.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g:GetFirst())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9945365.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9945365.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tg=Duel.GetMatchingGroup(c9945365.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and tg and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9945365,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,c9945365.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
					local tc=tg:GetFirst()
					if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
					local fid=e:GetHandler():GetFieldID()
					tc:RegisterFlagEffect(9945365,RESET_EVENT+0x1fe0000,0,1,fid)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetLabel(fid)
					e1:SetLabelObject(tc)
					e1:SetCondition(c9945365.recon)
					e1:SetOperation(c9945365.reop)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
end
function c9945365.recon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9945365)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9945365.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_EFFECT)
end
function c9945365.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c9945365.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x204F)
end
function c9945365.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9945365.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9945365.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectTarget(tp,c9945365.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9945365.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_TUNER) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e1)
		else
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e2)
		end
	end
end