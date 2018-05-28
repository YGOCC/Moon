--Untergang ~~~
function c400015.initial_effect(c)
	--pre-act
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetRange(0xff)
	e0:SetOperation(c400015.prop)
	e0:SetLabelObject(e0)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c400015.target)
	e1:SetOperation(c400015.activate)
	e1:SetCountLimit(1,400015+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	e1:SetLabelObject(e0)
end
function c400015.prop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():IsType(TYPE_QUICKPLAY)) then
		e:SetLabel(ct)
		return
	end
	e:SetLabel(ct+1)
end
function c400015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.GetTurnPlayer()~=tp and ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c400015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local g=Duel.GetOperatedGroup()
		c:RegisterFlagEffect(400015,0x1600000+RESET_PHASE+PHASE_END,0,1)
		--EP discard
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(c400015.descon)
		e2:SetOperation(c400015.desop)
		g:KeepAlive()
		e2:SetLabelObject(g)
		c:RegisterEffect(e2)
	end
end
function c400015.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(400015)~=0
end
function c400015.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Remove(Card.IsType,nil,TYPE_SPELL)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
