--Zextral Armageddon Sorcerer
function c39615023.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	aux.EnablePandemoniumAttribute(c)
	--P: To Pandemonium Summon using this card: You have to banish 5 Pandemonium monsters from your Extra Deck, Deck, GY, Field and/or Hand containing at least 1 from field, 1 from Hand and 1 from your Extra Deck or GY.
	local ps=Effect.CreateEffect(c)
	ps:SetType(EFFECT_TYPE_FIELD)
	ps:SetDescription(1074)
	ps:SetCode(EFFECT_SPSUMMON_PROC_G)
	ps:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ps:SetRange(LOCATION_SZONE)
	ps:SetCountLimit(1,10000000)
	ps:SetCondition(c39615023.paschk)
	ps:SetOperation(c39615023.pascost)
	ps:SetValue(726)
	c:RegisterEffect(ps)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_EXTRA,0)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetLabelObject(ps)
	e1:SetValue(c39615023.splimit)
	c:RegisterEffect(e1)
	--M: You can Tribute 1 monster you control (Quick Effect): Set this card in your Spell/Trap card zone.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c39615023.sstcost)
	e4:SetTarget(c39615023.ssttg)
	e4:SetOperation(c39615023.sstop)
	c:RegisterEffect(e4)
	--M: When a monster(s) is destroyed: You can Special Summon this card (from your hand), then You can set 1 Pandemonium monster directly from your Deck in your Spell/Trap zone.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(c39615023.spcon)
	e2:SetTarget(c39615023.sptg)
	e2:SetOperation(c39615023.spop)
	c:RegisterEffect(e2)
	--M: When this card leaves the field, You can tribute 1 other monster you control: Set this card in your Spell/Trap zone instead.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetTarget(c39615023.reptg)
	c:RegisterEffect(e3)
end
function c39615023.cfilter(c)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsAbleToRemoveAsCost()
end
function c39615023.ccheck(c,tp,sg,mg,ct,g)
	sg:AddCard(c)
	ct=ct+1
	local res=c39615023.cgoal(tp,sg,ct,g)
		or mg:IsExists(c39615023.ccheck,1,sg,tp,sg,mg,ct,g)
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c39615023.cgoal(tp,sg,ct,mg)
	local ct1=sg:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)
	local ct2=sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	local ct3=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_GRAVE)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>-rg:GetCount() then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,rg)>0 then loc=loc+LOCATION_EXTRA end
	return mg:FilterCount(Card.IsLocation,sg,loc)>0 and ct>=5 and ct1>0 and ct2>0 and ct3>0
end
function c39615023.paschk(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lscale=c:GetLeftScale()
	local rscale=c:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_EXTRA,0):Filter(aux.PaConditionFilter,nil,e,tp,lscale,rscale)
	local mg=Duel.GetMatchingGroup(c39615023.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(c39615023.ccheck,1,sg,tp,sg,mg,0,g)
end
function c39615023.pascost(e,tp,eg,ep,ev,re,r,rp,c,sg)
	local g=Duel.GetMatchingGroup(c39615023.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_ONFIELD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_HAND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_EXTRA+LOCATION_GRAVE)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=g:Select(tp,2,2,g1)
	g1:Merge(g4)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	aux.PandOperation(e,tp,eg,ep,ev,re,r,rp,c,sg)
end
function c39615023.splimit(e,se,sp,st)
	return st~=SUMMON_TYPE_SPECIAL+726 or se==e:GetLabelObject()
end
function c39615023.sstcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsControler,1,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsControler,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c39615023.ssttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SSET) end
end
function c39615023.sstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		aux.PandSSet(c,REASON_EFFECT)(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c39615023.spcfilter(c)
	return c:IsType(TYPE_MONSTER) or c:IsPreviousLocation(LOCATION_MZONE)
end
function c39615023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c39615023.spcfilter,1,nil)
end
function c39615023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c39615023.thfilter2(c)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM
end
function c39615023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c39615023.thfilter2,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SSET)
			and Duel.SelectYesNo(tp,1159) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c39615023.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_ONFIELD) and c:GetDestination()~=LOCATION_OVERLAY and not c:IsReason(REASON_REPLACE)
		and Duel.CheckReleaseGroup(tp,Card.IsControler,1,c,tp) end
	if Duel.SelectYesNo(tp,1159) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsControler,1,1,nil,tp)
		Duel.Release(g,REASON_EFFECT+REASON_REPLACE)
		aux.PandSSet(c,REASON_EFFECT+REASON_REPLACE)(e,tp,eg,ep,ev,re,r,rp)
		return true
	else return false end
end
