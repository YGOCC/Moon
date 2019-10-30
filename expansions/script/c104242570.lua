--Moon's Dream, A Tiny Pony
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
		c:EnableReviveLimit()
	--ritual summon, banish card from opp's grave and draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(cid.ritualcondition)
	e1:SetTarget(cid.ritualtarget)
	e1:SetOperation(cid.ritualdraw)
	c:RegisterEffect(e1)
	--bounce and limit targets
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+1000)
	e2:SetCost(cid.bouncecost)
	e2:SetOperation(cid.notarget)
	c:RegisterEffect(e2)
end
--bounce and limit targets
function cid.bouncecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cid.notarget(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTarget(cid.efilter)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(aux.tgoval)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cid.efilter(e,c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--ritual summon, banish card from opp's grave and draw
function cid.ritualcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cid.ritualtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.ritualdraw(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0
then
	Duel.Draw(tp,1,REASON_EFFECT)
    end
end
end
