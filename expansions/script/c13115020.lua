--Nymfomania Ianthe
--Keddy was here~
local id,cod=13115020,c13115020
function cod.initial_effect(c)
	--Activate
	aux.EnablePendulumAttribute(c)
	--Return To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cod.retcon)
	e1:SetTarget(cod.rettg)
	e1:SetOperation(cod.retop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(cod.descost)
	e2:SetTarget(cod.destg)
	e2:SetOperation(cod.desop)
	c:RegisterEffect(e2)
end
function cod.cfilter(c)
	return c:IsSetCard(0x523) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:IsAbleToHand()
end
function cod.retcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>0 and eg:IsExists(cod.cfilter,1,nil) then
		e:SetLabelObject(eg)
		return true
	else
		return false end
end
function cod.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function cod.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=nil
	if g:GetCount()==1 then
		tc=g:GetFirst()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg=g:Select(tp,1,1,nil)
		if rg:GetCount()>0 then
			tc=rg:GetFirst()
		end
	end
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cod.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function cod.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cod.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,2,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(tp,300*ct,REASON_EFFECT)
		end
	end
end