--created & coded by Lyris
--インライトメント・アルティマ エルマ
function c210400017.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c210400017.spcon)
	e2:SetOperation(c210400017.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e3:SetTarget(c210400017.destg)
	e3:SetOperation(c210400017.desop)
	c:RegisterEffect(e3)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1da6),LOCATION_MZONE)
end
function c210400017.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda6) and c:IsAbleToGraveAsCost()
end
function c210400017.cfilter(c)
	return c:IsCode(210400008)
end
function c210400017.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c210400017.spfilter,tp,LOCATION_HAND,0,3,c)
		and Duel.CheckReleaseGroup(tp,c210400017.cfilter,1,nil)
end
function c210400017.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c210400017.spfilter,tp,LOCATION_HAND,0,3,3,c)
	local rg=Duel.SelectReleaseGroup(tp,c210400017.cfilter,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Release(rg,REASON_COST)
end
function c210400017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dir=Duel.GetAttackTarget()==nil
	if chk==0 then return true end
	if dir then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	end
end
function c210400017.desop(e,tp,eg,ep,ev,re,r,rp)
	local dir=Duel.GetAttackTarget()==nil
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if not dir then return end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
