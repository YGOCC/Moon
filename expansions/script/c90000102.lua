--Archimage Tricky
function c90000102.initial_effect(c)
	--Change Name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(90000101)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,90000102)
	e2:SetCondition(c90000102.condition)
	e2:SetTarget(c90000102.target)
	e2:SetOperation(c90000102.operation)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetTarget(c90000102.target2)
	e3:SetOperation(c90000102.operation2)
	c:RegisterEffect(e3)
end
function c90000102.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c90000102.filter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0,POS_FACEDOWN)
end
function c90000102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c90000102.filter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c90000102.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c90000102.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if c:IsHasEffect(EFFECT_DEVINE_LIGHT) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	else
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		c:ClearEffectRelation()
	end
	local tg=sg:GetFirst()
	local fid=c:GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
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
		tg:RegisterFlagEffect(90000102,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_BATTLE,0,1,fid)
		tg:SetStatus(STATUS_NO_LEVEL,true)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sg)
	sg:AddCard(c)
	Duel.ShuffleSetCard(sg)
	sg:RemoveCard(c)
	sg:KeepAlive()
	local de=Effect.CreateEffect(c)
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetCode(EVENT_PHASE+PHASE_BATTLE)
	de:SetCountLimit(1)
	de:SetLabel(fid)
	de:SetLabelObject(sg)
	de:SetOperation(c90000102.op)
	de:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(de,tp)
end
function c90000102.filter2(c,fid)
	return c:GetFlagEffectLabel(90000102)==fid
end
function c90000102.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(c90000102.filter2,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
	local tg2=tg:Filter(c90000102.filter2,nil,fid)
	Duel.SendtoGrave(tg2,REASON_EFFECT)
end
function c90000102.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c90000102.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90000099,0,0x5d,500,500,1,RACE_ROCK,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,90000099)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end