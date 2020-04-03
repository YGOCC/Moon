--Moon's Dream: Org XIII
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
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsCode,104242585),3,true)
	aux.AddContactFusionProcedure(c,cid.fragment,LOCATION_REMOVED,0,Duel.Exile,REASON_RULE)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTORY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.condition)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.rmtg)
	e1:SetOperation(cid.rmop)
	c:RegisterEffect(e1)
		--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32617464,0))
	e2:SetCategory(CATEGORY_DESTORY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
end
---Filters
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.moondream(c)
	return c:IsSetCard(0x666) and c:IsFaceup()
end
--pops
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44335251,2))
		local a=Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil)
		local b=Duel.IsExistingMatchingCard(cid.moondream,tp,LOCATION_ONFIELD,0,1,nil)
if chk==0 then return a or b end
if a and b then
	op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
elseif a then
	op=0
elseif b then
	op=1
end
if op==0 then
	local tc=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_COST)
	end
end
if op==1 then
	local g=Duel.SelectMatchingCard(tp,cid.moondream,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	end
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTORY,g,1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end