--Effect-Magician Guard
function c249000895.initial_effect(c)
	if not c249000894_CopyEffect then
		c249000894_CopyEffect=Card.CopyEffect
		Card.CopyEffect = function(c,code,reset_flag, reset_count)
			c:RegisterFlagEffect(249000894,reset,0,reset_count)
			c249000894_CopyEffect(c,code,reset_flag, reset_count)
		end
	end
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30312361,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,249000895)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000895.condition)
	e1:SetCost(c249000895.cost)
	e1:SetTarget(c249000895.target)
	e1:SetOperation(c249000895.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64262809,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c249000895.spcon)
	e2:SetCost(c249000895.spcost)
	e2:SetTarget(c249000895.sptg)
	e2:SetOperation(c249000895.spop)
	c:RegisterEffect(e2)
end
function c249000895.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c249000895.costfilter(c)
	return c:IsSetCard(0x2098) and c:IsAbleToRemoveAsCost()
end
function c249000895.costfilter2(c)
	return c:IsSetCard(0x2098) and not c:IsPublic()
end
function c249000895.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000895.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000895.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000895.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000895.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000895.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000895.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000895.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000895.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000895.targetfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c249000895.targetfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,c)
end
function c249000895.targetfilter2(c)
	return c:GetFlagEffect(2490000894)==0
end
function c249000895.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000895.targetfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c249000895.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000895.targetfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc==nil then return end
	local g2=Duel.SelectMatchingCard(tp,c249000895.targetfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,tc)
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
function c249000895.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c249000895.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000895.cfilter,1,nil,tp)
end
function c249000895.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc=(e:GetHandler():IsLocation(LOCATION_HAND) and not e:GetHandler():IsAbleToGraveAsCost()) and e:GetHandler() or nil
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,exc) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,exc)
end
function c249000895.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetTargetCard(e:GetHandler())
end
function c249000895.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end