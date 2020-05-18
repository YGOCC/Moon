--Moon's Dream: KeyBlade's Chosen
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
	Fusion.AddProcMixN(c,true,true,cid.pony,2,aux.FilterBoolFunctionEx(Card.IsType,TYPE_MONSTER),1)
	Fusion.AddContactProc(c,cid.contactfil,cid.contactop)
	else if not Card.Type then
	aux.AddFusionProcCode2FunRep(c,cid.pony,cid.fusion,cid.fusion,1,1,true,true)
	aux.AddContactFusionProcedure(c,cid.contactfil,LOCATION_ONFIELD+LOCATION_EXTRA,0,cid.contactop)
	end
	end
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	--no response
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cid.poscon)
	e2:SetTarget(cid.postg)
	e2:SetOperation(cid.posop)
	c:RegisterEffect(e2)
	--Nirvana nerf
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(cid.desop)
    c:RegisterEffect(e4)
end
function cid.desfilter(c,tp)
    return c:IsControler(tp) and c:IsSetCard(0x666)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not eg:IsExists(cid.desfilter,1,nil,tp) then return end
    local a=eg:Filter(cid.desfilter,nil,tp):GetFirst()
    local cg=a:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
    if cg:GetCount() > 0 then Duel.Destroy(cg,REASON_EFFECT) end
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
function cid.fusion(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--Filters

--Draw till 3
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=3-Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=3-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
--During BP, no response
function cid.poscon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cid.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDefensePos() end
	if chk==0 then return  Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and
	Duel.IsExistingMatchingCard(cid.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cid.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cid.posop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		end
			if frag and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
			end
end
	local tg=Duel.GetMatchingGroup(cid.pony,tp,LOCATION_MZONE,0,nil)
		local tc=tg:GetFirst()
		while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,1)
		e2:SetValue(cid.aclimit)
		e2:SetCondition(cid.actcon)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
end
end
function cid.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cid.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end


