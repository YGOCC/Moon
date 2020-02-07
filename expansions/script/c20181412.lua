--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigEvoluteType(c)
	aux.AddOrigPandemoniumType(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cid.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cid.etarget)
	e2:SetValue(cid.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCondition(aux.PandActCheck)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.target)
	e3:SetOperation(cid.activate)
	c:RegisterEffect(e3)
	aux.EnablePandemoniumAttribute(c,e3,true,TYPE_EFFECT+TYPE_EVOLUTE+TYPE_XYZ)
	aux.AddEvoluteProc(c,nil,10,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR))
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_EVOLUTE) end)
	e4:SetTarget(cid.sptg)
	e4:SetOperation(cid.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(function(e,c) return -Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR),e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*100 end)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e6:SetCost(cid.descost)
	e6:SetTarget(cid.tg)
	e6:SetOperation(cid.operation)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetTarget(cid.pentg)
	e7:SetOperation(cid.penop)
	c:RegisterEffect(e7)
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_DINOSAUR) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PANDEMONIUM)==SUMMON_TYPE_PANDEMONIUM
end
function cid.etarget(e,c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DINOSAUR)
end
function cid.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
function cid.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_PANDEMONIUM)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,3,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cid.filter(c,e,tp)
	return c:IsType(TYPE_PANDEMONIUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cid.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,5,REASON_COST) end
	e:GetHandler():RemoveEC(tp,5,REASON_COST)
end
function cid.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*500
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)
	local g=Duel.GetMatchingGroup(cid.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local d=Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	if d==0 then return end
	local g=Duel.GetMatchingGroup(cid.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,d)
	Duel.Destroy(g,REASON_EFFECT)
end
function cid.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and aux.PandSSetCon(e:GetHandler(),nil,e:GetHandler():GetLocation(),e:GetHandler():GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp) end
end
function cid.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and aux.PandSSetCon(e:GetHandler(),nil,e:GetHandler():GetLocation(),e:GetHandler():GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp) then
		aux.PandSSet(c,REASON_EFFECT,TYPE_EFFECT+TYPE_EVOLUTE)(e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,c)
	end
end