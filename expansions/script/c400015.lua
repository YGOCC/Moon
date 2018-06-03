--Untergang ~~~
function c400015.initial_effect(c)
	--pre-act
	if not c400015.global_check then
		c400015.global_check=true
		-- local gettp=Effect.CreateEffect(c)
		-- gettp:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		-- gettp:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
		-- gettp:SetCode(EVENT_ADJUST)
		-- gettp:SetOperation(c400015.gettp)
		-- gettp:SetCountLimit(1)
		-- Duel.RegisterEffect(gettp,0)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e0:SetCode(EVENT_CHAIN_SOLVED)
		e0:SetOperation(c400015.prop)
		e0:SetLabelObject(gettp)
		Duel.RegisterEffect(e0,0)
	end
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
end
function c400015.gettp(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetControler())
end
function c400015.prop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tp=e:GetLabelObject():GetLabel()
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsType(TYPE_QUICKPLAY) and rc:IsSetCard(0x146)
		--[[and rp==tp]]) then return end
	e:GetHandler():RegisterFlagEffect(400015,RESET_PHASE+PHASE_END,0,1)
end
function c400015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffect(400015)
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
		c:RegisterFlagEffect(1400015,0x1600000+RESET_PHASE+PHASE_END,0,1)
		--EP discard
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(c400015.descon)
		e2:SetOperation(c400015.desop)
		g:KeepAlive()
		e2:SetLabelObject(g)
		Duel.RegisterEffect(e2,tp)
	end
end
function c400015.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1400015)~=0
end
function c400015.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g or (g and g:GetCount()==0) then return end
	if g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 then return end
	g:Remove(Card.IsType,nil,TYPE_SPELL)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
