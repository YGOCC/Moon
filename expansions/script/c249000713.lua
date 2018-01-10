--Evolution-Knight of Xyz
function c249000713.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19221310,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c249000713.destg)
	e2:SetOperation(c249000713.desop)
	c:RegisterEffect(e2)
	--Banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,249000713)
	e3:SetTarget(c249000713.rmtg)
	e3:SetOperation(c249000713.rmop)
	c:RegisterEffect(e3)
	--xyz summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e6:SetCondition(c249000713.condition)
	e6:SetCost(c249000713.cost)
	e6:SetTarget(c249000713.target)
	e6:SetOperation(c249000713.operation)
	c:RegisterEffect(e6)
end
function c249000713.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000713.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c249000713.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000713.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		if oc:IsControler(tp) then
			oc:RegisterFlagEffect(249000713,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		else
			oc:RegisterFlagEffect(249000713,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,1)
		end
		oc=og:GetNext()
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetCondition(c249000713.retcon)
		e1:SetOperation(c249000713.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c249000713.retfilter(c)
	return c:GetFlagEffect(249000713)~=0
end
function c249000713.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c249000713.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c249000713.retfilter,nil)
	if sg:GetCount()>1 and sg:GetClassCount(Card.GetPreviousControler)==1 then
		local ft=Duel.GetLocationCount(sg:GetFirst():GetPreviousControler(),LOCATION_MZONE)
		if ft==1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(249000713,0))
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.ReturnToField(tc)
			sg:RemoveCard(tc)
		end
	end
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
function c249000713.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c249000713.costfilter(c)
	return c:IsSetCard(0x1E9) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000713.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000713.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,c)
		and c:IsAbleToRemoveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c249000713.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,c)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000713.filter1(c,e,tp)
	return Duel.IsExistingMatchingCard(c249000713.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRace())
end
function c249000713.filter2(c,e,tp,rc)
	return c:GetRank() > 0 and c:GetRank() < 6 and c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000713.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c249000713.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c249000713.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000713.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA)
end
function c249000713.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000713.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRace())
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(sc,tc2)
		end
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetOperation(c249000713.rmop2)
		e1:SetReset(RESET_EVENT+0x4020000)
		sc:RegisterEffect(e1)
	end
end
function c249000713.filter3(c,rc,rk)
	return (c:GetRank()==rk or c:GetRank()==rk+1) and c:IsRace(rc)
end
function c249000713.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c249000713.filter3,tp,LOCATION_EXTRA,0,1,1,nil,c:GetRace(),c:GetRank()+1)
	local tc=tg:GetFirst()
	e:Reset()
	if tc==nil then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetTarget(c249000713.sptg)
		e1:SetOperation(c249000713.spop)
		tc:RegisterEffect(e1)
	end
end
function c249000713.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000713.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetOperation(c249000713.rmop2)
			e1:SetReset(RESET_EVENT+0x4020000)
			c:RegisterEffect(e1)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(c,tc2)
			end
		end
	end
end
