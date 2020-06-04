function c4125.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x10041036),7,2)
	c:EnableReviveLimit()
	--remove 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetCondition(c4125.rmcon)
	e1:SetOperation(c4125.rmop)
	e1:SetLabel(TYPE_MONSTER)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(TYPE_SPELL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetLabel(TYPE_TRAP)
	c:RegisterEffect(e3)
	--reflect damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_REFLECT_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(c4125.refcon)
	c:RegisterEffect(e4)
	--Activate(summon)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4125,0))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c4125.condition)
	e5:SetTarget(c4125.target)
	e5:SetOperation(c4125.operation)
	c:RegisterEffect(e5)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c4125.aclimit1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHAIN_NEGATED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c4125.aclimit2)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetCondition(c4125.econ)
	e8:SetValue(c4125.elimit)
	c:RegisterEffect(e8)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(4125,1))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCountLimit(1)
	e9:SetCost(c4125.descost)
	e9:SetTarget(c4125.destg)
	e9:SetOperation(c4125.desop)
	c:RegisterEffect(e9)
	--remove material
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(4125,2))
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PHASE+PHASE_END)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(c4125.mcon)
	e10:SetOperation(c4125.mop)
	c:RegisterEffect(e10)
end
function c4125.rmfilter(c,tp,tpe)
	return c:IsControler(1-tp) and c:IsType(tpe)
end
function c4125.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4125.rmfilter,1,nil,tp,e:GetLabel()) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,0x20)
end
function c4125.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c4125.rmfilter,nil,tp,e:GetLabel())
	Duel.Remove(g,POS_FACEUP,r)
end
function c4125.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,0x04)
end
function c4125.cfilter(c)
	return (c:IsRankBelow(7) and c:GetSummonType()==SUMMON_TYPE_XYZ)  or ((c:GetSummonType()==SUMMON_TYPE_FUSION or c:GetSummonType()==SUMMON_TYPE_SYNCHRO) and c:IsLevelBelow(7))
end
function c4125.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,0x08) and Duel.GetTurnPlayer()~=tp 
		and tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0 and eg:IsExists(c4125.cfilter,1,nil)
end
function c4125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
end
function c4125.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	Duel.SendtoHand(eg,nil,2,REASON_EFFECT)
end
function c4125.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not Duel.GetCurrentPhase()==PHASE_MAIN1 then return end
	e:GetHandler():RegisterFlagEffect(4125,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_MAIN1,0,1)
end
function c4125.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not Duel.GetCurrentPhase()==PHASE_MAIN1 then return end
	e:GetHandler():ResetFlagEffect(4125)
end
function c4125.econ(e)
	return e:GetHandler():GetFlagEffect(4125)~=0
end
function c4125.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c4125.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4125.desfilter(c)
	return c:IsDestructable()
end
function c4125.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c4125.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4125.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4125.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c4125.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c4125.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end