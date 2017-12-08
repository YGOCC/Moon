--Engrav, Forgotten City
--Script by XGlitchy30
function c36541449.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c36541449.shtg)
	e1:SetOperation(c36541449.shop)
	c:RegisterEffect(e1)
	--selfdestroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c36541449.selfdestroy)
	c:RegisterEffect(e2)
	--decktop
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36541449,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetLabel(1)
	e3:SetCondition(c36541449.attributes)
	e3:SetOperation(c36541449.tdop)
	c:RegisterEffect(e3)
	--unaffected
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetLabel(3)
	e4:SetCondition(c36541449.attributes)
	e4:SetValue(c36541449.efilter)
	c:RegisterEffect(e4)
	--shuffle
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetLabel(5)
	e5:SetCondition(c36541449.attributes)
	e5:SetTarget(c36541449.rettg)
	e5:SetOperation(c36541449.retop)
	c:RegisterEffect(e5)
end
--filters
function c36541449.type(c)
	return c:GetOriginalType()==TYPE_SPELL or c:GetOriginalType()==TYPE_TRAP
end
function c36541449.attchk(c)
	return (c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_HAND)) 
		and (c:GetOriginalAttribute()==ATTRIBUTE_LIGHT
		   	or c:GetOriginalAttribute()==ATTRIBUTE_DARK
		   		or c:GetOriginalAttribute()==ATTRIBUTE_EARTH
		   			or c:GetOriginalAttribute()==ATTRIBUTE_WIND
		   				or c:GetOriginalAttribute()==ATTRIBUTE_FIRE
		   					or c:GetOriginalAttribute()==ATTRIBUTE_WATER
		   						or c:GetOriginalAttribute()==ATTRIBUTE_DIVINE)
end
--values
function c36541449.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c36541449.retfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and not c:IsReason(REASON_DESTROY) and c:IsAbleToDeck()
end
--attribute check
function c36541449.attributes(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c36541449.attchk,e:GetHandlerPlayer(),LOCATION_SZONE+LOCATION_HAND,0,e:GetHandler())
	return g:GetClassCount(Card.GetAttribute)>=e:GetLabel()
end
--Activate
function c36541449.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c36541449.shop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--selfdestroy
function c36541449.selfdestroy(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c36541449.type,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
--decktop
function c36541449.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c36541449.attchk,tp,LOCATION_HAND+LOCATION_SZONE,0,e:GetHandler())
	local ct=g:GetClassCount(Card.GetAttribute)
	Duel.SortDecktop(tp,tp,ct)
end
--shuffle
function c36541449.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c36541449.retfilter,1,nil) end
	local g=eg:Filter(c36541449.retfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c36541449.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c36541449.retfilter,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end