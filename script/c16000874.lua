--Storming Mirror Force Gal of Gust Vine
function c16000874.initial_effect(c)
		c:EnableReviveLimit()
		aux.AddFusionProcFun2(c,c16000874.mfilterx,c16000874.ffilter,true)
		
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000874,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c16000874.condition)
	e1:SetTarget(c16000874.target)
	e1:SetOperation(c16000874.operation)
	c:RegisterEffect(e1)
			--deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000874,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c16000874.target2)
	e2:SetOperation(c16000874.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c16000874.bancon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
			--spsummon condition
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.fuslimit)
	c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c16000874.efilter)
	c:RegisterEffect(e7)
	end
function c16000874.condition(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION or e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION+0x786
end	
	
	function c16000874.mfilterx(c)
	return c:IsCode(160009933) 
end
function c16000874.ffilter(c)
	return  c:GetLevel()>=5 and c:GetCode()~=16000874 and  c:IsLocation(LOCATION_ONFIELD) or c:IsHasEffect(500317451) 
end
function c16000874.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c16000874.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
			Duel.SetChainLimit(aux.FALSE)
end
function c16000874.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end

function c16000874.filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)and c:IsAbleToGrave()
end

function c16000874.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000874.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c16000874.operation2(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16000874.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end
end
function c16000874.bancon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DESTROY)
end
function c16000874.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end