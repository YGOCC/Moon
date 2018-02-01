--Flute of Mystical Elves
--Script by XGlitchy30
function c76253947.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c76253947.target)
	e1:SetOperation(c76253947.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,76253947)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c76253947.cttg)
	e2:SetOperation(c76253947.ctop)
	c:RegisterEffect(e2)
end
--filters
function c76253947.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7634)
end
function c76253947.matfilter(c)
	return c:IsType(TYPE_SPELL)
end
function c76253947.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7634) and c:GetCounter(0x1049)>0
end
--Activate
function c76253947.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c76253947.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76253947.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c76253947.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c76253947.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76253947.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c76253947.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
--counter
function c76253947.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c76253947.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76253947.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c76253947.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76253947.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return end
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetCounter(0x1049)
	if ct>0 then
		if tc:RemoveCounter(tp,0x1049,1,REASON_EFFECT)~=0 then
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			local t=g:GetFirst()
			if t and t:IsFaceup() then
				t:AddCounter(0x1049,1)
			end
		end
	end
end