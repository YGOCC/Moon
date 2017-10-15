--Sin & Virtue, Jibril
function c9945370.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c9945370.xyzcon)
	e1:SetOperation(c9945370.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945370,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG2_XMDETACH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9945370)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9945370.cost)
	e2:SetTarget(c9945370.target)
	e2:SetOperation(c9945370.operation)
	c:RegisterEffect(e2)
	--Special Summon/Send
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9945370,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG2_XMDETACH+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9945371)
	e3:SetCost(c9945370.spcost)
	e3:SetTarget(c9945370.sptg)
	e3:SetOperation(c9945370.spop)
	c:RegisterEffect(e3)
	--xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
end
c9945370.minxyzct=2
c9945370.maxxyzct=2
c9945370.maintain_overlay=true
function c9945370.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x204F) and c:IsType(TYPE_MONSTER)
end
function c9945370.ovfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x2050) and c:IsType(TYPE_MONSTER)
end	
function c9945370.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9945370.ovfilter1,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c9945370.ovfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c9945370.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945370.ovfilter1,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsExistingMatchingCard(c9945370.ovfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c9945370.ovfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c9945370.ovfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	og=Group.CreateGroup()
	og:Merge(g1)
	og:Merge(g2)
	if g1:GetCount()>0 then
		local mg1=g1:GetFirst():GetOverlayGroup()
		if mg1:GetCount()~=0 then
			og:Merge(mg1)
			Duel.Overlay(g2:GetFirst(),mg1)
		end
		Duel.Overlay(g2:GetFirst(),g1)
		local mg2=g2:GetFirst():GetOverlayGroup()
		if mg2:GetCount()~=0 then
			og:Merge(mg2)
			Duel.Overlay(c,mg2)
		end
		c:SetMaterial(og)
		Duel.Overlay(c,g2:GetFirst())	
	end
end
function c9945370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9945370.filter(c)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsAbleToHand()
end
function c9945370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945370.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9945370.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9945370.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9945370.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c9945370.spfilter(c,e,tp)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945370.tgfilter(c)
	return c:IsFaceup()
end
function c9945370.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c9945370.tgfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9945370.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c9945370.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectTarget(tp,c9945370.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9945370.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tcc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tcc:IsRelateToEffect(e) then
		e:GetHandler():SetCardTarget(tcc)
	local g=Duel.SelectMatchingCard(tp,c9945370.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(9945370,RESET_EVENT+0x1fe0000,0,1,fid)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c9945370.descon)
		e3:SetOperation(c9945370.desop)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.SpecialSummonComplete()
end
end
function c9945370.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9945370)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9945370.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	local tg=e:GetHandler():GetFirstCardTarget()
	Duel.Destroy(tc,REASON_EFFECT)
	if tg and tg:IsLocation(LOCATION_MZONE) and tg:IsAbleToGrave() 
		and c:IsLocation(LOCATION_MZONE) and c:IsAbleToGrave() then
		Duel.SendtoGrave(tg,REASON_EFFECT)
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end