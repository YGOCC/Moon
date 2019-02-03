--Tera Giga the Game Master
function c12000238.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000238,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c12000238.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--level change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000238,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c12000238.lvtg)
	e2:SetOperation(c12000238.lvop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000238,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12000238)
	e3:SetCondition(c12000238.coincon1)
	e3:SetTarget(c12000238.cointg)
	e3:SetOperation(c12000238.coinop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(c12000238.coincon2)
	c:RegisterEffect(e4)
end
c12000238.toss_coin=true
function c12000238.cfilter(c)
	return c:IsFaceup() and c:IsCode(12000242)
end
function c12000238.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000238.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c12000238.lvfilter1(c)
	return c:IsSetCard(0x856) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function c12000238.lvfilter2(c)
	return c:IsType(TYPE_MONSTER) and (c:GetLevel()>0 or c:GetRank()>0)
end
function c12000238.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c12000238.lvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c12000238.lvfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12000238.lvfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c12000238.checkhigherval(c,cp)
	if cp:IsType(TYPE_XYZ) then
		return c:GetLevel()>cp:GetRank() or c:GetRank()>cp:GetRank()
	else
		return c:GetLevel()>cp:GetLevel() or c:GetRank()>cp:GetLevel()
	end
	return false
end
function c12000238.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lv=0
	local g=Duel.GetMatchingGroup(c12000238.lvfilter2,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local sg=g:GetMaxGroup(Card.GetLevel)
	local sg2=g:GetMaxGroup(Card.GetRank)
	sg:Merge(sg2)
	for exc in aux.Next(sg) do
		if sg:IsExists(c12000238.checkhigherval,1,exc,exc) then
			sg:RemoveCard(exc)
		end
	end
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
	end
	local tc1=sg:GetFirst()
	if tc1:IsType(TYPE_XYZ) then
		lv=tc1:GetRank()
	else
		lv=tc1:GetLevel()
	end	
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c12000238.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x856)
		and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000238.coincon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x856)
		and re:GetHandler():IsType(TYPE_LINK) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000238.tdfilter1(c)
	return c:IsSetCard(0x856) and c:IsType(TYPE_MONSTER)
end
function c12000238.tdfilter2(c)
	return c:IsSetCard(0x856) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c12000238.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000238.tdfilter1,tp,LOCATION_DECK,0,1,nil) 
		or Duel.IsExistingMatchingCard(c12000238.tdfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c12000238.coinop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then 
		local g=Duel.SelectMatchingCard(tp,c12000238.tdfilter1,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	else 
		local g=Duel.SelectMatchingCard(tp,c12000238.tdfilter2,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
