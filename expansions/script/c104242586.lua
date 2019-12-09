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
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsCode,104242585),5,true)
	aux.AddContactFusionProcedure(c,cid.spcfilter2,LOCATION_REMOVED,0,Duel.Exile,REASON_COST)
		--special summon
--	local e1=Effect.CreateEffect(c)
--	e1:SetType(EFFECT_TYPE_FIELD)
--	e1:SetCode(EFFECT_SPSUMMON_PROC)
--	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
--	e1:SetRange(LOCATION_EXTRA)
--	e1:SetCondition(cid.spcon2)
--	e1:SetOperation(cid.spop3)
--	c:RegisterEffect(e1)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	--Multiple attacks
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97165977,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cid.condition)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
	--ATK Up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97165977,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetOperation(cid.atkop)
	c:RegisterEffect(e4)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cid.indct)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(2)
		c:RegisterEffect(e2)
	end
end
function cid.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end
--summon condition
function cid.spcfilter2(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,5,nil)
end
function cid.spop3(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
end
end
end
end
end
end