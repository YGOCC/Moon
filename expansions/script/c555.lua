--Unlock Procedure
local ref=_G['c'..555]
function c555.initial_effect(c)
	--Register Summon restraints
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(ref.burstreg)
	Duel.RegisterEffect(e0,0)
	--Check Unlock Level QOL
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0xff)
	e1:SetTarget(ref.levelchain)
	e1:SetOperation(ref.lvchk)
	--c:RegisterEffect(e1)
	--Unlock Proceedure (Core Edition)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIONS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(0xff)
	e2:SetCost(ref.burstcost)
	e2:SetTarget(ref.bursttg)
	e2:SetOperation(ref.burstop)
	c:RegisterEffect(e2)
	--protection
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_DECK) 
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e6)
	--Check for used Traps
	--[[local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(0xff)
	e7:SetOperation(ref.chainop)
	c:RegisterEffect(e7)]]
end

function ref.levelchain(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end

function ref.unlocklevelfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function ref.unlocklevelcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.unlocklevelfilter,1,nil)
end
function ref.chainop(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(558,RESET_CHAIN,0,1)
end

function ref.isburst(c)
	return c.burst
end
function c555.burstreg(e,tp,eg,ep,ev,re,r,rp)
	print("Registering Effects...")
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(ref.isburst,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		--if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() Duel.SendtoGrave(tc,nil,REASON_RULE) end
		--if tc:IsLocation(LOCATION_HAND) then Duel.SendtoGrave(tc,nil,0,REASON_RULE) Duel.Draw(tp,1,REASON_RULE) end
		if tc:GetFlagEffect(555)==0 then
			print("Registering an effect...")
			--Summon Condition
			--[[tc:EnableReviveLimit()
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_SPSUMMON_CONDITION)
			if not tc.burst_nomi then
				e0:SetRange(LOCATION_EXTRA)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			else
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			end
			e0:SetValue(ref.splimit)
			tc:RegisterEffect(e0)]]
			--Revive Limit
			--tc:EnableReviveLimit()
			--[[local e1=Effect.CreateEffect(c)
			--e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SPSUMMON_CONDITION)
			--e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(ref.splimit)
			tc:RegisterEffect(e1)]]
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SPSUMMON_CONDITION)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(ref.splimit)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(555,RESET_PHASE+PHASE_END,0,1)
		end
		print("Registered an effect...")
		tc=g:GetNext()
	end
	print("Registration complete!")
end
function ref.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return bit.band(st,0x555)==0x555 or not (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or (c:IsLocation(LOCATION_EXTRA) and not c:IsFaceup()))
end

function ref.GetUSummonLevel(c)
	if c.USummonLevel then return c.USummonLevel end
	return c:GetLevel()
end
function ref.burstfilter(c,e,tp)
	print("Checking if Summon target")
	if c.burst then
		print("Can it be summoned?")
	else
		print("Not an Unlock Monster.")
		return false
	end
	local trapct=1
	local monlv=1
	local ULevel=ref.GetUSummonLevel(c)
	monlv=ULevel
	if c.trapcount then trapct=c.trapcount end
	--if c.moncount then monct=c.moncount end
	if ref.checkunlockmaterials(c,e,tp,trapct,monlv)
		and c:IsCanBeSpecialSummoned(e,0x555,tp,true,true)
		and ((not c.lock) or Duel.CheckEvent(c.lock))
		and ((not c.unlockcon) or c.unlockcon(e,tp)) then
		print("Successful summon found!")
		return true
	end
	return false
end
function ref.checkunlockmaterials(c,e,tp,trapct,monlv)
	local mg=Duel.GetMatchingGroup(ref.burstmonfilter,tp,LOCATION_MZONE,0,nil,c)
	return Duel.IsExistingMatchingCard(ref.bursttrapfilter,tp,LOCATION_ONFIELD,0,trapct,nil,c)
		and mg:CheckWithSumGreater(Card.GetLevel,monlv,c)
end
function ref.bursttrapfilter(c,burst)
	print("Checking for Trap Material")
	return c:IsType(TYPE_TRAP) and c:GetFlagEffect(558)==0
		--and (not c:IsType(TYPE_COUNTER))
		and c:IsAbleToGrave()
		and ((not burst.trapmaterial) or burst.trapmaterial(c))
		and ((not c.burstlimit) or c.burstlimit(burst))
end
function ref.burstmonfilter(c,burst)
	print("Checking for Monster Material")
	return c:IsAbleToGrave() and c:IsFaceup()
		and c:GetLevel()>0
		and ((not burst.monmaterial) or burst.monmaterial(c))
		and ((not c.burstlimit) or c.burstlimit(burst))
end
function ref.burstcost(e,tp,eg,ep,ev,re,r,rp,chk)
	print("burst cost chk")
	if chk==0 then return Duel.GetFlagEffect(tp,556)==0 end
	--e:SetType(EFFECT_TYPE_ACTIONS)
	e:GetHandler():ReleaseEffectRelation(e)
	Duel.RegisterFlagEffect(tp,556,RESET_CHAIN,0,1)
end
function ref.burstcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function ref.bursttg(e,tp,eg,ep,ev,re,r,rp,chk)
	print("Burst target check")
	local g=Duel.GetMatchingGroup(ref.burstfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end
	local tc=g:GetFirst()
	while tc do
		--[[local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCode(555)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)]]
		tc:RegisterFlagEffect(557,RESET_CHAIN,0,1)
		tc=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE)
end
function ref.burstsumfilter(c,e,tp)
	print("Checking for eligible summons...")
	if c:GetFlagEffect(557)~=0 then
		print("Found summon!")
		local trapct=1
		local monlv=1
		local ULevel=ref.GetUSummonLevel(c)
		monlv=ULevel
		if c.trapcount then trapct=c.trapcount end
		return ref.checkunlockmaterials(c,e,tp,trapct,monlv) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
	end
	return false
end
function ref.burstop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.burstsumfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local c=g:GetFirst()
		local trapct=1
		local monlv=1
		local ULevel=ref.GetUSummonLevel(c)
		monlv=ULevel
		if c.trapcount then trapct=c.trapcount end
		local mg=Duel.GetMatchingGroup(ref.burstmonfilter,tp,LOCATION_MZONE,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat1=Duel.SelectMatchingCard(tp,ref.bursttrapfilter,tp,LOCATION_ONFIELD,0,trapct,trapct,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat2=mg:SelectWithSumGreater(tp,Card.GetLevel,monlv,c)
		--local mat2=Duel.SelectMatchingCard(tp,ref.burstmonfilter,tp,LOCATION_MZONE,0,monct,monct,nil,c)
		mat1:Merge(mat2)
		c:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT)
		if Duel.SpecialSummon(g,0x555,tp,tp,true,true,POS_FACEUP)~=0 then
			g:GetFirst():CompleteProcedure()
		end
	end
	--end
end

