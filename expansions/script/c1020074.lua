--Hellscape Realm
function c1020074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1020074.activate)
	c:RegisterEffect(e1)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c1020074.limcon)
	e3:SetOperation(c1020074.limop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_CHAIN_END)
	e5:SetOperation(c1020074.limop2)
	c:RegisterEffect(e5)
end
function c1020074.thfilter(c)
	return c:IsSetCard(2073) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetCode()~=1020074 and c:IsAbleToHand()
end
function c1020074.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c1020074.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1020074,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c1020074.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and c:IsSetCard(2073)
end
function c1020074.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1020074.limfilter,1,nil,tp)
end
function c1020074.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c1020074.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(1020074,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c1020074.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1020074)~=0 then
		Duel.SetChainLimitTillChainEnd(c1020074.chainlm)
	end
	e:GetHandler():ResetFlagEffect(1020074)
end
function c1020074.chainlm(e,rp,tp)
	return tp==rp
end
