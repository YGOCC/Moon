--Moon Burst: Org XIII
local card = c210424277
function card.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x666),2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Special Summon Banished
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,210424285)
	e1:SetTarget(card.stg)
	e1:SetOperation(card.sop)
	c:RegisterEffect(e1)
	--Special Summon Banished (Quick Effect during Chain)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_QUICK_O)
	e1x:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1x:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1x:SetCode(EVENT_FREE_CHAIN)
	e1x:SetRange(LOCATION_PZONE)
	e1x:SetCountLimit(1,210424285)
	e1x:SetCondition(card.scon_quick)
	e1x:SetTarget(card.stg)
	e1x:SetOperation(card.sop)
	c:RegisterEffect(e1x)
	--Special Summon Banished (Battle Trigger)
--	local e2=e1:Clone()
--	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
--	e2:SetCode(EVENT_BE_BATTLE_TARGET)
--	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
--	e2:SetCondition(card.battlecon)
--	c:RegisterEffect(e2)
	--Special Summon Banished (Chain Trigger)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	e3:SetCondition(card.checkchain)
	e3:SetOperation(card.setchain)
	c:RegisterEffect(e3)
		--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTarget(card.desreptg)
	e6:SetOperation(card.desrepop)
	c:RegisterEffect(e6)
		--Protect (Banish replace)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_RELEASE_REPLACE)
	--Banish target
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(4066,0))
	e8:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,210424286)
	e8:SetCost(card.cost)
	e8:SetTarget(card.rtg)
	e8:SetOperation(card.rop)
	c:RegisterEffect(e8)
		--Move to scale
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(4591250,0))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e9:SetCondition(card.spcon)
	e9:SetTarget(card.scaletg)
	e9:SetOperation(card.scaleop)
	c:RegisterEffect(e9)
		local e10=e9:Clone()
	e10:SetCode(EVENT_REMOVE)
		--pierce
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_PIERCE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	c:RegisterEffect(e11)
end
--filters
function card.repfilter(c,e)
	return c:IsSetCard(0x666) and c:IsFaceup()
		and c:IsAbleToRemove()
end
function card.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function card.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function card.pendfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function card.swapfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
function card.swapfilter2(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
function card.todeckfilter(c)
	return c:IsSetCard(0x666) and c:IsAbleToDeck() and c:IsFaceup()
end
function card.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
	and Duel.IsExistingMatchingCard(card.filter2,tp,LOCATION_REMOVED,0,1,nil,code,e,tp)
end
function card.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--Battle Trigger
function card.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x666)
end
--Chain Trigger
function card.checkchain(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(card.pendfilter,1,nil,tp)
end
function card.setchain(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(210424285,RESET_CHAIN,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
end
function card.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
--swap
function card.scaletg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and card.swapfilter1(chkc,e,tp))
	 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(card.swapfilter1,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(42378577,2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function card.scaleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,card.swapfilter1,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and
	not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
end
end
end
--Shuffle 2; banish target
function card.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(card.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,card.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function card.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return 
	Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function card.rop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	if tg1:GetFirst():IsRelateToEffect(e) then
		Duel.Destroy(tg1,REASON_EFFECT)
	end
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.Remove(tg2,POS_FACEDOWN,REASON_EFFECT)
	end
end
--Destroy replace
function card.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(card.repfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,card.repfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function card.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
----Special Summon Banished(Operation)
function card.scon_quick(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(210424285)>0
end
function card.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	and Duel.IsExistingTarget(card.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
	local rg=Duel.SelectTarget(tp,card.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TARGET,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function card.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local code=rg:GetFirst():GetCode()
	local g=Duel.SelectMatchingCard(tp,card.filter2,tp,LOCATION_REMOVED,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end