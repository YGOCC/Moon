--Antilementale Ruscintilla
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
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cid.attribute)
	c:RegisterEffect(e1)
	--add
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.thtg)
	e2:SetOperation(cid.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(cid.spcon)
	e3:SetTarget(cid.sptg)
	e3:SetOperation(cid.spop)
	c:RegisterEffect(e3)
end
--filters
function cid.cfilter(c,attr)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa6e) and c:IsAttribute(attr)
end
function cid.rcfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function cid.thfilter(c,code)
	return c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(code) and (c:IsSetCard(0xa6e) or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_FIRE)))
end
function cid.chkfilter(c,att)
	return c:IsFaceup() and c:IsSetCard(0xa6e) and c:IsAttribute(att)
end
function cid.checktrigger(c)
	return c:IsFaceup() and c:IsSetCard(0xa6e)
end
function cid.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cid.checktrigger,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
--spsummon proc
function cid.spsumcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(cid.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttribute())
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
--add
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.rcfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.rcfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			local code=Duel.GetOperatedGroup():GetFirst():GetCode()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local th=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,code)
			if th:GetCount()>0 then
				Duel.SendtoHand(th,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,th)
			end
		end
	end
end
--special summon
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PANDEMONIUM)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end