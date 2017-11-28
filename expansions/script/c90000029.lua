--Toxic Evil Princess
function c90000029.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c90000029.condition1)
	e1:SetOperation(c90000029.operation1)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--ATK/DEF /2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c90000029.condition2)
	e2:SetOperation(c90000029.operation2)
	c:RegisterEffect(e2)
	--Copy Effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c90000029.target3)
	e3:SetOperation(c90000029.operation3)
	c:RegisterEffect(e3)
end
function c90000029.mfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x14) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c90000029.mfilter2(c,syncard)
	return c:IsNotTuner() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c90000029.filter1_1(c,syncard,lv,g1,g2,g3,g4)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c90000029.filter1_2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	else
		return g1:IsExists(c90000029.filter1_2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	end
end
function c90000029.filter1_2(c,syncard,lv,g2,g4,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not c:IsLocation(LOCATION_HAND)) or c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g4:IsExists(c90000029.filter1_3,1,nil,syncard,lv-tlv,f1,f2,g2)
	else
		return g2:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,1,62,syncard)
	end
end
function c90000029.filter1_3(c,syncard,lv,f1,f2,g2)
	if not (not f1 or f1(c)) and not (not f2 or f2(c)) then return false end
	local mlv=c:GetSynchroLevel(syncard)
	local slv=lv-mlv
	if slv<0 then return false end
	if slv==0 then
		return true
	else
		return g2:CheckWithSumEqual(Card.GetSynchroLevel,slv,1,61,syncard)
	end
end
function c90000029.condition1(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c90000029.mfilter1,nil,c)
		g2=mg:Filter(c90000029.mfilter2,nil,c)
		g3=mg:Filter(c90000029.mfilter1,nil,c)
		g4=mg:Filter(c90000029.mfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c90000029.mfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c90000029.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c90000029.mfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c90000029.mfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c90000029.filter1_2,1,tuner,c,lv-tlv,g2,g4,f1,tuner)
		else
			return c90000029.filter1_2(pe:GetOwner(),c,lv-tlv,g2,nil,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c90000029.filter1_1,1,nil,c,lv,g1,g2,g3,g4)
	else
		return c90000029.filter1_1(pe:GetOwner(),c,lv,g1,g2,g3,g4)
	end
end
function c90000029.operation1(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c90000029.mfilter1,nil,c)
		g2=mg:Filter(c90000029.mfilter2,nil,c)
		g3=mg:Filter(c90000029.mfilter1,nil,c)
		g4=mg:Filter(c90000029.mfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c90000029.mfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c90000029.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c90000029.mfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c90000029.mfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c90000029.filter1_2,1,1,tuner,c,lv-lv1,g2,g4,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local m3=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			m3=g4:FilterSelect(tp,c90000029.filter1_3,1,1,nil,c,lv-lv1-lv2,f1,f2,g2)
			local lv3=m3:GetFirst():GetSynchroLevel(c)
			if lv-lv1-lv2-lv3>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local m4=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1-lv2-lv3,1,61,c)
				g:Merge(m4)
			end
		else
			m3=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1-lv2,1,62,c)
		end
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		local hand=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c90000029.filter1_1,1,1,nil,c,lv,g1,g2,g3,g4)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		local tuner2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			local t2=g3:FilterSelect(tp,c90000029.filter1_2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		else
			local t2=g1:FilterSelect(tp,c90000029.filter1_2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local m3=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not tuner2:IsLocation(LOCATION_HAND))
			or tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			m3=g4:FilterSelect(tp,c90000029.filter1_3,1,1,nil,c,lv-lv1-lv2,f1,f2,g2)
			local lv3=m3:GetFirst():GetSynchroLevel(c)
			if lv-lv1-lv2-lv3>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local m4=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1-lv2-lv3,1,61,c)
				g:Merge(m4)
			end
		else
			m3=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-lv1-lv2,1,63,c)
		end
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c90000029.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c90000029.filter2(c)
	return c:IsFaceup() and not c:IsSetCard(0x14)
end
function c90000029.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c90000029.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()/2)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
function c90000029.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
end
function c90000029.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetLabel(cid)
		e1:SetLabelObject(e1)
		e1:SetOperation(c90000029.op1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c90000029.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end