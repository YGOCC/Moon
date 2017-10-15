--Extra-Esper Return
function c249000774.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000774.target)
	e1:SetOperation(c249000774.activate)
	c:RegisterEffect(e1)
	--level increase
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c249000774.lvcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c249000774.lvtg)
	e2:SetOperation(c249000774.lvop)
	c:RegisterEffect(e2)
end
function c249000774.filter(c,e,tp)
	return c:IsSetCard(0x1F0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000774.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c249000774.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000774.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000774.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000774.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000774.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1F0)
end
function c249000774.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000774.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000774.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c249000774.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c249000774.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000774.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c249000774.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local op=0
	if tc1:GetLevel()==1 or (tc2 and tc2:GetLevel()==1) then op=Duel.SelectOption(tp,aux.Stringid(63485233,0))
	else op=Duel.SelectOption(tp,aux.Stringid(63485233,0),aux.Stringid(63485233,1)) end
	e:SetLabel(op)
end
function c249000774.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			if e:GetLabel()==0 then
				e1:SetValue(1)
			else
				e1:SetValue(-1)
			end
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
