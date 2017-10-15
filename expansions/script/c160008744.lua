
function c160008744.initial_effect(c)
c:EnableCounterPermit(0x1075)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCondition(c160008744.ctcon)
	e2:SetOperation(c160008744.ctop)
	c:RegisterEffect(e2)
	-- local e3=e2:Clone()
	-- e3:SetCode(EVENT_REMOVE)
	-- c:RegisterEffect(e3)
	-- local e4=e2:Clone()
	-- e4:SetCode(EVENT_TO_DECK)
	-- c:RegisterEffect(e4)
		-- local e5=e2:Clone()
	-- e5:SetCode(EVENT_TO_HAND)
	-- c:RegisterEffect(e5)
		--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(c160008744.atkval)
	c:RegisterEffect(e3)
		--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTarget(c160008744.distg)
	c:RegisterEffect(e6)
		--Atk up

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e7:SetValue(600)
	c:RegisterEffect(e7)
	--Def down
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e8:SetValue(-300)
	c:RegisterEffect(e8)
	--to hand
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(160008744,0))
	e9:SetCategory(CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1,160008744)
	e9:SetCost(c160008744.thcost)
	e9:SetTarget(c160008744.thtg)
	e9:SetOperation(c160008744.thop)
	c:RegisterEffect(e9)
		--to hand
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(6666,4))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetRange(LOCATION_FZONE)
	e10:SetCountLimit(1,160008744)
	e10:SetCost(c160008744.spcost)
	e10:SetTarget(c160008744.sptg)
	e10:SetOperation(c160008744.spop)
	c:RegisterEffect(e10)
		 local e11=e10:Clone()
	e11:SetDescription(aux.Stringid(6666,1))
	e11:SetCost(c160008744.spcost4)
	e11:SetTarget(c160008744.sptg4)
	e11:SetOperation(c160008744.spop4)
	c:RegisterEffect(e11)
		 local e12=e10:Clone()
	e12:SetDescription(aux.Stringid(6666,2))
	e12:SetCost(c160008744.spcost2)
	e12:SetTarget(c160008744.sptg2)
	e12:SetOperation(c160008744.spop2)
	c:RegisterEffect(e12)
	
		 local e13=e10:Clone()
	e13:SetDescription(aux.Stringid(6666,3))
	e13:SetCost(c160008744.spcost3)
	e13:SetTarget(c160008744.sptg3)
	e13:SetOperation(c160008744.spop3)
	c:RegisterEffect(e13)
	
end
function c160008744.cfilter(c)
	return  (c:IsSetCard(0xc50) or not c:IsType(TYPE_EFFECT) ) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160008744.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c160008744.cfilter,1,nil)
end
function c160008744.cfilter2(c)
	return  (c:IsSetCard(0xc50) or not c:IsType(TYPE_EFFECT) ) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160008744.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c160008744.cfilter2,1,nil)
end
function c160008744.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil
	for i=1,7 do
		tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i-1)
		if tc and tc:IsCanAddCounter(0x1075,1) and bit.band(tc:GetType(),0x21)==0x21 and not tc:IsSetCard(0xc50) then
			tc:AddCounter(0x1075,1)
		end
	end
	for i=1,7 do
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i-1)
		if tc and tc:IsCanAddCounter(0x1075,1) and bit.band(tc:GetType(),0x21)==0x21 and not tc:IsSetCard(0xc50) then
			tc:AddCounter(0x1075,1)
		end
	end
end

function c160008744.atkval(e,c)
	return c:GetCounter(0x1075)*-100
end



function c160008744.distg(e,c)
	return c:GetCounter(0x1075)>0  and not c:IsSetCard(0xc50) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c160008744.filter(e,c)
	return c:IsSetCard(0x1075)
end

function c160008744.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c160008744.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(3-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
end
function c160008744.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,10,10,0x1075,10,REASON_COST)  end --and Duel.GetCustomActivityCount(160008744,tp,ACTIVITY_SPSUMMON)==0
	Duel.RemoveCounter(tp,10,10,0x1075,10,REASON_COST)
end
function c160008744.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc50)
end
function c160008744.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c160008744.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c160008744.xxxfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160008744.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,10,10,0x1075,2,REASON_COST)  end --and Duel.GetCustomActivityCount(160008744,tp,ACTIVITY_SPSUMMON)==0
	Duel.RemoveCounter(tp,10,10,0x1075,2,REASON_COST)
end
function c160008744.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c160008744.xxxfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c160008744.xxxfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160008744.xxxfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c160008744.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)

	end
end
function c160008744.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,10,10,0x1075,6,REASON_COST)  end --and Duel.GetCustomActivityCount(160008744,tp,ACTIVITY_SPSUMMON)==0
	Duel.RemoveCounter(tp,10,10,0x1075,6,REASON_COST)
end
function c160008744.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c160008744.xxxfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c160008744.xxxfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160008744.xxxfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c160008744.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)

	end
end
function c160008744.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,10,10,0x1075,8,REASON_COST)  end --and Duel.GetCustomActivityCount(160008744,tp,ACTIVITY_SPSUMMON)==0
	Duel.RemoveCounter(tp,10,10,0x1075,8,REASON_COST)
end
function c160008744.sptg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsExistingMatchingCard(c160008744.xxxfilter.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c160008744.spop3(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c160008744.xxxfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
		Duel.SpecialSummonComplete()
end
function c160008744.spcost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,10,10,0x1075,4,REASON_COST)  end --and Duel.GetCustomActivityCount(160008744,tp,ACTIVITY_SPSUMMON)==0
	Duel.RemoveCounter(tp,10,10,0x1075,4,REASON_COST)
end
function c160008744.sptg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,500319546,0x55,0x4011,0,0,4,RACE_AQUA,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function c160008744.spop4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,500319546,0x55,0x4011,0,0,4,RACE_AQUA,ATTRIBUTE_LIGHT) then
		for i=1,4 do
			local token=Duel.CreateToken(tp,500319546)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end

