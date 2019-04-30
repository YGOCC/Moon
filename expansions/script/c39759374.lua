--Cyber Bit Inseguitore
--Script by XGlitchy30
function c39759374.initial_effect(c)
	--Deck Master
	--c:EnableReviveLimit()
	aux.AddOrigDeckmasterType(c,true)
	aux.EnableDeckmaster(c,nil,nil,-1,nil,nil,c39759374.penalty)
	--Ability: Cyboost
	local ab=Effect.CreateEffect(c)
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetCode(EFFECT_UPDATE_ATTACK)
	ab:SetRange(LOCATION_SZONE)
	ab:SetTargetRange(LOCATION_MZONE,0)
	ab:SetCondition(c39759374.condition)
	ab:SetValue(1000)
	c:RegisterEffect(ab)
	--Master Summon Custom Proc
	local ms=Effect.CreateEffect(c)
	ms:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	ms:SetType(EFFECT_TYPE_FIELD)
	ms:SetCode(EFFECT_SPSUMMON_PROC_G)
	ms:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ms:SetRange(LOCATION_SZONE)
	ms:SetCondition(c39759374.mscon)
	ms:SetOperation(c39759374.mscustom)
	ms:SetValue(SUMMON_TYPE_MASTER+SUMMON_TYPE_FUSION)
	c:RegisterEffect(ms)
	--Monster Effects--
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c39759374.actcon)
	e1:SetValue(c39759374.aclimit)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39759374,3))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c39759374.setcon)
	e2:SetTarget(c39759374.settg)
	e2:SetOperation(c39759374.setop)
	c:RegisterEffect(e2)
end
--filters
function c39759374.penaltyfilter(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c39759374.matfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE)
end
function c39759374.fspfilter(c)
	return c39759374.matfilter(c) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c39759374.spfilter1(c,tp,g)
	return g:IsExists(c39759374.spfilter2,1,c,tp,c)
end
function c39759374.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0 and Duel.IsExistingMatchingCard(c39759374.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp,mc)
end
function c39759374.lkfilter(c,tp,mc)
	local zone=c:GetLinkedZone(tp) 
	return c:IsType(TYPE_LINK) and zone>0 and c~=mc
end
function c39759374.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER)
end
function c39759374.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsSetCard(0x118)
end
--Master Summon Custom Proc
function c39759374.mscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c39759374.fspfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c39759374.spfilter1,1,nil,tp,g)
end
function c39759374.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	local g0=Duel.GetMatchingGroup(c39759374.fspfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g0:FilterSelect(tp,c39759374.spfilter1,1,1,nil,tp,g0)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g0:FilterSelect(tp,c39759374.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST+REASON_MATERIAL+REASON_FUSION+0x1000000000)
	--choose zone
	local g=Duel.GetMatchingGroup(c39759374.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,g1:GetFirst())
	g:KeepAlive()
	local zone=0
	local flag=0
	for i in aux.Next(g) do
		zone=bit.bor(zone,i:GetLinkedZone(tp)&0xff)
		local _,flag_tmp=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		flag=(~flag_tmp)&0x7f
	end
	local fzone=0
	if c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_MASTER+SUMMON_TYPE_FUSION,tp,true,false,POS_FACEUP,tp,zone) then
		fzone=fzone|(flag<<(tp==tp and 0 or 16))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x00ff00ff&(~fzone))
	Duel.SpecialSummon(c,SUMMON_TYPE_MASTER+SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP,sel_zone)
	c:RegisterFlagEffect(3340,RESET_EVENT+EVENT_CUSTOM+3340,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
	return
end
--Deck Master Functions
function c39759374.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c39759374.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c39759374.penalty(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c39759374.penaltyfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c39759374.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_LINK)
end
--Ability: Cyboost
function c39759374.condition(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.CheckDMActivatedState(e) and e:GetHandler():IsType(TYPE_FUSION)
end
--Monster Effects--
--actlimit
function c39759374.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c39759374.cfilter(a)) or (d and c39759374.cfilter(d))
end
function c39759374.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
--set
function c39759374.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return ep~=tp and rc:IsControler(tp) and rc:IsRace(RACE_CYBERSE)
end
function c39759374.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c39759374.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c39759374.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c39759374.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.ConfirmCards(1-tp,tc)
	end
end