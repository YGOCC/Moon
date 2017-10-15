--Digimon Cherubimon (Evil)
function c47000116.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6E7),6,2,c47000116.ovfilter,aux.Stringid(47000116,0))
--activate(destroy)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47000116,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCountLimit(1,47000116)
	e1:SetCondition(c47000116.descon1)
	e1:SetTarget(c47000116.destg1)
	e1:SetOperation(c47000116.desop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c47000116.atcon)
	e4:SetValue(600)
	c:RegisterEffect(e4)
--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47000116,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c47000116.reptg)
	e3:SetOperation(c47000116.repop)
	c:RegisterEffect(e3)

end
function c47000116.ovfilter(c)
	return c:IsFaceup() and c:IsCode(47000113) and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c47000116.descon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c47000116.desfilter1(c)
	return c:IsFaceup()
end
function c47000116.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c47000116.desfilter1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c47000116.desfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47000116.desop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c47000116.atcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler()==Duel.GetAttacker()
end
function c47000116.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(47000116,0))
end
function c47000116.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
