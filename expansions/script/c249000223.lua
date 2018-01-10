--Dark Pendulum Knight
function c249000223.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000223.ptarget)
	e1:SetOperation(c249000223.poperation)
	c:RegisterEffect(e1)
	--des rep
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c249000223.reptg)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c249000223.etarget)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c249000223.pcfilter(c)
	return c:IsLevelAbove(5)
end
function c249000223.ptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(c249000223.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c249000223.poperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,4)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,c249000223.pcfilter,1,1,nil,e,tp)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
function c249000223.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPosition(POS_FACEUP_DEFENCE) end
	return true
end
function c249000223.etarget(e,c)
	return c:GetTurnID()==Duel.GetTurnCount() and c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:GetPreviousLocation()==LOCATION_HAND
end