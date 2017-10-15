--Paintress Warholee
function c160001123.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)

	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160001123.splimit)
	e2:SetCondition(c160001123.splimcon)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,160001123)
	e3:SetCost(c160001123.thcost)
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
  Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c160001123.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c160001123.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160001123.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end