--Moon's Dream: New Dawn
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
	c:SetUniqueOnField(1,0,id)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsCode,104242585),1,true)
	aux.AddContactFusionProcedure(c,cid.fragment,LOCATION_REMOVED,0,Duel.Exile,REASON_RULE)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(cid.con)
	e1:SetCost(cid.cost)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
	--make fragment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1000)
	e2:SetOperation(cid.frag)
	c:RegisterEffect(e2)
end
function cid.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0 and Duel.GetAttackTarget()==c
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) end
	local tc=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
	Duel.Exile(tc,REASON_COST)
	e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.frag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end