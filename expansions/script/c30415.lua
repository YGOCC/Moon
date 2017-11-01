--Zero Rescue
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(scard.thcost)
	e2:SetTarget(scard.thtg)
	e2:SetOperation(scard.thop)
	c:RegisterEffect(e2)
	-- Duel.AddCustomActivityCounter(s_id,ACTIVITY_SPSUMMON,scard.counterfilter)
	if not scard.global_check then
		scard.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(scard.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function scard.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,30000)==0 then 
		Duel.CreateToken(tp,30000)
		Duel.CreateToken(1-tp,30000)
		Duel.RegisterFlagEffect(0,30000,0,0,0)
	end
end
function scard.counterfilter(c)
	return c:IsSetCard(0x8)
end
function scard.filter(c,e,tp)
	return c:IsSetCard(0x8) and (c:GetAttack()==0 or c:GetDefense()==0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and scard.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 --and Duel.GetCustomActivityCount(s_id,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingTarget(scard.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,scard.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	-- local e1=Effect.CreateEffect(e:GetHandler())
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	-- e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	-- e1:SetReset(RESET_PHASE+PHASE_END)
	-- e1:SetTargetRange(1,0)
	-- e1:SetTarget(scard.splimit)
	-- Duel.RegisterEffect(e1,tp)
end
function scard.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	-- if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		-- local c=e:GetHandler()
		-- local e1=Effect.CreateEffect(c)
		-- e1:SetType(EFFECT_TYPE_SINGLE)
		-- e1:SetCode(EFFECT_DISABLE)
		-- e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		-- tc:RegisterEffect(e1)
		-- local e2=Effect.CreateEffect(c)
		-- e2:SetType(EFFECT_TYPE_SINGLE)
		-- e2:SetCode(EFFECT_DISABLE_EFFECT)
		-- e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		-- tc:RegisterEffect(e2)
		-- Duel.SpecialSummonComplete()
	-- end
end
-- function scard.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	-- return not c:IsSetCard(0x8)
-- end
function scard.thfilter(c)
	return c:IsZHERO() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function scard.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,scard.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function scard.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
