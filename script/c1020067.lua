--Hellscape Decay
function c1020067.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1020067.hspcon)
	e1:SetOperation(c1020067.hspop)
	e1:SetCountLimit(1,1020067)
	c:RegisterEffect(e1)
	--ToGrave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1020067,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c1020067.target)
	e3:SetOperation(c1020067.operation)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function c1020067.spfilter(c)
	return c:IsSetCard(2073) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1020067.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	return Duel.IsExistingMatchingCard(c1020067.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c1020067.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1020067.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1020067.filter(c)
	return c:IsFaceup() and c:IsSetCard(2073) and c:IsType(TYPE_MONSTER)
end
function c1020067.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1020067.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1020067.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1020067.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c1020067.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
