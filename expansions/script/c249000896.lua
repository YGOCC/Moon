--Effect-Magician Kitsune
function c249000896.initial_effect(c)
	if not c249000896_CopyEffect then
		c249000896_CopyEffect=Card.CopyEffect
		Card.CopyEffect = function(c,code,reset_flag, reset_count)
			c:RegisterFlagEffect(249000896,reset,0,reset_count)
			c249000896_CopyEffect(c,code,reset_flag, reset_count)
		end
	end
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30312361,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,249000896)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000896.condition)
	e1:SetCost(c249000896.cost)
	e1:SetTarget(c249000896.target)
	e1:SetOperation(c249000896.operation)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000896.spcon)
	c:RegisterEffect(e2)
end
function c249000896.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c249000896.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c249000896.costfilter(c)
	return c:IsSetCard(0x2098) and c:IsAbleToRemoveAsCost()
end
function c249000896.costfilter2(c)
	return c:IsSetCard(0x2098) and not c:IsPublic()
end
function c249000896.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000896.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000896.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000896.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000896.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000896.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000896.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000896.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000896.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000896.targetfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c249000896.targetfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,c)
end
function c249000896.targetfilter2(c)
	return c:GetFlagEffect(2490000894)==0
end
function c249000896.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000896.targetfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c249000896.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000896.targetfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc==nil then return end
	local g2=Duel.SelectMatchingCard(tp,c249000896.targetfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,tc)
	local tc2=g2:GetFirst()
	if tc2==nil then return end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local ac
	local cc
	repeat
		ac=Duel.AnnounceCardFilter(tp,tc:GetOriginalRace(),OPCODE_ISRACE,tc:GetOriginalAttribute(),OPCODE_ISATTRIBUTE,OPCODE_AND,TYPE_EFFECT,OPCODE_ISTYPE,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_RITUAL,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND,3027001,OPCODE_ISCODE,OPCODE_OR)
		cc=Duel.CreateToken(tp,ac)
		if ac==3027001 then return end
	until (cc:IsSummonableCard()
		and (cc:GetLevel()==tc:GetLevel() or cc:GetLevel()+1==tc:GetLevel() or cc:GetLevel()-1==tc:GetLevel()))
	Duel.ConfirmCards(1-tp,Group.FromCards(cc))
	tc2:CopyEffect(ac,RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END,1)
	--add code
	local e1=Effect.CreateEffect(tc2)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END,1)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(ac)
	tc2:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_PUBLIC)
	tc2:RegisterEffect(e2)
end

