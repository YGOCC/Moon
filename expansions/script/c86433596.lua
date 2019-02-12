--Scala Royale
--Script by XGlitchy30
function c86433596.initial_effect(c)
	c:SetUniqueOnField(1,0,86433596)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c86433596.sprcon)
	e1:SetOperation(c86433596.sprop)
	c:RegisterEffect(e1)
	--reveal
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c86433596.regcon)
	e2:SetOperation(c86433596.regop)
	c:RegisterEffect(e4)
	local e2x=e2:Clone()
	e2x:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e2x)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(86433596,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c86433596.sctg)
	e3:SetOperation(c86433596.scop)
	c:RegisterEffect(e3)
	local e3x=e3:Clone()
	e3x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3x)
	--replenish hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(86433596,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,86433596)
	e4:SetLabel(1)
	e4:SetCondition(c86433596.royalecon)
	e4:SetTarget(c86433596.drawtg)
	e4:SetOperation(c86433596.drawop)
	c:RegisterEffect(e4)
	--draw
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(86433596,2))
	e5:SetCountLimit(1,80433596)
	e5:SetLabel(2)
	c:RegisterEffect(e5)
	--double stats
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(86433596,3))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetProperty(0)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,81433596)
	e6:SetLabel(3)
	e6:SetTarget(c86433596.standard)
	e6:SetOperation(c86433596.statsop)
	c:RegisterEffect(e6)
	--unaffected
	local e7=e4:Clone()
	e7:SetDescription(aux.Stringid(86433596,4))
	e7:SetCategory(0)
	e7:SetProperty(0)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1,82433596)
	e7:SetLabel(4)
	e7:SetTarget(c86433596.standard)
	e7:SetOperation(c86433596.statsop)
	c:RegisterEffect(e7)
	--banish
	local e8=e4:Clone()
	e8:SetDescription(aux.Stringid(86433596,5))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetProperty(0)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1,83433596)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetLabel(5)
	e8:SetTarget(c86433596.rmtg)
	e8:SetOperation(c86433596.rmop)
	c:RegisterEffect(e8)
	--win
	local e9=e4:Clone()
	e9:SetDescription(aux.Stringid(86433596,6))
	e9:SetCategory(0)
	e9:SetProperty(0)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1,84433596)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW+TIMING_TOHAND)
	e9:SetLabel(6)
	e9:SetTarget(c86433596.standard)
	e9:SetOperation(c86433596.winop)
	c:RegisterEffect(e9)
end
--filters
function c86433596.spcostfilter1(c,tp,self)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c86433596.spcostfilter2,tp,LOCATION_HAND,0,1,c,c:GetCode(),self)
end
function c86433596.spcostfilter2(c,code,self)
	return c:IsAbleToRemoveAsCost() and not c:IsCode(code) and c~=self
end
function c86433596.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c86433596.scfilter(c,g)
	return c:IsAbleToHand() and g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c86433596.typefilter(c,g,typ,rec)
	return c:IsPublic() and (not typ or c:IsType(typ)) and (rec==1 or (g:IsExists(c86433596.typefilter,1,c,g,c:GetType(),1)))
end
function c86433596.codefilter(c,g,code,rec,mx)
	if not mx then
		return c:IsPublic() and (code==nil or c:IsCode(code)) and (rec==1 or (g:IsExists(c86433596.codefilter,1,c,g,c:GetCode(),1,mx)))
	else
		return c:IsPublic() and (code==nil or c:IsCode(code)) and (rec==1 or (g:IsExists(c86433596.codefilter,mx,c,g,c:GetCode(),1,mx)))
	end
end
function c86433596.lvfilter(c,g,lv,rec,mx)
	if not mx then
		return c:IsPublic() and c:GetLevel()>0 and (lv==nil or c:GetLevel()==lv) and (rec==1 or (g:IsExists(c86433596.lvfilter,1,c,g,c:GetLevel(),1,mx)))
	else
		return c:IsPublic() and c:GetLevel()>0 and (lv==nil or c:GetLevel()==lv) and (rec==1 or (g:IsExists(c86433596.lvfilter,mx,c,g,c:GetLevel(),1,mx)))
	end
