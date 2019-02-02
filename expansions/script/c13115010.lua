--Nymfomania Nixie
--Keddy was here~
local id,cod=13115010,c13115010
function cod.initial_effect(c)
	--Activate
	aux.EnablePendulumAttribute(c)
	--Add to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cod.thcon)
	e1:SetTarget(cod.thtg)
	e1:SetOperation(cod.thop)
	c:RegisterEffect(e1)
end
function cod.thcon(e)
--	local seq=e:GetHandler():GetSequence()
--	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
--	if not tc then return false end
--	return tc or tc:IsSetCard(0x523)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x523)
end
function cod.cfilter(c)
	return c:IsSetCard(0x523) and c:IsType(TYPE_MONSTER+TYPE_PENDULUM) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function cod.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and cod.cfilter(chkc) end
	if chk==0 then return e:GetHandler():IsDestructable() 
		and Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cod.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end