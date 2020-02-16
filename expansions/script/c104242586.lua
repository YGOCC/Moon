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
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsCode,104242585),2,true)
	aux.AddContactFusionProcedure(c,cid.fragment,LOCATION_EXTRA,0,Duel.Exile,REASON_MATERIAL)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTORY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end

---Filters
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.moondream(c)
	return c:IsSetCard(0x666) and c:IsFaceup()
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44335251,2))
		local a=Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_EXTRA,0,1,nil)
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
    local tc=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_EXTRA,0,nil,e,tp)
    if tc then
        Duel.Exile(tc,REASON_COST)
    end
end
if op==1 then
    local sg=Duel.SelectReleaseGroup(tp,cid.moondream,1,1,nil)
    Duel.Release(sg,REASON_COST)
	end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end