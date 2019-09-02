--Starlignment of Forest Elements - Guru
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
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
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
--FLAG LIST
-- id: Marks a monster that already underwent through the "prevent effect" procedure

--search
function cid.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cid.thfilter(c)
	return c:IsSetCard(0x2595) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_PYRO) and c:IsAbleToHand()
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
		--spsummon
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
		--token
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,id+200)
		e1:SetCondition(cid.tkcon)
		e1:SetCost(cid.tkcost)
		e1:SetTarget(cid.tktg)
		e1:SetOperation(cid.tkop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
--spsummon
function cid.tgfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WINDBEAST) and c:IsAbleToGrave() and c:IsSetCard(0x2595)
		and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)))
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.HintSelection(sg)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--damage
function cid.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_PYRO)
end
function cid.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cid.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cid.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rac=0
		local crac=1
		while bit.band(RACE_ALL,crac)~=0 do
			local catt=1
			for iatt=0,7 do
				if Duel.IsPlayerCanSpecialSummonMonster(tp,id-1000,0x2595,0x4011,1500,1800,4,crac,catt) then
					rac=rac+crac
					break
				end
				catt=catt*2
			end
			crac=crac*2
		end
		e:SetLabel(rac)
		return rac~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local crac=Duel.AnnounceRace(tp,1,e:GetLabel())
	local att=0
	local catt=1
	for iatt=0,7 do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,id-1000,0x2595,0x4011,1500,1800,4,crac,catt) then
			att=att+catt
		end
		catt=catt*2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	catt=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(crac)
	Duel.SetTargetParam(catt)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cid.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local rac=e:GetLabel()
	local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id-1000,0x2595,0x4011,1500,1800,4,rac,att) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,id-1000)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(rac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end