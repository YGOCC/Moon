--Moon's Dream: Child of Night
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
	if Card.Type then 
	Fusion.AddProcMixN(c,true,true,cid.pony,1,aux.FilterBoolFunctionEx(cid.pony),1)
	Fusion.AddContactProc(c,cid.contactfil,cid.contactop)
	else if not Card.Type then
	aux.AddFusionProcFunRep(c,cid.pony,2,true)
	aux.AddContactFusionProcedure(c,cid.contactfil,LOCATION_ONFIELD+LOCATION_EXTRA,0,cid.contactop)
	end
	end
	--nerf on summon
	local nerf=Effect.CreateEffect(c)
	nerf:SetCategory(CATEGORY_ATKCHANGE)
	nerf:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	nerf:SetCode(EVENT_SPSUMMON_SUCCESS)
	nerf:SetProperty(EFFECT_FLAG_DELAY)
	nerf:SetTarget(cid.atktg)
	nerf:SetOperation(cid.atkop)
	c:RegisterEffect(nerf)
	--banish as punishment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39823987,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.destg)
	e2:SetOperation(cid.desop)
	c:RegisterEffect(e2)
	--negate
	local neg=Effect.CreateEffect(c)
	neg:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	neg:SetCode(EVENT_CHAIN_SOLVING)
	neg:SetRange(LOCATION_MZONE)
	neg:SetCountLimit(1)
	neg:SetCondition(cid.negcon)
	neg:SetOperation(cid.negop)
	c:RegisterEffect(neg)
end
--Filters
function cid.cfilter(c)
	return c:IsFaceup() and c:IsCode(104242591)
end
--summon procs
function cid.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsFaceup() end,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
end
function cid.contactop(g,tp)
	Duel.SendtoGrave(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function cid.pony(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsCanBeFusionMaterial()
end
function cid.spfilter(c,e,tp)
	return c:IsCode(id+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--banish as punishment
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetReasonCard(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetFirstMatchingCard(cid.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	local c=e:GetHandler()
	if Duel.GetLP(1-tp)<=0 or c:IsReason(REASON_BATTLE) then return end
	Duel.BreakEffect()
	Duel.Destroy(c:GetReasonCard() or (c:GetReasonEffect() and c:GetReasonEffect():GetHandler()),REASON_EFFECT)
end
--negate
function cid.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) 
end
function cid.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
--nerf on summon
function cid.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local ct=Duel.GetMatchingGroupCount(cid.atkfilter,tp,LOCATION_REMOVED,0,nil)
	while tc do
		local nerf=Effect.CreateEffect(e:GetHandler())
		nerf:SetType(EFFECT_TYPE_SINGLE)
		nerf:SetCode(EFFECT_UPDATE_ATTACK)
		nerf:SetValue(-500)
		nerf:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		nerf:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(nerf)
		local e2=nerf:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end