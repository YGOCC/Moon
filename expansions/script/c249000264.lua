--Catalyst of Darkening Evolution
function c249000264.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12538374,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,2490002641)
	e1:SetCost(c249000264.cost2)
	e1:SetTarget(c249000264.target2)
	e1:SetOperation(c249000264.operation2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53347303,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c249000264.discon)
	e3:SetTarget(c249000264.distg)
	e3:SetOperation(c249000264.disop)
	c:RegisterEffect(e3)
	--rank-up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1073)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,249000264)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c249000264.condition)
	e5:SetCost(c249000264.cost)
	e5:SetTarget(c249000264.target)
	e5:SetOperation(c249000264.operation)
	c:RegisterEffect(e5)
end
function c249000264.costfilter2(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function c249000264.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000264.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c249000264.costfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c249000264.filter3(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000264.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c249000264.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000264.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000264.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000264.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c249000264.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOriginalAttribute()==ATTRIBUTE_DARK then return false end
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(c) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK
end
function c249000264.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c249000264.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateActivation(ev)
end
function c249000264.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_DARK
end
function c249000264.costfilter(c)
	return c:IsSetCard(0x1D0) and c:IsAbleToRemoveAsCost()
end
function c249000264.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000264.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000264.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000264.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000264.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=e:GetHandler()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ac=Duel.AnnounceCardFilter(tp,ATTRIBUTE_DARK,OPCODE_ISATTRIBUTE,TYPE_XYZ,OPCODE_ISTYPE,OPCODE_AND,249000264,OPCODE_ISCODE,OPCODE_OR)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_XYZ) and (sc:GetRank() == tc:GetRank()+2)
		and sc:IsAttribute(ATTRIBUTE_DARK) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false))
	do
		ac=Duel.AnnounceCardFilter(tp,ATTRIBUTE_DARK,OPCODE_ISATTRIBUTE,TYPE_XYZ,OPCODE_ISTYPE,OPCODE_AND,249000264,OPCODE_ISCODE,OPCODE_OR)
		sc=Duel.CreateToken(tp,ac)
		if ac==249000264 then return end
	end
	Duel.SendtoDeck(sc,nil,0,REASON_RULE)
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end