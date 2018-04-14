--Unlocking Key of Life
function c249000842.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,249000842)
	e1:SetCondition(c249000842.drcon)
	e1:SetTarget(c249000842.drtg)
	e1:SetOperation(c249000842.drop)
	c:RegisterEffect(e1)	
	--lpcost replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85668449,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetCondition(c249000842.lrcon)
	e2:SetOperation(c249000842.lrop)
	c:RegisterEffect(e2)
end
function c249000842.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c249000842.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
end
function c249000842.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		local ct=Duel.Draw(tp,1,REASON_EFFECT)
		if ct~=0 then
			local dc=Duel.GetOperatedGroup():GetFirst()
			if (dc:IsSetCard(0x1F6) or dc:IsSetCard(0x1F7)) and Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(69584564,0)) then
				Duel.BreakEffect()
				Duel.ConfirmCards(1-tp,dc)
				Duel.Draw(tp,1,REASON_EFFECT)
				Duel.ShuffleHand(tp)
			end
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		c:RegisterEffect(e1)
	end
end
function c249000842.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep or (not e:GetHandler():IsAbleToDeckAsCost()) then return false end
	if not re or not re:IsHasType(0x7e0) then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x1F6)
end
function c249000842.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	Duel.Recover(tp,ev,REASON_COST)
end