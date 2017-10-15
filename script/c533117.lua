--Mysterious Cosmic Dragon
function c533117.initial_effect(c)
	--pendulum set
	aux.EnablePendulumAttribute(c)
	--spsummon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xCF6),aux.NonTuner(nil),1)
	--Activate
--[[	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(533117,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c533117.condition)
	e1:SetCost(c533117.cost)
	e1:SetTarget(c533117.target)
	e1:SetOperation(c533117.activate)
	c:RegisterEffect(e1)]]--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(533117,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c533117.remtg)
	e2:SetOperation(c533117.remop)
	c:RegisterEffect(e2)
end
function c533117.rfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsLocation(LOCATION_EXTRA) 
		or c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemove()
end
function c533117.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x16) and chkc:IsType(TYPE_MONSTER) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(c533117.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c533117.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c533117.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		c:CopyEffect(g:GetFirst():GetCode(),RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	end
		--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c533117.aclimit)
	e3:SetCondition(c533117.actcon)
	c:RegisterEffect(e3)
end
function c533117.rfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsLocation(LOCATION_EXTRA) 
		or c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemove()
end
function c533117.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x16) and chkc:IsType(TYPE_MONSTER) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(c533117.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c533117.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c533117.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		c:CopyEffect(g:GetFirst():GetCode(),RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
end 
end
function c533117.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c533117.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end