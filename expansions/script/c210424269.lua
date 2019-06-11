--Moon Burst: Child of Light
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
local id2=id+1000000
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cid.lfilter,2,2)
	c:SetUniqueOnField(1,0,id)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(cid.spcon)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	--Search
--	local e2=Effect.CreateEffect(c)
--	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
--	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
--	e2:SetCode(EVENT_BECOME_TARGET)
--	e2:SetRange(LOCATION_MZONE)
--	e2:SetCountLimit(1,210424275)
--	e2:SetCondition(cid.betarget)
--	e2:SetTarget(cid.stg)
--	e2:SetOperation(cid.sop)
--	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(cid.colink)
	e3:SetTarget(cid.negtg)
	e3:SetOperation(cid.negop)
	c:RegisterEffect(e3)
	--Art swap
	local exx=Effect.CreateEffect(c)
	exx:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	exx:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx:SetCode(EVENT_ADJUST)
	exx:SetRange(LOCATION_MZONE)
	exx:SetCondition(cid.artcon)
	exx:SetOperation(cid.artop)
	c:RegisterEffect(exx)
	--Art swap
	local exx2=Effect.CreateEffect(c)
	exx2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	exx2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx2:SetCode(EVENT_ADJUST)
	exx2:SetRange(LOCATION_MZONE)
	exx2:SetCondition(cid.artcon2)
	exx2:SetOperation(cid.artop2)
	c:RegisterEffect(exx2)
end
function cid.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cid.negfilter2(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cid.colink(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetMutualLinkedGroup()
	return lg:IsExists(Card.IsSetCard,1,nil,0x666)
end
function cid.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cid.negfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(cid.negfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,cid.negfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,cid.negfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cid.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		end
	end
end
function cid.lfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666)
end
function cid.filter2(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x666)
end
function cid.betarget(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cid.filter2,1,nil,tp)
end
function cid.searchfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cid.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.searchfilter,tp,LOCATION_DECK,0,1,nil)
end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
end
function cid.filter(c,e,tp)
	return c:IsCode(id-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
	((c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (Duel.GetLocationCountFromEx(tp)>0 and c:IsLocation(LOCATION_EXTRA)))
end
function cid.spfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave() and c:IsFaceup()
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
--Art swap
function cid.artcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
  return (c:GetOriginalCode()==id or c:GetOriginalCode()==id2) and
  e:GetHandler():GetAttack()>=c:GetTextAttack()+1200
end
function cid.artop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=id2
	c:SetEntityCode(tcode,true)
	--c:ReplaceEffect(tcode,0,0)
	--	Duel.SetMetatable(c,_G["c"..tcode])
end
function cid.artcon2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
  return (c:GetOriginalCode()==id or c:GetOriginalCode()==id2) and 
  e:GetHandler():GetAttack()<c:GetTextAttack()+1200
end
function cid.artop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=id
	c:SetEntityCode(tcode,true)
--	c:ReplaceEffect(tcode,0,0)
--	Duel.SetMetatable(c,_G["c"..tcode])
end