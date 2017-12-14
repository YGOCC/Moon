-- Sword and Tornado from the Fortress

function c30039214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,30039214+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c30039214.dacon)
	e1:SetTarget(c30039214.datg)
	e1:SetOperation(c30039214.activate)
	c:RegisterEffect(e1)
	
end


function c30039214.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xE4) or c:IsCode(87796900) or c:IsCode(57405307))
end


function c30039214.dacon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c30039214.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=2 and Duel.IsAbleToEnterBP()
end

function c30039214.filter1(c,tp)
	return c:IsFaceup() and Duel.IsExistingTarget(c30039214.filter2,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function c30039214.filter2(c,code)
	return c:IsFaceup() and c:GetCode()~=code
end

function c30039214.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c30039214.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c30039214.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c30039214.filter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetCode())
end


function c30039214.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsFacedown() or tc2:IsFacedown() or not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e)
	 then return end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c30039214.ftarget)
	e1:SetLabel(tc1:GetFieldID()) 
	e1:SetLabelObject(tc2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc2:RegisterEffect(e1)
	end



function c30039214.ftarget(e,c)
		return e:GetLabel()~=c:GetFieldID() and c~=e:GetLabelObject()
end