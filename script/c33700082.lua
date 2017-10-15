--动物朋友 东之青龙
function c33700082.initial_effect(c)
	 c:EnableReviveLimit()
	--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700082,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700082.target)
	e1:SetOperation(c33700082.operation)
	c:RegisterEffect(e1)
   --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c33700082.spcon)
	e2:SetOperation(c33700082.spop)
	c:RegisterEffect(e2)
end
function c33700082.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<hg then return false end
		return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c33700082.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700082.tfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c33700082.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.ConfirmDecktop(tp,hg)
	local g=Duel.GetDecktopGroup(tp,hg)
	if g:GetCount()>0 then
	 if g:GetClassCount(Card.GetCode)==g:GetCount() and g:IsExists(c33700082.spfilter,1,nil,e,tp) and not g:IsExists(c33700082.tfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
   else 
	  Duel.DisableShuffleCheck()
   end
end
end
function c33700082.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsAbleToGraveAsCost()
   and c:IsSummonableCard()
end
function c33700082.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c33700082.confilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and mg:CheckWithSumEqual(Card.GetLevel,4,1,5,c)
end
function c33700082.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c33700082.confilter,tp,LOCATION_MZONE,0,nil)
	local g=mg:SelectWithSumEqual(tp,Card.GetLevel,4,1,5,nil)
	Duel.SendtoGrave(g,REASON_COST)
end