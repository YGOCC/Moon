--Galactic Codeman: Fusion Zero
function c1020018.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),c1020018.matfil,2,2,true)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c1020018.sscon)
	c:RegisterEffect(e0)
	--Undestroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1020018.target)
	e1:SetOperation(c1020018.activate)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c1020018.discon)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c1020018.distg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c1020018.discon)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(c1020018.disop)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1020018.retcon)
	e4:SetTarget(c1020018.destg)
	e4:SetOperation(c1020018.desop)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1020018,5))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c1020018.pencon)
	e5:SetTarget(c1020018.pentg)
	e5:SetOperation(c1020018.penop)
	c:RegisterEffect(e5)
end
function c1020018.matfil(c)
	return c:IsFusionSetCard(0xded) and c:GetLevel()==7
end
function c1020018.sscon(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c1020018.indfil(c)
	return c:IsFusionSetCard(0xded)
end
function c1020018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c1020018.indfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1020018.indfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1020018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
function c1020018.disfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1ded) and c:IsType(TYPE_MONSTER)
end
function c1020018.discon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1020018.disfilter,tp,LOCATION_ONFIELD,0,1,nil) then return true end
end
function c1020018.distg(e,c)
	return c:IsType(TYPE_FUSION)
end
function c1020018.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:IsActiveType(TYPE_FUSION) and p~=tp and loc==LOCATION_SZONE and (seq==6 or seq==7) then
		Duel.NegateEffect(ev)
	end
end
function c1020018.retcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c1020018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xded)
end
function c1020018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1020018.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(aux.FilterBoolFunction(Card.IsAbleToRemove,true),tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c1020018.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.FilterBoolFunction(Card.IsAbleToRemove,true),tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1020018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==tg:GetCount() then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c1020018.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:GetSummonType()==SUMMON_TYPE_FUSION
end
function c1020018.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c1020018.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
