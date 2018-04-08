--Number C300: Galaxy-Eyes Creation Dragon
function c88880014.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),8,5)
	c:EnableReviveLimit()
	--(1) spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88880014.splimit)
	c:RegisterEffect(e1)
	--(2) target effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c88880014.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--(3) Attach cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88880014,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c88880014.cost)
	e3:SetTarget(c88880014.target)
	e3:SetOperation(c88880014.operation)
	c:RegisterEffect(e3)
end
c88880013.xyz_number=300
--(1) spsummon limit
function c88880014.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95)
end
--(2) Target Effect
function c88880014.tgcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
--(3) Attach cards
function c88880014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=math.min(Duel.GetMatchingGroupCount(c88880014.ctfilter,tp,0,LOCATION_MZONE,nil),c:GetOverlayCount(),2)
	if chk==0 then return rt>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c88880014.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAbleToChangeControler()
		and not c:IsType(TYPE_TOKEN) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c88880014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c88880014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88880014.filter,tp,0,LOCATION_MZONE,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c88880014.filter,tp,0,LOCATION_MZONE,1,ct,nil)
end
function c88880014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local sc=g:GetNext()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then 
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc,sc))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
	end
end
