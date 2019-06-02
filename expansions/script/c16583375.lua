--Antilementale Caldorrente
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--attribute gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(cid.attribute)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cid.spcon)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cid.sumcon)
	e2:SetCost(cid.sumcost)
	e2:SetTarget(cid.sumtg)
	e2:SetOperation(cid.sumop)
	c:RegisterEffect(e2)
end
--filters
function cid.cfilter(c)
	return c:IsSetCard(0xa6e) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cid.cfilter2(c,g)
	return c:IsFaceup() and not g:IsExists(cid.checkattr,1,nil,c:GetOriginalAttribute())
end
function cid.checkattr(c,attr)
	return c:GetOriginalAttribute()==attr
end
function cid.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa6e) and c:IsAbleToRemoveAsCost()
end
function cid.sumtarget(e,c)
	return c:GetOriginalAttribute()==e:GetLabel()
end
function cid.attrfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa6e) and c:GetAttribute()~=e:GetHandler():GetAttribute()
end
--attribute gain
function cid.attribute(e,c)
	local g=Duel.GetMatchingGroup(cid.attrfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil,e)
	local attr=0
	for tc in aux.Next(g) do
		if bit.band(e:GetHandler():GetAttribute(),tc:GetAttribute())==0 then
			attr=bit.bor(attr,tc:GetAttribute())
		end
	end
	return attr
end
--special summon
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_MZONE,0,1,nil,eg)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
--extra summon
function cid.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end
function cid.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cid.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cid.costfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		e:SetLabel(g:GetFirst():GetOriginalAttribute())
	end
end
function cid.sumop(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetLabel(attr)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(cid.sumtarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end