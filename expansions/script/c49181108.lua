--Darkest Moonlight
--by Nix
--known issues: 
function c49181108.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--atk,def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c49181108.adtg)
	e3:SetValue(-500)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c49181108.adtg)
	e4:SetValue(-500)
	c:RegisterEffect(e4)
	--destroy/take control
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(49181108,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c49181108.target)
	e5:SetOperation(c49181108.operation)
	c:RegisterEffect(e5)
end
function c49181108.adtg(e,c)
	return c:IsFaceup() and c:GetAttribute()~=c:GetOriginalAttribute()
end
function c49181108.desfilter(c)
	return c:IsType(TYPE_EQUIP)
end
function c49181108.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControlerCanBeChanged()
end
function c49181108.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c49181108.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49181108.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c49181108.desfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
end
function c49181108.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c49181108.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local tc=Duel.SelectMatchingCard(tp,c49181108.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end