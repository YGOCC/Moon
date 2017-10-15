--Lithos Golem Endolith
function c2223333.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c2223333.pencon)
	e2:SetTarget(c2223333.pentg)
	e2:SetOperation(c2223333.penop)
	c:RegisterEffect(e2)
end

function c2223333.pencon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local sc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return sc and (sc:IsSetCard(0x222))
end

function c2223333.penfilter(c)
	return c:IsSetCard(0x222) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()

end
function c2223333.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then 
		return chkc:IsLocation(LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
		and chkc:IsControler(tp)
		and c2223331.thfilter(chkc)
	end
   
	if chk==0 then 
		return Duel.IsExistingTarget(c2223331.thfilter,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) 
   end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--local g=Duel.SelectTarget(tp,c2223331.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c2223333.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,c2223333.penfilter,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end