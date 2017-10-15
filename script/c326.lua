--created by Meedogh, coded by MoonBurst & Lyris
--パンデモニウム召喚
function c326.initial_effect(c)
	local f1=Card.IsType
	Card.IsType=function(tc,ctype)
		if tc.pandemonium and not tc:IsOnField() then return bit.band(tc:GetType(),0x3e05c21-TYPE_PENDULUM)==ctype
		end
		return f1(tc,ctype)
	end
	local f2=Card.GetType
	Card.GetType=function(tc)
		if tc.pandemonium and not tc:IsOnField() then return bit.band(f2(tc),0x3e05c21-TYPE_PENDULUM) else return f2(tc) end
	end
	if not c326.global_check then
		c326.global_check=true
		local e=Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e:SetCode(EVENT_ADJUST)
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e:SetOperation(c326.op)
		Duel.RegisterEffect(e,0)
	end
end
function c326.regfilter(c)
	return c.pandemonium
end
function c326.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c326.regfilter,0,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(326)==0 then
			local ge1=Effect.CreateEffect(tc)
			ge1:SetType(EFFECT_TYPE_SINGLE)
			ge1:SetCode(EFFECT_SPSUMMON_CONDITION)
			ge1:SetRange(LOCATION_EXTRA)
			ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			ge1:SetReset(RESET_EVENT+EVENT_ADJUST)
			ge1:SetValue(function(e,se,sp,st) local c=e:GetHandler() if c:IsFaceup() then return bit.band(st,0x100)==0x100 end return true end)
			tc:RegisterEffect(ge1)
			local ge2=Effect.CreateEffect(tc)
			ge2:SetType(EFFECT_TYPE_SINGLE)
			ge2:SetCode(EFFECT_MONSTER_SSET)
			ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge2:SetCondition(function(e) return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_SZONE)-Group.FromCards(Duel.GetFieldCard(tp,LOCATION_SZONE,5),Duel.GetFieldCard(tp,LOCATION_SZONE,6),Duel.GetFieldCard(tp,LOCATION_SZONE,7)):GetCount()>0 end)
			ge2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			ge2:SetReset(RESET_EVENT+EVENT_ADJUST)
			tc:RegisterEffect(ge2)
			local ge3=Effect.CreateEffect(tc)
			ge3:SetType(EFFECT_TYPE_SINGLE)
			ge3:SetCode(EFFECT_REMOVE_TYPE)
			ge3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
			ge3:SetValue(TYPE_PENDULUM)
			tc:RegisterEffect(ge3)
			local ge4=Effect.CreateEffect(tc)
			ge4:SetType(EFFECT_TYPE_SINGLE)
			ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge4:SetCode(EFFECT_CANNOT_TO_DECK)
			ge4:SetReset(RESET_EVENT+EVENT_ADJUST)
			ge4:SetCondition(function(e) return e:GetHandler():GetDestination()==LOCATION_GRAVE end)
			tc:RegisterEffect(ge4)
			local ge5=Effect.CreateEffect(tc)
			ge5:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
			ge5:SetCode(EVENT_FREE_CHAIN)
			ge5:SetRange(LOCATION_PZONE+LOCATION_SZONE)
			ge5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge5:SetCondition(function(e) return not e:GetHandler():IsStatus(STATUS_SET_TURN) end)
			ge5:SetTarget(c326.distg)
			ge5:SetReset(RESET_EVENT+EVENT_ADJUST)
			tc:RegisterEffect(ge5)
			local ge6=Effect.CreateEffect(tc)
			ge6:SetDescription(aux.Stringid(43708640,0))
			ge6:SetCategory(CATEGORY_SPECIAL_SUMMON)
			ge6:SetType(EFFECT_TYPE_QUICK_O)
			ge6:SetCode(EVENT_FREE_CHAIN)
			ge6:SetRange(LOCATION_SZONE+LOCATION_PZONE)
			ge6:SetHintTiming(0,0x1e0)
			ge6:SetCountLimit(1,10000000)
			ge6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
			ge6:SetCondition(function(e,tp) return Duel.GetFlagEffect(tp,326)==0 end)
			ge6:SetCost(c326.spcost)
			ge6:SetTarget(c326.sptg)
			ge6:SetOperation(c326.spop)
			tc:RegisterEffect(ge6)
			local ge7=Effect.CreateEffect(tc)
			ge7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ge7:SetCode(EFFECT_DESTROY_REPLACE)
			ge7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge7:SetRange(LOCATION_ONFIELD)
			ge7:SetTarget(c326.reop)
			ge7:SetReset(RESET_EVENT+EVENT_ADJUST)
			tc:RegisterEffect(ge7)
			local ge8=Effect.CreateEffect(tc)
			ge8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
			ge8:SetCode(EVENT_CHAIN_SOLVED)
			ge8:SetRange(0xff)
			ge8:SetOperation(c326.desop)
			ge8:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			Duel.RegisterEffect(ge8,0)
			local ge9=ge8:Clone()
			ge9:SetCode(EVENT_ADJUST)
			Duel.RegisterEffect(ge9,0)
			local gea=Effect.CreateEffect(tc)
			gea:SetType(EFFECT_TYPE_FIELD)
			gea:SetRange(LOCATION_PZONE)
			gea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			gea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			gea:SetTargetRange(1,0)
			gea:SetTarget(c326.splimit)
			tc:RegisterEffect(gea)
			tc:RegisterFlagEffect(326,RESET_EVENT+EVENT_ADJUST,0,1)
		end
		tc=g:GetNext()
	end
