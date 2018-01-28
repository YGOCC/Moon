--Paintress Warholee
function c160001123.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)

	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,160001123)
	--e3:SetCost(c160001123.thcost)
	e3:SetTarget(c160001123.thtg)
	e3:SetOperation(c160001123.thop)
	c:RegisterEffect(e3)
end
function c160001123.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160001123.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160001123.filter(c)
	return   c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c160001123.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra()  end
  --  Duel.SendtoExtraP(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_COST)
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c160001123.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c160001123.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c160001123.thop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160001123.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end