--Zero Revenge
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
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(87259933,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate(spsummon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(scard.spcon)
	e1:SetCost(scard.spcost)
	e1:SetTarget(scard.sptg1)
	e1:SetOperation(scard.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(s_id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(scard.spcon)
	e2:SetCost(scard.spcost)
	e2:SetTarget(scard.sptg2)
	e2:SetOperation(scard.spop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87259933,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(scard.thcost)
	e3:SetTarget(scard.thtg)
	e3:SetOperation(scard.thop)
	c:RegisterEffect(e3)
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
function scard.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousSetCard(0x8) and c:GetPreviousControler()==tp
end
function scard.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp)
end
function scard.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(s_id)==0 end
	e:GetHandler():RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function scard.filter(c,e,tp)
	return c:IsZHERO() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function scard.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(scard.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function scard.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(scard.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scard.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function scard.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function scard.thfilter1(c,rc)
	return c:IsFaceup() and c:IsZHERO() and c:IsAbleToDeck()
		and Duel.IsExistingTarget(scard.thfilter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,rc)
end
function scard.thfilter2(c,rc)
	return c~=rc and c:IsAbleToDeck()
end
function scard.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(scard.thfilter1,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,scard.thfilter1,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,1,nil,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,scard.thfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst(),e:GetHandler())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