end
function c326.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)-Group.FromCards(Duel.GetFieldCard(tp,LOCATION_SZONE,5),Duel.GetFieldCard(tp,LOCATION_SZONE,6),Duel.GetFieldCard(tp,LOCATION_SZONE,7)):GetCount()>0 end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RegisterFlagEffect(tp,326,RESET_PHASE+PHASE_END,0,1)
end
function c326.filter(c,e,tp,lscale,rscale)
	return ((c:IsFaceup() and (c:IsType(TYPE_PENDULUM) or c.pandemonium)) or c:IsLocation(LOCATION_HAND)) and c:GetLevel()>lscale and c:GetLevel()<rscale and c:IsCanBeSpecialSummoned(e,0x100,tp,false,false)
		and not c:IsForbidden()
end
function c326.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasableByEffect() end
	Duel.Release(c,REASON_COST)
end
function c326.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local lscale=c:GetLeftScale() local rscale=c:GetRightScale()
		if c.pandemonium_lscale then lscale=c.pandemonium_lscale end
		if c.pandemonium_rscale then rscale=c.pandemonium_rscale end
		if lscale>rscale then lscale,rscale=rscale,lscale end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c326.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c326.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lscale=c.pandemonium_lscale local rscale=c.pandemonium_rscale
	if not lscale then lscale=c:GetLeftScale() end
	if not rscale then rscale=c:GetRightScale() end
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local tg=Duel.GetMatchingGroup(c326.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=math.min(ft,1) end
	if ft<=0 then return end
	local sg=Group.CreateGroup()
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and (ect<=0 or ect>ft) then ect=nil end
	if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ft,nil)
		sg:Merge(g)
	else
		repeat
			local ct=math.min(ft,ect)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			ft=ft-g:GetCount()
			ect=ect-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		until ft==0 or ect==0 or not Duel.SelectYesNo(tp,210)
		local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if ft>0 and ect==0 and hg:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=hg:Select(tp,1,ft,nil)
			sg:Merge(g)
		end
	end
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0x100,tp,tp,false,false,POS_FACEUP)
	end
end
function c326.reop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re or re~=e end
	Duel.SendtoExtraP(e:GetHandler(),nil,r+REASON_DESTROY)
	return true
end
function c326.panfilter(c)
	return c:IsFaceup() and c.pandemonium
end
function c326.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local g=Duel.GetMatchingGroup(c326.panfilter,c:GetControler(),LOCATION_SZONE,0,c)
	Duel.Destroy(g,REASON_RULE)
	local seq=c:GetSequence()
	if seq==6 or seq==7 then
		for i=0,4 do
			if not Duel.GetFieldCard(tp,LOCATION_SZONE,i) then Duel.MoveSequence(c,i) break end
		end
	end
end
function c326.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
