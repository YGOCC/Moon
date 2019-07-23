--Cosmic Wing Helios by TKNight

function c900.initial_effect(c) 
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c900.ffilter,2,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c900.splimit)
	c:RegisterEffect(e1)
	--move to main monster zone from EZM (NOTE: It can move itself to another free MMZ while it is Special Summoned to a MMZ)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7093411,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c900.mcon,c900.filter)
	e2:SetTarget(c900.mtg)
	e2:SetOperation(c900.mop)
	c:RegisterEffect(e2) 
	
	--shuffle 2 SPSummon Monster into deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7093411,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c900.condition)
	e3:SetCost(c900.cost)
	e3:SetTarget(c900.target)
	e3:SetOperation(c900.operation)
	c:RegisterEffect(e3) 
end
--spsummon condition
function c900.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c900.ffilter(c)
	return c:IsSetCard(0xB3F)-- and c:IsOnField() 
end

function c900.filter(c)
	return c:GetSequence()>5 and c:IsLocation(LOCATION_MZONE)
end
--move to main monster zone from EZM condition, target and operation
function c900.mcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)-- and e:GetHandler():GetSequence()>5 
    or e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)-- and e:GetHandler():GetSequence()>5
end

function c900.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c900.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			nseq=math.log(s,2)
			Duel.MoveSequence(c,nseq)
	end
end
--to deck functions 
function c900.cfilter(c)
	return c:GetSequence()>=5
end
function c900.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c900.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--cost
function c900.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c900.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c906.negfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c900.negfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c900.tdfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToDeck()or 
	c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsAbleToDeck() or 
	c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsAbleToDeck() or 
	c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsAbleToDeck() or 
	c:IsSummonType(SUMMON_TYPE_LINK) and c:IsAbleToDeck()
end
function c900.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c900.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c900.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c900.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c900.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end