--Urgent Corona
local ref=_G['c'..28915112]
local id=28915112
function ref.initial_effect(c)
	--Corona Card
	aux.EnableCorona(c,nil,2,99,TYPE_TRAP,ref.refilter)
	--ChainCount
	if not UrgentCorona_global_check then
		UrgentCorona_global_check=true
		local chain=Effect.GlobalEffect()
		chain:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		chain:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		chain:SetCode(EVENT_CHAINING)
		--chain:SetRange(LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE)
		chain:SetOperation(ref.CoronaChainCount)
		Duel.RegisterEffect(chain,0)
	end
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(ref.grcon)
	e2:SetCost(ref.grcost)
	e2:SetTarget(ref.acttg)
	e2:SetOperation(ref.actop)
	c:RegisterEffect(e2)
end
function ref.refilter(ev)
	return Duel.CheckChainUniqueness()
end

--ChainCount+Check
function ref.CoronaChainCount(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("Checking")
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil,TYPE_CORONA)
	if not (g:GetCount()>0) then return false end
	local chain=Duel.GetCurrentChain()
	local c=g:GetFirst()
	while c do
		c:ResetFlagEffect(id)
		if not (c.aura and c.aura<=chain and c.max_aura>=chain) then break end
		if not ((not c.corona_global_condition) or c.corona_global_condition(ev)) then break end
		Debug.Message(c:GetCode())
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if (not c.corona_condition) or c.corona_condition(te,e) then c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1) end
		end
		c=g:GetNext()
	end
end

--Activate
function ref.grcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function ref.grcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,nil,1,1,REASON_COST+REASON_DISCARD,nil)
end

function ref.drfilter(c)
	return c:GetFlagEffect(id)~=0
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
--	Debug.Message("Can do?")
--	Debug.Message(Duel.IsExistingMatchingCard(ref.drfilter,tp,LOCATION_EXTRA,0,1,nil))
	if chk==0 then return Duel.IsExistingMatchingCard(ref.drfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.drfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			if tc:IsHasEffect(EFFECT_CORONA_DRAW_COST) then
				local tef={tc:IsHasEffect(EFFECT_CORONA_DRAW_COST)}
				for _,te in ipairs(tef) do
					local costf=te:GetValue()
					costf(e,tp,eg,ep,ev,re,r,rp,1)
				end
			end
			local tpe=tc:GetOriginalType()-TYPE_FUSION
			aux.AddCoronaToHand(tc,REASON_RULE,tpe)
			Duel.ConfirmCards(1-tp,tc)
			Duel.RaiseEvent(tc,EVENT_DRAW,e,REASON_EFFECT,tp,tp,1)
			Duel.RaiseEvent(tc,EVENT_CORONA_DRAW,e,REASON_EFFECT,tp,tp,1)
		end
	end
end
