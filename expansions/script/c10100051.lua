--Schach Raum
function c10100051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reducedm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100051,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c10100051.rdcon)
	e2:SetOperation(c10100051.rdop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100051,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10100051.condition)
	e3:SetTarget(c10100051.destg)
	e3:SetOperation(c10100051.desop)
	c:RegisterEffect(e3)
end
function c10100051.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c10100051.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c10100051.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x324) or c:IsCode(10100046)
end
function c10100051.sfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x324) and c:IsAbleToGrave()
end
function c10100051.ntfilter(c)
	return c:IsFaceup() and c:IsCode(10100050)
end
function c10100051.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100051.ntfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,e:GetHandler())
end
function c10100051.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10100051.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100051.desfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c10100051.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10100051.desfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10100051.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c10100051.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end