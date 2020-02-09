--Girl of Fiber Vine
function c16000231.initial_effect(c)
		--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000231,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,16000232)
	e1:SetCost(c16000231.thcost)
	e1:SetTarget(c16000231.thtg)
	e1:SetOperation(c16000231.thop)
	c:RegisterEffect(e1)
		--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c16000231.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(16000231,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,16000231)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c16000231.cost)
	e3:SetTarget(c16000231.target)
	e3:SetOperation(c16000231.operation)
	c:RegisterEffect(e3)
end
function c16000231.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c16000231.thfilter(c)
	return c:IsAbleToHand()
end
function c16000231.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74586817,2))
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c16000231.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c16000231.tgtg(e,c)
	return c:IsSetCard(0x185a) and c:IsType(TYPE_RITUAL)
end
function c16000231.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or c:IsSetCard(0xc4) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c16000231.tribfilter(c)
	return c:IsSetCard(0x85a) and not c:IsCode(16000231) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c16000231.filter(c,e,tp,m)
	if not c:IsSetCard(0x185a) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(c16000231.ritfilter,c,c)
	if c:IsCode(21105106) then return c:ritual_custom_condition(mg) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c16000231.ritfilter(c,cc)
	return c:GetRitualLevel(cc)>0
end
function c16000231.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c16000231.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c16000231.tribfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
		return Duel.IsExistingMatchingCard(c16000231.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,c,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c16000231.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c16000231.tribfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c16000231.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg:Filter(c16000231.ritfilter,tc,tc)
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			tc:SetMaterial(mat)
			Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
