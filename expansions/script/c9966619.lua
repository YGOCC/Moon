--Oscurità Irregolare - Divoratore Arcidemone
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
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4999),4,2)
	c:EnableReviveLimit()
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cid.redirect)
	c:RegisterEffect(e1)
	--draw and limit activation
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCost(cid.drawcost)
	e2:SetTarget(cid.drawtg)
	e2:SetOperation(cid.drawop)
	c:RegisterEffect(e2)
end
--filters
function cid.check_r(c,r,tp,rc)
	return bit.band(r,REASON_BATTLE)~=0 and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c~=rc
end
function cid.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x4999)
end
--attach
function cid.redirect(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local b1=a and not a:IsType(TYPE_TOKEN) and a:IsStatus(STATUS_BATTLE_DESTROYED) and a:IsControler(tp) and a~=c and d
	local b2=d and not d:IsType(TYPE_TOKEN) and d:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsControler(tp) and d~=c and a
	if (not b1 and not b2) or not c:IsOnField() or c:IsFacedown() or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsExistingMatchingCard(cid.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
			return 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetTarget(cid.reptg)
	e1:SetOperation(cid.repop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	if b1 then
		a:RegisterEffect(e1)
	else
		d:RegisterEffect(e1)
	end
end
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE)
		and Duel.IsExistingMatchingCard(cid.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	return true
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_CARD,1-tp,id)
	local g=Duel.SelectMatchingCard(tp,cid.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Overlay(g:GetFirst(),Group.FromCards(e:GetHandler()))
	end
end
--draw
function cid.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	--limit activation
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cid.actcon)
	e1:SetValue(cid.aclimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	e:GetHandler():RegisterEffect(e1)
end
function cid.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function cid.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end