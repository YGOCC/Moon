--Starlignment of the Skies - Pluutoni
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,4),2,2)
	--protection
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(cid.prttg)
	e0:SetValue(aux.indoval)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cid.thcost)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
	--extra effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cid.eop)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2x)
	local e2y=e2:Clone()
	e2y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2y)
end
--filters
function cid.prttg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsRank(4)
end
--search
function cid.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cid.thfilter(c)
	return c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cid.hcheck(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local og=g:Filter(cid.hcheck,nil,tp)
			if #og<=0 then return end
			Duel.ConfirmCards(1-tp,og)
			for tc in aux.Next(og) do
				--prevent hand effects
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(cid.actlimit)
				e1:SetLabel(tc:GetOriginalCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
--SECONDARY-LEVEL EFFECT: prevent hand effects
function cid.actlimit(e,re,tp)
	return re:GetHandler():GetOriginalCode()==e:GetLabel() and bit.band(re:GetRange(),LOCATION_HAND)>0
end
--extra effects
function cid.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if opt==0 then
		--spsummon xyz
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCountLimit(1,id+100)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(cid.sptg)
		e1:SetOperation(cid.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	else
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,id+200)
		e1:SetTarget(cid.pttg)
		e1:SetOperation(cid.ptop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
--spsummon xyz
function cid.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2595)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(cid.matfilter,tp,LOCATION_HAND,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g1<=0 then return end
	if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)>0 then
		local og=Duel.GetOperatedGroup():GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectMatchingCard(tp,cid.matfilter,tp,LOCATION_HAND,0,1,2,nil)
		if #g2>0 then
			Duel.ConfirmCards(1-tp,g2)
			Duel.Overlay(og,g2)
		end
	end
end
--target protection
function cid.tgfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2595) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function cid.cfilter(c,e,tp,id)
	if not id then return false end
	if id==0 then
		return (c:IsType(TYPE_MONSTER) and c:IsRank(4) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,tp) and Duel.GetLocationCountFromEx(tp)>0)
			or c:IsAbleToRemove()
	elseif id==1 then
		return c:IsType(TYPE_MONSTER) and c:IsRank(4) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,tp) and Duel.GetLocationCountFromEx(tp)>0
	else
		return c:IsAbleToRemove()
	end
end
function cid.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(cid.cfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function cid.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP) then
			local extra=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(cid.cfilter,nil,e,tp,0)
			if #extra>0 then
				if extra:IsExists(cid.cfilter,1,nil,e,tp,1) then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
					local sg=extra:FilterSelect(1-tp,cid.cfilter,1,1,nil,e,tp,1)
					if #sg>0 then
						Duel.SpecialSummon(sg,0,1-tp,tp,false,false,POS_FACEUP)
					end
				else
					local sg=extra:RandomSelect(1-tp,1)
					Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCondition(cid.checkrl)
	e1:SetOperation(cid.raiseflag)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetOperation(cid.draw)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cid.checkrl(e,tp,eg,ep,ev,re,r,rp)
	return eg and re and #eg==1 and eg:GetFirst():IsSetCard(0x2595) and eg:GetFirst():IsReason(REASON_COST)
		and re:GetHandler()==eg:GetFirst()
end
function cid.raiseflag(e,tp,eg,ep,ev,re,r,rp)
	eg:GetFirst():RegisterFlagEffect(id,0,EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1)
end
function cid.draw(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) or re:GetHandler():GetFlagEffect(id)<=0 then return end
	re:GetHandler():ResetFlagEffect(id)
	Duel.Hint(HINT_CARD,0,id)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end