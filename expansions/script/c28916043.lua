--Part 3
local ref=_G['c'..28916043]
local id=28916043
function ref.initial_effect(c)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.sscon)
	e1:SetCost(ref.sscost)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	--Trade
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end

--Trade
function ref.thcfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function ref.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.thcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function ref.thfilter(c)
	return (c:IsSetCard(1848+1) or c:IsCode(63851864)) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,ref.thcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if cg:GetCount()>0 and Duel.SendtoGrave(cg,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

--SS
function ref.confilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsControler(tp) and c:GetPreviousLocation()==LOCATION_DECK
		and not c:IsPublic()
end
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.confilter,1,nil,tp)
end
function ref.sscfilter(c,e,tp)
	return c:IsSetCard(1848) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function ref.ssfilter(c,e,tp)
	return c:IsSetCard(1848) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=eg:Filter(ref.confilter,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.sscfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	local rc=nil
	if rg:GetCount()==1 then
		rc=rg:GetFirst()
	else
		rc=rg:Select(tp,1,1,nil):GetFirst()
	end
	Duel.ConfirmCards(1-tp,rc)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.sscfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.sstg(e,tp,ev,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and ref.ssfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(ref.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function ref.val(e,re,dam,r,rp,rc)
	return dam/2
end
