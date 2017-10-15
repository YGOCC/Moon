--Xyz-Archfiend Assailant
function c249000398.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20586572,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c249000398.condition)
	e1:SetTarget(c249000398.target)
	e1:SetOperation(c249000398.operation)
	c:RegisterEffect(e1)
	--banish when xyz material+sent to grave
	if not c249000398.global_check then
		c249000398.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,249000398))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72502414,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,249000398)
	e2:SetCondition(c249000398.condition)
	e2:SetTarget(c249000398.target2)
	e2:SetOperation(c249000398.operation2)
	c:RegisterEffect(e2)
end
function c249000398.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
		and e:GetHandler():GetReasonCard():IsRelateToBattle()
end
function c249000398.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	rc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c249000398.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc:IsRelateToEffect(e) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c249000398.confilter(c)
	return c:IsSetCard(0x73) and c:IsSetCard(0x45) and not c:IsCode(249000398) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVEYARD))
end
function c249000398.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000398.confilter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_PZONE+LOCATION_GRAVE,0,1,nil)
end
function c249000398.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000398.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c249000398.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000398.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c249000398.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c249000398.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end