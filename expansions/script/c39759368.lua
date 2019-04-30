--Maga Darkmaster
--Script by XGlitchy30
function c39759368.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,-1,nil,nil,c39759368.penalty)
	--Master Summon Custom Proc
	local ms=Effect.CreateEffect(c)
	ms:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	ms:SetType(EFFECT_TYPE_FIELD)
	ms:SetCode(EFFECT_SPSUMMON_PROC_G)
	ms:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ms:SetRange(LOCATION_SZONE)
	ms:SetCondition(c39759368.mscon)
	ms:SetOperation(c39759368.mscustom)
	ms:SetValue(SUMMON_TYPE_MASTER)
	c:RegisterEffect(ms)
	--Ability: Magical Circle
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	ab:SetType(EFFECT_TYPE_IGNITION)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCountLimit(1,39759368)
	ab:SetCondition(aux.CheckDMActivatedState)
	ab:SetTarget(c39759368.target)
	ab:SetOperation(c39759368.operation)
	c:RegisterEffect(ab)
	--Monster Effects--
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e1:SetValue(300)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(39759368,ACTIVITY_CHAIN,c39759368.chainfilter)
	Duel.AddCustomActivityCounter(30759368,ACTIVITY_SPSUMMON,c39759368.counterfilter)
end
--filters
function c39759368.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL)
end
function c39759368.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c39759368.gfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c39759368.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c39759368.filter(c)
	local seq=c:GetSequence()
	return c:IsFaceup() and c:GetLevel()==7 and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
		and (Duel.CheckLocation(c:GetControler(),LOCATION_MZONE,math.abs(seq-1)) or Duel.CheckLocation(c:GetControler(),LOCATION_MZONE,math.abs(seq+1)))
end
--Deck Master Functions
function c39759368.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c39759368.splimcon)
	e1:SetTarget(c39759368.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c39759368.aclimcon)
	e2:SetValue(c39759368.aclimit)
	Duel.RegisterEffect(e2,tp)
end
function c39759368.splimcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(39759368,tp,ACTIVITY_CHAIN)~=0
end
function c39759368.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_SPELLCASTER
end
function c39759368.aclimcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(30759368,tp,ACTIVITY_SPSUMMON)~=0
end
function c39759368.aclimit(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c39759368.mscon(e,c)
	if c==nil then return true end
	return aux.CheckDMActivatedState(e) and Duel.IsExistingMatchingCard(c39759368.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c39759368.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c39759368.filter,tp,LOCATION_MZONE,0,nil)
	g:KeepAlive()
	local check=false
	local zone=0
	local flag=0
	for i in aux.Next(g) do
		local seq=i:GetSequence()
		local typ=i:GetType()
		Card.SetCardData(i,CARDDATA_TYPE,TYPE_MONSTER+TYPE_LINK)
		if seq<5 then
			Card.SetCardData(i,CARDDATA_LINK_MARKER,0x028)
		else
			Card.SetCardData(i,CARDDATA_LINK_MARKER,0x005)
		end
		zone=bit.bor(zone,i:GetLinkedZone(tp)&0xff)
		local _,flag_tmp=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		flag=(~flag_tmp)&0x7f
		Card.SetCardData(i,CARDDATA_TYPE,typ)
	end
	local fzone=0
	if c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_MASTER,tp,false,false,POS_FACEUP,tp,zone) then
		fzone=fzone|(flag<<(tp==tp and 0 or 16))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x00ff00ff&(~fzone))
	Duel.SpecialSummon(c,SUMMON_TYPE_MASTER,tp,tp,false,false,POS_FACEUP,sel_zone)
	c:RegisterFlagEffect(3340,RESET_EVENT+EVENT_CUSTOM+3340,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
	return
end
function c39759368.penalty(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(c39759368.distarget)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c39759368.disoperation)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function c39759368.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_SPELL)
end
function c39759368.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end
--Ability: Magical Circle
function c39759368.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ac=Duel.GetMatchingGroupCount(c39759368.gfilter,tp,LOCATION_MZONE,0,nil)
		return ac>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ac
	end
end
function c39759368.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetMatchingGroupCount(c39759368.gfilter,tp,LOCATION_MZONE,0,nil)
	if ac==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ac then return end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(c39759368.thfilter,nil)
	if sg:GetCount()>0 then
		local tc=sg:Select(tp,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT+REASON_REVEAL)
		Duel.ConfirmCards(1-tp,tc)
	end
end