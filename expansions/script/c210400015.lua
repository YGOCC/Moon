--created & coded by Lyris
--インライトメント・アルティマ エアトス
function c210400015.initial_effect(c)
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
	e2:SetCondition(c210400015.spcon)
	e2:SetOperation(c210400015.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetTarget(c210400015.eqtg)
	e3:SetOperation(c210400015.eqop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetTarget(c210400015.target)
	e4:SetOperation(c210400015.operation)
	c:RegisterEffect(e4)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1da6),LOCATION_MZONE)
end
function c210400015.spfilter(c)
	return c:IsCode(210400005)
end
function c210400015.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda6) and c:IsAbleToDeckAsCost()
end
function c210400015.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c210400015.spfilter,1,nil)
		and Duel.IsExistingMatchingCard(c210400015.cfilter,tp,LOCATION_GRAVE,0,5,nil)
end
function c210400015.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,c210400015.cfilter,tp,LOCATION_GRAVE,0,5,5,nil)
	local g=Duel.SelectReleaseGroup(tp,c210400015.spfilter,1,1,nil)
	Duel.SendtoDeck(dg,nil,2,REASON_COST)
	Duel.Release(g,REASON_COST)
end
function c210400015.eqfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c210400015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c210400015.eqfilter,tp,0,LOCATION_REMOVED,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c210400015.eqfilter,tp,0,LOCATION_REMOVED,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c210400015.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,true) then return end
		tc:RegisterFlagEffect(210400015,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c210400015.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c210400015.eqlimit(e,c)
	return e:GetOwner()==c
end
function c210400015.filter(c)
	return c:GetFlagEffect(210400015)~=0
end
function c210400015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local eqc=e:GetHandler():GetEquipGroup():Filter(c210400015.filter,nil):GetFirst()
	if eqc then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eqc:GetTextAttack()/2) end
end
function c210400015.operation(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetHandler():GetEquipGroup():Filter(c210400015.filter,nil):GetFirst()
	if eqc then
		Duel.Damage(1-tp,eqc:GetTextAttack()/2,REASON_EFFECT)
	end
end
