--Creation Ritual of Courage
xpcall(function() require("expansions/script/bannedlist") end,function() require("script/bannedlist") end)
function c249000913.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000913.cost)
	e1:SetTarget(c249000913.target)
	e1:SetOperation(c249000913.activate)
	c:RegisterEffect(e1)
end
function c249000913.costfilter(c)
	return c:IsSetCard(0x1FB) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000913.costfilter2(c)
	return c:IsSetCard(0x1FB) and not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c249000913.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000913.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000913.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	if Duel.GetLP(tp)< 3000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,1500)
	end
	local option
	if Duel.IsExistingMatchingCard(c249000913.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000913.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000913.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000913.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000913.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000913.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000913.tgfilter(c,mg,e)
	if not c:IsType(TYPE_MONSTER) then return false end
	local mg2=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg2:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
end
function c249000913.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
end
function c249000913.codefilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000913.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local code_table={}
	local g=Duel.GetMatchingGroup(c249000913.codefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA,0,nil)
	local i=1
	local tc=g:GetFirst()
	while tc do
		code_table[i]=tc:GetOriginalCode()
		i=i+1
		code_table[i]=OPCODE_ISCODE
		i=i+1
		code_table[i]=OPCODE_NOT
		i=i+1
		code_table[i]=OPCODE_AND
		i=i+1		
		tc=g:GetNext()
	end
	local sc
	local g
	repeat
		local announce_filter={RACE_WARRIOR,OPCODE_ISRACE,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_RITUAL,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND,table.unpack(code_table)}
		local ac=Duel.AnnounceCardFilter(tp,table.unpack(announce_filter))
		sc=Duel.CreateToken(tp,ac)
		g=Duel.GetRitualMaterial(tp)
		g=g:Filter(Card.IsCanBeRitualMaterial,sc,sc)
	until (g:CheckWithSumGreater(Card.GetRitualLevel,sc:GetOriginalLevel(),sc,sc) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and sc:IsLevelAbove(5) and not banned_list_table[ac])	
	if sc then
		local mg=Duel.GetRitualMaterial(tp)
		mg=mg:Filter(Card.IsCanBeRitualMaterial,sc,sc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,sc:GetOriginalLevel(),sc,sc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,Auxiliary.RPGFilterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,sc:GetOriginalLevel(),sc,sc)
			mat:Merge(mat2)
		end
		sc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(TYPE_RITUAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetOwnerPlayer(tp)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCondition(c249000913.sendcon)
		e2:SetOperation(c249000913.sendop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		e2:SetCountLimit(1)
		sc:RegisterEffect(e2)
	end
end
function c249000913.sendcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c249000913.sendop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end