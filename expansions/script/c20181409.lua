--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigPandemoniumType(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cid.pslimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(cid.cost)
	e5:SetTarget(cid.target)
	e5:SetOperation(cid.activate)
	c:RegisterEffect(e5)
	aux.EnablePandemoniumAttribute(c,e5,true,TYPE_EFFECT+TYPE_FUSION)
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsType,TYPE_PANDEMONIUM),2,63,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cid.sprcon)
	e1:SetOperation(cid.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(cid.splimit)
	c:RegisterEffect(e6)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e2:SetTarget(cid.destg)
	e2:SetOperation(cid.desop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.tg)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCondition(function(e) return e:GetHandler():IsReason(REASON_EFFECT) end)
	e7:SetTarget(cid.pentg)
	e7:SetOperation(cid.penop)
	c:RegisterEffect(e7)
end
function cid.cmfilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function cid.sprcon(e,c)
	if c==nil then return true end
	if c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cid.cmfilter,tp,LOCATION_MZONE,0,c,c)
	return c:CheckFusionMaterial(mg,nil,tp)
end
function cid.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cid.cmfilter,tp,LOCATION_MZONE,0,c,c)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cid.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cid.pslimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_DINOSAUR) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PANDEMONIUM)==SUMMON_TYPE_PANDEMONIUM
end
function cid.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x9b5) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM+TYPE_PENDULUM) or c:IsLocation(LOCATION_HAND))
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cid.activate(e)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local mat=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,mat,nil)
	Duel.HintSelection(g)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cid.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and aux.PandSSetCon(e:GetHandler(),nil,e:GetHandler():GetLocation(),e:GetHandler():GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp) end
end
function cid.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and aux.PandSSetCon(e:GetHandler(),nil,e:GetHandler():GetLocation(),e:GetHandler():GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp) then
		aux.PandSSet(c,REASON_EFFECT,TYPE_EFFECT+TYPE_FUSION)(e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,c)
	end
end
