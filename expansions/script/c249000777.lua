--Sapphire Kitsune
function c249000777.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000777.condition)
	e1:SetTarget(c249000777.target)
	e1:SetOperation(c249000777.operation)
	c:RegisterEffect(e1)
	--pendulum zone draw
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(16178681,1))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTarget(c249000777.drtg2)
	e8:SetOperation(c249000777.drop2)
	c:RegisterEffect(e8)
end
function c249000777.confilter(c)
	return c:IsSetCard(0x1B7) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000777.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000777.confilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>2
end
function c249000777.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c249000777.spfilter(c,e,tp)
	return c:GetOriginalLevel()<=10 and ((not c:IsSummonableCard()) or c:IsAttribute(ATTRIBUTE_DEVINE)) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c249000777.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.DisableShuffleCheck()
		Duel.MoveSequence(tc,1)
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c249000777.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(39913299,0)) then
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c249000777.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c249000777.efilter)
			e1:SetOwnerPlayer(tp)
				tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCountLimit(1)
			e2:SetCondition(c249000777.tdcon)
			e2:SetOperation(c249000777.tdop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e2,true)
			--cannot release
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_UNRELEASABLE_SUM)
			e3:SetValue(1)
			tc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e4,true)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_CHANGE_DAMAGE)
			e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e5:SetTargetRange(0,1)
			e5:SetValue(c249000777.damval)
			e5:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e5,tp)
		end
	end
	Duel.SpecialSummonComplete()
end
function c249000777.efilter(e,re)
	return e:GetOwnerPlayer()==re:GetOwnerPlayer() and e:GetHandler()~=re:GetHandler()
end
function c249000777.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c249000777.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c249000777.damval(e,re,val,r,rp,rc)
	return val/2
end
function c249000777.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000777.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end