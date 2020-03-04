--Moon's Dream: Child of Light
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
	aux.AddFusionProcFunRep(c,cid.ponyfilter,2,true)
	aux.AddContactFusionProcedure(c,cid.ponyfilter,LOCATION_REMOVED,0,function(g) Duel.SendtoGrave(g:Filter(Card.IsSetCard,nil,0x666),REASON_MATERIAL) Duel.Exile(g:Filter(Card.IsCode,nil,104242585),REASON_RULE) end)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2956282,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.discon)
	e1:SetCost(cid.discost)
	e1:SetTarget(cid.distg)
	e1:SetOperation(cid.disop)
	c:RegisterEffect(e1)
end
function cid.ponyfilter(c,fc,sub,mg,sg)
	if c:IsFacedown() or not c:IsCanBeFusionMaterial() then return false end
	if c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) then
		return not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsCode,1,c,104242585)
	elseif c:IsCode(104242585) then
		return not sg or not sg:IsExists(Card.IsCode,1,c,104242585)
	end
	return false
end
function cid.negcostfilter(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function cid.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.negcostfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.negcostfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.Exile(g,REASON_COST)
end
function cid.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
