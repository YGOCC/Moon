--Galactic Codeman: Tuning Zero
function c1020019.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsSetCard,0xded),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c1020019.sscon)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c1020019.discon)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c1020019.distg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c1020019.discon)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c1020019.disop)
	c:RegisterEffect(e2)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c1020019.target)
	e5:SetOperation(c1020019.activate)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e5)
	local e4=e5:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e5:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Can't negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c1020019.indtg)
	e7:SetValue(c1020019.indval)
	c:RegisterEffect(e7)
	--pendulum
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(1020019,5))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetCondition(c1020019.pencon)
	e9:SetTarget(c1020019.pentg)
	e9:SetOperation(c1020019.penop)
	c:RegisterEffect(e9)
end
function c1020019.matfil(c)
	return c:IsFusionSetCard(0xded) and c:GetLevel()==7
end
function c1020019.sscon(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM or bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c1020019.indfil(c)
	return c:IsFusionSetCard(0xded)
end
function c1020019.disfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1ded) and c:IsType(TYPE_MONSTER)
end
function c1020019.discon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1020019.disfilter,tp,LOCATION_ONFIELD,0,1,nil) then return true end
end
function c1020019.distg(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c1020019.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:IsActiveType(TYPE_SYNCHRO) and p~=tp and loc==LOCATION_SZONE and (seq==6 or seq==7) then
		Duel.NegateEffect(ev)
	end
end
function c1020019.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c1020019.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c1020019.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c1020019.filter(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsPreviousLocation(LOCATION_HAND) and not c:IsStatus(STATUS_NO_LEVEL)
end
function c1020019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c1020019.filter,1,nil,tp)
		and Duel.GetMatchingGroupCount(c1020019.ctfilter,tp,LOCATION_ONFIELD,0,nil)>0 end
	local g=eg:Filter(c1020019.filter,nil,tp)
	op=Duel.SelectOption(tp,aux.Stringid(1020019,0),aux.Stringid(1020019,1))
	e:SetLabel(op)
	Duel.SetTargetCard(eg)
end
function c1020019.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:GetSummonPlayer()~=tp and c:IsPreviousLocation(LOCATION_HAND) and not c:IsStatus(STATUS_NO_LEVEL)
end
function c1020019.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER)
end
function c1020019.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1020019.filter2,nil,e,tp)
	local ct=Duel.GetMatchingGroupCount(c1020019.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and ct>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(ct)
		else e1:SetValue(-ct) end
		tc:RegisterEffect(e1)
	end
end
function c1020019.indfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xded)
end
function c1020019.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1020019.indfilter,1,nil,tp) end
	return true
end
function c1020019.indval(e,c)
	return c1020019.indfilter(c,e:GetHandlerPlayer())
end
