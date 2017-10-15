--
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,s_id)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(s_id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(scard.thtg)
	e2:SetOperation(scard.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(s_id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(scard.spcost)
	e3:SetTarget(scard.sptg)
	e3:SetOperation(scard.spop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(scard.atkcon)
	e4:SetOperation(scard.atkop)
	c:RegisterEffect(e4)
end
function scard.thfilter(c)
	return (c:IsSetCard(0xa3) or c:IsSetCard(0x1017) or c:IsSetCard(0x43)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function scard.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and scard.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(scard.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,scard.thfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	local val=0
	for i=1,tg:GetCount() do
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then val=val+500 end
		if tg:GetCount()~=1 then tc=tg:GetNext() end
	end
	if val>0 then Duel.Recover(tp,val,REASON_EFFECT) end
end
function scard.cfilter(c,e,tp)
	local lv=c:GetLevel()
	if c:GetControler()==tp then
		return lv>0 and c:IsType(TYPE_SYNCHRO) and c:IsReleasable()
			and Duel.IsExistingMatchingCard(scard.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
	else
		return lv>0 and c:IsType(TYPE_SYNCHRO) and c:IsReleasable() and c:IsFaceup()
			and Duel.IsExistingMatchingCard(scard.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
	end
end
function scard.spfilter(c,e,tp,lv)
	return (c:IsSetCard(0x43) or c:IsSetCard(0xa3)) and c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function scard.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,scard.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function scard.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scard.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function scard.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>1 then return end
	local ec=eg:GetFirst()
	return Duel.GetTurnPlayer()~=tp
		and ec:IsPreviousLocation(LOCATION_EXTRA) and ec:GetPreviousControler()==tp and ec:IsType(TYPE_SYNCHRO)
end
function scard.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not eg then return end
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
	end
end