end
function c86433596.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c86433596.royalcheck(c,g,lv,mx,sg)
	if mx<5 then
		if not sg:IsContains(c) then
			sg:AddCard(c)
			if c:IsPublic() and c:GetLevel()>0 and (lv==nil or c:GetLevel()==lv+1) and g:IsExists(c86433596.royalcheck,1,c,g,c:GetLevel(),mx+1,sg) then
				return true
			else
				sg:Clear()
				return false
			end
		else
			return false
		end
	else
		if sg:IsContains(c) then return false end
		if c:IsPublic() and c:GetLevel()>0 and (lv==nil or c:GetLevel()==lv+1) then
			sg:Clear()
			return true
		else
			sg:Clear()
			return false
		end
	end
	return false
end
--spsummon proc
function c86433596.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c86433596.spcostfilter1,tp,LOCATION_HAND,0,c,tp,c)
	return g:IsExists(c86433596.spcostfilter1,1,c,tp,c)
end
function c86433596.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c86433596.spcostfilter1,tp,LOCATION_HAND,0,c,tp,c)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c86433596.spcostfilter1,1,1,c,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c86433596.spcostfilter2,tp,LOCATION_HAND,0,1,1,g1:GetFirst(),g1:GetFirst():GetCode(),c)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
--reveal
function c86433596.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c86433596.cfilter,1,nil,1-tp)
end
function c86433596.regop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end
--search
function c86433596.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2) and Duel.IsExistingMatchingCard(c86433596.scfilter,tp,LOCATION_DECK,0,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c86433596.scop(e,tp,eg,ep,ev,re,r,rp)
	local h=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c86433596.scfilter,tp,LOCATION_DECK,0,1,1,nil,h)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Draw(1-tp,2,REASON_EFFECT)
	end
end
--Royale Condition
function c86433596.royalecon(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=Group.CreateGroup()
	if val==1 then
		return not g:IsExists(Card.IsPublic,1,nil)
	elseif val==2 then
		return g:IsExists(c86433596.typefilter,1,nil,g,nil,0)
	elseif val==3 then
		return g:IsExists(c86433596.codefilter,1,nil,g,nil,0,nil)
	elseif val==4 then
		return g:IsExists(c86433596.lvfilter,1,nil,g,nil,0,nil)
	elseif val==5 then
		return g:IsExists(Card.IsPublic,6,nil)
	elseif val==6 then
		return g:IsExists(c86433596.royalcheck,1,nil,g,nil,1,sg)
	else
		return false
	end
end
--Standard target
function c86433596.standard(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--replenish hand/draw
function c86433596.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=e:GetLabel()
	if val==1 then
		if chk==0 then return Duel.IsPlayerCanDraw(1-tp,5) end
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(5)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,5)
	elseif val==2 then
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		return false
	end
end
function c86433596.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--double stats/unaffected
function c86433596.statsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if val==3 then
			local atk=c:GetAttack()
			local def=c:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(atk*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(def*2)
			c:RegisterEffect(e2)
			if g:IsExists(c86433596.codefilter,1,nil,g,nil,0,3) then
				local hv=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
				if hv:GetCount()<=0 then return end
				local tc=hv:GetFirst()
				while tc do
					local atk2=tc:GetAttack()
					local def2=tc:GetDefense()
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e3:SetCode(EFFECT_SET_ATTACK_FINAL)
					e3:SetValue(atk2/2)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
					local e3x=e3:Clone()
					e3x:SetCode(EFFECT_SET_DEFENSE_FINAL)
					e3x:SetValue(def2/2)
					tc:RegisterEffect(e3x)
					tc=hv:GetNext()
				end
			end
		elseif val==4 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c86433596.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(86433596,4))
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if g:IsExists(c86433596.lvfilter,1,nil,g,nil,0,3) then
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e4:SetRange(LOCATION_MZONE)
				e4:SetCode(EFFECT_UNRELEASABLE_SUM)
				e4:SetValue(1)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e4)
				local e5=e4:Clone()
				e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				c:RegisterEffect(e5)
				c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(86433596,7))
			end
		else
			return
		end
	end
end
--banish
function c86433596.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c86433596.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--win
function c86433596.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_ROYALEFLUSH = 0x1
	Duel.Win(tp,WIN_REASON_ROYALEFLUSH)
end