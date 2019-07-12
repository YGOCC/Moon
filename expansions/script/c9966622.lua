--Oscurità Irregolare - Sovrano Zombie, Des Ankor
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
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()
	--xyz limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetCondition(cid.xyzlim)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.attachtg)
	e2:SetOperation(cid.attachop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(cid.spcon)
	e3:SetCost(cid.spcost)
	e3:SetTarget(cid.sptg)
	e3:SetOperation(cid.spop)
	c:RegisterEffect(e3)
end
--filters
function cid.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cid.xyzfixfilter(c)
	return c:GetOverlayCount()>0
end
--xyz limit
function cid.xyzlim(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
--battle attach
function cid.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsControler(1-tp) end
end
function cid.attachop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and e:GetHandler():IsRelateToEffect(e) then
		local dg=tc:GetOverlayGroup()
		if #dg>0 then
			Duel.SendtoGrave(dg,REASON_RULE)
		end
		Duel.Overlay(e:GetHandler(),Group.FromCards(d))
	end
end
--spsummon
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=13
end
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)-1)
		and e:GetHandler():GetOverlayGroup():IsExists(cid.spfilter,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	local dgc=dg:GetCount()
	if dgc<=0 or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local xyzfix=dg:Filter(cid.xyzfixfilter,nil)
	if #xyzfix>0 then
		for xyztc in aux.Next(xyzfix) do
			Duel.SendtoGrave(xyztc:GetOverlayGroup(),REASON_RULE)
		end
	end
	Duel.Overlay(e:GetHandler(),dg)
	local check=0
	for tc in aux.Next(dg) do
		if e:GetHandler():GetOverlayGroup():IsContains(tc) then
			check=check+1
		end
	end
	if check>=dgc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetOverlayGroup():IsExists(cid.spfilter,1,nil,e,tp) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=e:GetHandler():GetOverlayGroup():FilterSelect(tp,cid.spfilter,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 and tc:IsFaceup() then
				local ng=e:GetHandler():GetOverlayGroup()
				Duel.Overlay(tc,ng)
				Duel.BreakEffect()
				Duel.Overlay(tc,e:GetHandler())
			end
		end
	end
end