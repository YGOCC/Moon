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
		if Card.Type then 
	Fusion.AddProcMixN(c,true,true,cid.pony,2,aux.FilterBoolFunctionEx(Card.IsType,TYPE_MONSTER),1)
	Fusion.AddContactProc(c,cid.contactfil,cid.contactop)
	else if not Card.Type then
	aux.AddFusionProcCode2FunRep(c,cid.pony,cid.pony,cid.fusion,1,1,true,true)
	aux.AddContactFusionProcedure(c,cid.contactfil,LOCATION_ONFIELD+LOCATION_EXTRA,0,cid.contactop)
	end
	end
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.tgtg)
	e1:SetOperation(cid.tgop)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(cid.remtg)
	e3:SetOperation(cid.remop)
	c:RegisterEffect(e3)
		--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cid.atkval)
	c:RegisterEffect(e5)
end
--summon procs
function cid.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsFaceup() end,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
end
function cid.contactop(g,tp)
	Duel.Release(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function cid.pony(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsCanBeFusionMaterial()
end
function cid.fusion(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--Filters
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.searchfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsAbleToHand()
end
--banish on summon
function cid.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--pop 1 and token
function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end	
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		end
			if frag and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
			end
end
Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cid.retop)
		Duel.RegisterEffect(e1,tp)
		Duel.BreakEffect()
			if Duel.IsPlayerCanSpecialSummonMonster(tp,104242592,0,0x4011,2000,2000,3,RACE_BEAST,ATTRIBUTE_DARK) then
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,104242592)	
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
end
function cid.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
--atk boost
function cid.atkval(e,c)
	local lps=Duel.GetLP(c:GetControler())
	local lpo=Duel.GetLP(1-c:GetControler())
	if lps>=lpo then return 0
	else return lpo-lps end
end