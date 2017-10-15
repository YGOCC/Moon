--Chroma-Distortion Synchro Distorter
function c249000495.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,249000495)
	e2:SetCost(c249000495.cost)
	e2:SetOperation(c249000495.op)
	c:RegisterEffect(e2)
end
function c249000495.costfilter(c)
	return c:IsSetCard(0x1C4) and c:IsAbleToRemoveAsCost()
end
function c249000495.costfilter2(c,e)
	return c:IsSetCard(0x1C4) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000495.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and (Duel.IsExistingMatchingCard(c249000495.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000495.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000495.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000495.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000495.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000495.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000495.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000495.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c249000495.filters(c)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()<=10 and c:GetLevel()%2==0
end
function c249000495.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c249000495.filters,c:GetControler(),LOCATION_EXTRA,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(1073)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		e1:SetCondition(c249000495.syncon)
		e1:SetOperation(c249000495.synop)
		e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(249000495,RESET_EVENT+RESET_PHASE+PHASE_END,0,1) 	
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c249000495.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000495.damval(e,re,val,r,rp,rc)
	return val/2
end
function c249000495.mfilter(c,lv)
	return c:GetLevel()==lv and not (c:IsFacedown() and c:IsLocation(LOCATION_MZONE))
end
function c249000495.syncon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(c249000495.mfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,lv/2)
	if mg:GetCount() < 2 then return false end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
end
function c249000495.synop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(c249000495.mfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,lv/2)
	local g1=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:Select(tp,2,2,nil)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	c:SetMaterial(g1)
end