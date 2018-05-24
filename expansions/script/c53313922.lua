--Mysterious Star Dragon
function c53313922.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--When this card is Summoned, you can target 1 Banished "Mysterious" monster, send it to your GY.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetTarget(c53313922.tgtg)
	e2:SetOperation(c53313922.tgop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--Once per turn: you can detach 1 Xyz material from this card, and target 1 monster your opponent controls, negate it's effects, also it loses ATK and DEF equal to it's level/rank x100, this cards gains that lost ATK and DEF.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e3:SetCost(c53313922.cost)
	e3:SetTarget(c53313922.target)
	e3:SetOperation(c53313922.operation)
	c:RegisterEffect(e3)
end
function c53313922.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcf6) and c:IsType(TYPE_MONSTER)
end
function c53313922.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c53313922.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53313922.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53313922,2))
	local g=Duel.SelectTarget(tp,c53313922.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c53313922.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c53313922.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c53313922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c53313922.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
		if tc:IsImmuneToEffect(e) then return end
		local lv=0
		if tc:GetLevel()>0 then lv=tc:GetLevel() end
		if tc:GetRank()>0 then lv=tc:GetRank() end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(lv*-100)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e4)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_UPDATE_ATTACK)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			e5:SetValue(lv*100)
			c:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e6)
		end
	end
end
