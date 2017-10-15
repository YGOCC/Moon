--Change Sentai - Pink
function c249000060.initial_effect(c)
	c:SetUniqueOnField(1,0,249000060)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000060.cost)
	e1:SetTarget(c249000060.target)
	e1:SetOperation(c249000060.operation)
	c:RegisterEffect(e1)
	--summon & set with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75498415,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c249000060.ntcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
end
function c249000060.costfilter(c)
	return c:IsSetCard(0x155) and c:IsAbleToRemoveAsCost()
end
function c249000060.costfilter2(c)
	return c:IsSetCard(0x155) and not c:IsPublic()
end
function c249000060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000060.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	or Duel.IsExistingMatchingCard(c249000060.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	local option
	if Duel.IsExistingMatchingCard(c249000060.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000060.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000060.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000060.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000060.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000060.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c249000060.disfilter(c)
	return c:IsDiscardable() and c:GetAttribute()~=0
end
function c249000060.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
		local sg=Duel.SelectMatchingCard(tp,c249000060.disfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=sg:GetFirst()
		if sg:GetCount()==0 then return end
		if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)==0 then return end
		local ac=Duel.AnnounceCardFilter(tp,0x8,OPCODE_ISSETCARD,0xA008,OPCODE_ISSETCARD,OPCODE_NOT,OPCODE_AND,tc:GetOriginalAttribute(),OPCODE_ISATTRIBUTE,OPCODE_AND)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(ac)
		c:RegisterEffect(e1)
		c:CopyEffect(ac,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(c249000060.damcon)
		e2:SetOperation(c249000060.damop)
		c:RegisterEffect(e2)
		c:CopyEffect(ac,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end
function c249000060.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c249000060.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c249000060.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
end