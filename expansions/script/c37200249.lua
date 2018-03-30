--Magician's Hat-trick
--Script by XGlitchy30
function c37200249.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,31200249+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c37200249.spcon)
	e1:SetTarget(c37200249.sptg)
	e1:SetOperation(c37200249.spact)
	c:RegisterEffect(e1)
	--hattrick
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,37200249+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c37200249.htrcon)
	e2:SetCost(c37200249.htrcost)
	e2:SetTarget(c37200249.htrtg)
	e2:SetOperation(c37200249.htrop)
	c:RegisterEffect(e2)
end
--filters
function c37200249.spcheck(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>=7
end
function c37200249.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()<=3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c37200249.spclone,tp,LOCATION_DECK,0,1,c,c:GetCode(),e,tp)
end
function c37200249.spclone(c,code,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()<=3 and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37200249.rmfilter(c,fid)
	return c:GetFlagEffectLabel(37200249)==fid
end
function c37200249.htrfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetSequence()<5 and not c:IsType(TYPE_TOKEN+TYPE_LINK)
end
function c37200249.stsp(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0,POS_FACEDOWN)
end
function c37200249.EPfilter(c,fid,notfid)
	return c:GetFlagEffectLabel(31200249)==fid
		or c:GetFlagEffectLabel(31200249)~=notfid
end
function c37200249.remcheck(c,fid)
	return c:GetFlagEffectLabel(31200249)==fid and c:IsAbleToRemove()
end
--Activate
function c37200249.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37200249.spcheck,tp,LOCATION_MZONE,0,1,nil)
end
function c37200249.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200249.spcheck,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>1 and Duel.IsExistingMatchingCard(c37200249.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c37200249.spact(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Group.CreateGroup()
	local sp1=Duel.SelectMatchingCard(tp,c37200249.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	g:AddCard(sp1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sp2=Duel.SelectMatchingCard(tp,c37200249.spclone,tp,LOCATION_DECK,0,1,1,sp1:GetFirst(),sp1:GetFirst():GetCode(),e,tp)
	g:AddCard(sp2:GetFirst())
	if g:GetCount()==2 then
		local fid=e:GetHandler():GetFieldID()
		Duel.SpecialSummonStep(sp1:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(sp2:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		sp1:GetFirst():RegisterFlagEffect(37200249,RESET_EVENT+0x1fe0000,0,1,fid)
		sp2:GetFirst():RegisterFlagEffect(37200249,RESET_EVENT+0x1fe0000,0,1,fid)
		--Negate effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sp1:GetFirst():RegisterEffect(e1,true)
		local e2=e1:Clone()
		sp2:GetFirst():RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		sp1:GetFirst():RegisterEffect(e3,true)
		local e4=e3:Clone()
		sp2:GetFirst():RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()
		--Banish during the EP
		g:KeepAlive()
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetCountLimit(1)
		e5:SetLabel(fid)
		e5:SetLabelObject(g)
		e5:SetCondition(c37200249.rmcon)
		e5:SetOperation(c37200249.rmop)
		Duel.RegisterEffect(e5,tp)
	end
end
--banish procedure
function c37200249.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c37200249.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c37200249.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c37200249.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
--hattrick
function c37200249.htrcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c37200249.htrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c37200249.htrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c37200249.htrfilter,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c37200249.stsp,tp,LOCATION_GRAVE+LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SelectTarget(tp,c37200249.htrfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c37200249.htrop(e,tp,eg,ep,ev,re,r,rp)
	--check conditions
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	--
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsImmuneToEffect(e) then return end
	if tc:IsFaceup() then
		if tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			tc:ClearEffectRelation()
		end
	end
	local sptp=Duel.GetMatchingGroup(c37200249.stsp,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if sptp:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	--spell/trap special summon
	local sel=sptp:Select(tp,2,2,nil)
	local tg=sel:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tg:RegisterEffect(e5,true)
		tg:RegisterFlagEffect(31200249,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_END,0,1,fid)
		tg:SetStatus(STATUS_NO_LEVEL,true)
		tg=sel:GetNext()
	end
	--field positioning procedure
	Duel.SpecialSummon(sel,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sel)
	sel:AddCard(tc)
	Duel.ShuffleSetCard(sel)
	sel:KeepAlive()
	--EP effect
	local EP=Effect.CreateEffect(e:GetHandler())
	EP:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	EP:SetCode(EVENT_PHASE+PHASE_END)
	EP:SetReset(RESET_PHASE+PHASE_END)
	EP:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	EP:SetCountLimit(1)
	EP:SetLabel(fid)
	EP:SetLabelObject(sel)
	EP:SetOperation(c37200249.EPop)
	Duel.RegisterEffect(EP,tp)
end
--EP Procedure
function c37200249.EPop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(c37200249.EPfilter,nil,fid,fid)
	g:DeleteGroup()
	Duel.ChangePosition(tg,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	local flip=Duel.GetOperatedGroup()
	--check condition
	local checkg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if checkg:GetCount()<flip:GetCount() then return end
	--
	local group=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,flip:GetCount(),flip:GetCount(),nil)
	if group:GetCount()>0 then
		Duel.Destroy(group,REASON_EFFECT)
		local rem=flip:Filter(c37200249.remcheck,nil,fid)
		Duel.Remove(rem,POS_FACEUP,REASON_EFFECT)
	end
end