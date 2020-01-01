--created by Moon Burst, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(function(e,c) if c==nil then return true end return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,id-9,id-8) end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cid.eqtg)
	e1:SetOperation(cid.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(cid.eqlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetCondition(function() local ph=Duel.GetCurrentPhase() return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE end)
	e5:SetCost(cid.cost)
	e5:SetTarget(cid.tg)
	e5:SetOperation(cid.op)
	c:RegisterEffect(e5)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetTarget(cid.ctg)
	e3:SetOperation(cid.cop)
	c:RegisterEffect(e3)
	c:SetUniqueOnField(1,0,id)
end
function cid.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsCode(id-9,id-8) and ct2==0
end
function cid.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cid.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not cid.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cid.eqlimit(e,c)
	return c:IsCode(id-9,id-8)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function cid.thfilter(c)
	return c:IsLevelBelow(4) and c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cid.cfilter(c)
	return c:IsCode(id+5) and c:IsCanAddCounter(0xa88)
end
function cid.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cid.cfilter(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) end
end
function cid.cop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)==LOCATION_SZONE and not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if cid.cfilter(tc) then tc:AddCounter(0xa88,1) end
end
