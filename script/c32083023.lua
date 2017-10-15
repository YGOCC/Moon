--D.D. Kaiser Dragon - the Legend
function c32083023.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c32083023.syncon)
	e1:SetOperation(c32083023.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
		--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32083023,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c32083023.destg)
	e2:SetOperation(c32083023.desop)
	c:RegisterEffect(e2)
		--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetDescription(aux.Stringid(32083023,1))
	e4:SetCondition(c32083023.spcon)
	e4:SetCost(c32083023.spcost)
	e4:SetTarget(c32083023.sptg)
	e4:SetOperation(c32083023.spop)
	c:RegisterEffect(e4)
end
function c32083023.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard) and c:IsSetCard(0x7D53)
end
function c32083023.matfilter2(c,syncard)
	return c:IsNotTuner() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x7D53) and c:IsCanBeSynchroMaterial(syncard)
end
function c32083023.synfilter1(c,syncard,lv,g1,g2,g3,g4)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c32083023.synfilter2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	else
		return g1:IsExists(c32083023.synfilter2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	end
end
function c32083023.synfilter2(c,syncard,lv,g2,g4,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not c:IsLocation(LOCATION_HAND)) or c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g4:IsExists(c32083023.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
	else
		return g2:IsExists(c32083023.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
	end
end
function c32083023.synfilter3(c,syncard,lv,f1,f2)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c32083023.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c32083023.matfilter1,nil,c)
		g2=mg:Filter(c32083023.matfilter2,nil,c)
		g3=mg:Filter(c32083023.matfilter1,nil,c)
		g4=mg:Filter(c32083023.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c32083023.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c32083023.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c32083023.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c32083023.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c32083023.synfilter2,1,tuner,c,lv-tlv,g2,g4,f1,tuner)
		else
			return c32083023.synfilter2(pe:GetOwner(),c,lv-tlv,g2,nil,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c32083023.synfilter1,1,nil,c,lv,g1,g2,g3,g4)
	else
		return c32083023.synfilter1(pe:GetOwner(),c,lv,g1,g2,g3,g4)
	end
end
function c32083023.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c32083023.matfilter1,nil,c)
		g2=mg:Filter(c32083023.matfilter2,nil,c)
		g3=mg:Filter(c32083023.matfilter1,nil,c)
		g4=mg:Filter(c32083023.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c32083023.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c32083023.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c32083023.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c32083023.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
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
			local t2=g1:FilterSelect(tp,c32083023.synfilter2,1,1,tuner,c,lv-lv1,g2,g4,f1,tuner)
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
			m3=g4:FilterSelect(tp,c32083023.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		else
			m3=g2:FilterSelect(tp,c32083023.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		end
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		local hand=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c32083023.synfilter1,1,1,nil,c,lv,g1,g2,g3,g4)
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
			local t2=g3:FilterSelect(tp,c32083023.synfilter2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		else
			local t2=g1:FilterSelect(tp,c32083023.synfilter2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local m3=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not tuner2:IsLocation(LOCATION_HAND))
			or tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			m3=g4:FilterSelect(tp,c32083023.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		else
			m3=g2:FilterSelect(tp,c32083023.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		end
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c32083023.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c32083023.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c32083023.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c32083023.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c32083023.cfilter(c)
	return c:IsSetCard(0x7D53)
end
function c32083023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32083023.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32083023.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32083023.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32083023.spfilter(c)
	return c:IsSetCard(0x7D53)
end
function c32083023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32083023.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end