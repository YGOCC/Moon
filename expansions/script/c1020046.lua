--Bushido God Burning Phoenix
function c1020046.initial_effect(c)
	c:SetUniqueOnField(1,0,1020046)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020046.unval)
	c:RegisterEffect(e1)
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3825890,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c1020046.ntcon)
	e2:SetOperation(c1020046.ntop)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2158562,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c1020046.descon)
	e3:SetTarget(c1020046.destg)
	e3:SetOperation(c1020046.desop)
	c:RegisterEffect(e3)
	--to def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c1020046.poscon)
	e4:SetTarget(c1020046.posfilter)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FLIP)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c1020046.flipop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10028593,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c1020046.spcon)
	e6:SetTarget(c1020046.sptg)
	e6:SetOperation(c1020046.spop)
	c:RegisterEffect(e6)
end
function c1020046.unval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020046.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4B0) and c:IsAbleToDeckAsCost()
end
function c1020046.ntcon(e,c,minc)
	if c==nil then return true end
	return minc<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c1020046.ntfilter,c:GetControler(),LOCATION_REMOVED,0,3,nil)
end
function c1020046.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1020046.ntfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1020046.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_NORMAL+1
end
function c1020046.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c1020046.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c1020046.poscon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL) and e:GetHandler():GetFlagEffect(1020046)==0
end
function c1020046.posfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetLevel()>e:GetHandler():GetLevel()
end
function c1020046.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1020046,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c1020046.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c1020046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c1020046.spfilter(c,e,tp)
	return c:IsLevelBelow(7) and c:IsSetCard(0x4B0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1020046.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c1020046.spfilter),tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end
