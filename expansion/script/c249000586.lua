---Divine-Angel Xyz Star
function c249000586.initial_effect(c)
	--count
	if not c249000586.global_check then
		c249000586.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c249000586.gecheckop)
		Duel.RegisterEffect(ge1,0)
	end
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000586.condition)
	e1:SetCost(c249000586.cost)
	e1:SetTarget(c249000586.target)
	e1:SetOperation(c249000586.operation)
	c:RegisterEffect(e1)
end
function c249000586.gecheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),249000586,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c249000586.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,249000586)<=1
end
function c249000586.costfilter(c)
	return c:IsSetCard(0x1D3) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000586.costfilter2(c,e)
	return c:IsSetCard(0x1D3) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000586.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) and (Duel.IsExistingMatchingCard(c249000586.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000586.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000586.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000586.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000586.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000586.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000586.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000586.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
		Duel.PayLPCost(tp,1500)
end
function c249000586.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c249000586.filter2,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp,c) and c:IsAbleToGrave()
end
function c249000586.filter2(c,lv,e,tp,c2)
	return (c:GetRank()==lv or c:GetRank()==lv-1 or c:GetRank()==lv+1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000586.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c249000586.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000586.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000586.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	if g and Duel.SendtoGrave(g,REASON_EFFECT) then
		local g2=Duel.SelectMatchingCard(tp,c249000586.filter2,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,tc)
		local sc=g2:GetFirst()
		if sc then
			ac=Duel.AnnounceCard(tp)
			mc=Duel.CreateToken(tp,ac)
			while not (mc:IsRace(sc:GetRace()) and mc:IsAttribute(sc:GetAttribute()))
			do
				ac=Duel.AnnounceCard(tp)
				mc=Duel.CreateToken(tp,ac)
			end
			Duel.SendtoDeck(mc,nil,0,REASON_RULE)
			local ovg=Group.FromCards(mc)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				ovg:AddCard(tc2)
			end
			sc:SetMaterial(ovg)
			Duel.Overlay(sc,ovg)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c249000586.splimit)
			e1:SetLabel(sc:GetCode())
			Duel.RegisterEffect(e1,tp)
			--cannot attack
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetReset(RESET_EVENT+0x3fe0000)
			e2:SetCondition(c249000586.atkcon)
			e2:SetTarget(c249000586.atktg)
			sc:RegisterEffect(e2)
			--check
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EVENT_ATTACK_ANNOUNCE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetOperation(c249000586.checkop)
			e3:SetReset(RESET_EVENT+0x3fe0000)
			e3:SetLabelObject(e2)
			sc:RegisterEffect(e3)
			sc:CompleteProcedure()
		end
	end
end
function c249000586.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsCode(e:GetLabel())
end
function c249000586.atkcon(e)
	return e:GetHandler():GetFlagEffect(249000586)~=0
end
function c249000586.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c249000586.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(249000586)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(249000586,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end