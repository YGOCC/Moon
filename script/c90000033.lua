--Toxic Evil Princess
function c90000033.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c90000033.scondition)
	e1:SetOperation(c90000033.soperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--Summon Condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.synlimit)
	c:RegisterEffect(e2)
	--Copy Effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c90000033.target)
	e3:SetOperation(c90000033.operation)
	c:RegisterEffect(e3)
end
function c90000033.mfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x14) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c90000033.mfilter2(c,syncard)
	return c:IsNotTuner() and c:IsType(TYPE_SYNCHRO) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c90000033.sfilter1(c,syncard,lv,g1,g2,g3,g4)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c90000033.sfilter2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	else
		return g1:IsExists(c90000033.sfilter2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	end
end
function c90000033.sfilter2(c,syncard,lv,g2,g4,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not c:IsLocation(LOCATION_HAND)) or c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g4:IsExists(c90000033.sfilter3,1,nil,syncard,lv-tlv,f1,f2,g2)
	else
		return g2:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,1,62,syncard)
	end
end
function c90000033.sfilter3(c,syncard,lv,f1,f2,g2)
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
function c90000033.scondition(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c90000033.mfilter1,nil,c)
		g2=mg:Filter(c90000033.mfilter2,nil,c)
		g3=mg:Filter(c90000033.mfilter1,nil,c)
		g4=mg:Filter(c90000033.mfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c90000033.mfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c90000033.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c90000033.mfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c90000033.mfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c90000033.sfilter2,1,tuner,c,lv-tlv,g2,g4,f1,tuner)
		else
			return c90000033.sfilter2(pe:GetOwner(),c,lv-tlv,g2,nil,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c90000033.sfilter1,1,nil,c,lv,g1,g2,g3,g4)
	else
		return c90000033.sfilter1(pe:GetOwner(),c,lv,g1,g2,g3,g4)
	end
end
function c90000033.soperation(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c90000033.mfilter1,nil,c)
		g2=mg:Filter(c90000033.mfilter2,nil,c)
		g3=mg:Filter(c90000033.mfilter1,nil,c)
		g4=mg:Filter(c90000033.mfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c90000033.mfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c90000033.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c90000033.mfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c90000033.mfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
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
			local t2=g1:FilterSelect(tp,c90000033.sfilter2,1,1,tuner,c,lv-lv1,g2,g4,f1,tuner)
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
			m3=g4:FilterSelect(tp,c90000033.sfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2,g2)
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
			local t1=g1:FilterSelect(tp,c90000033.sfilter1,1,1,nil,c,lv,g1,g2,g3,g4)
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
			local t2=g3:FilterSelect(tp,c90000033.sfilter2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		else
			local t2=g1:FilterSelect(tp,c90000033.sfilter2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local m3=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not tuner2:IsLocation(LOCATION_HAND))
			or tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			m3=g4:FilterSelect(tp,c90000033.sfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2,g2)
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
function c90000033.filter(c)
  return c:IsType(TYPE_MONSTER) and bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c90000033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c90000033.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90000033.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
function c90000033.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:CopyEffect(tc:GetCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	end
end