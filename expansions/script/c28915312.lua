--Samuel
--Design and Code by Kindrindra--
local ref=_G['c'..28915312]
function ref.initial_effect(c)
	--Bloom Condition
	local be1=Effect.CreateEffect(c)
	be1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	be1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	be1:SetRange(LOCATION_MZONE)
	be1:SetCode(EVENT_TO_GRAVE)
	be1:SetCondition(ref.bloomcon)
	be1:SetOperation(ref.bloomop)
	c:RegisterEffect(be1)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end

	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,28915312)
	e1:SetCost(ref.thcost)
	e1:SetTarget(ref.thtg)
	e1:SetOperation(ref.thop)
	c:RegisterEffect(e1)
	--Revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,28915312)
	e4:SetCost(ref.sscost)
	e4:SetTarget(ref.sstg)
	e4:SetOperation(ref.ssop)
	c:RegisterEffect(e4)
end

ref.seedling = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end

function ref.bloomcfilter(c)
	return c:IsSetCard(0x72D) and c:IsType(TYPE_MONSTER)
end
function ref.bloomcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.bloomcfilter,1,nil)
end
function ref.bloomop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(269,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(269)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end

function ref.rmfilter(c,tp)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,0,1,c)
end
function ref.filter(c)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function ref.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,ref.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and ref.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	if Duel.GetFlagEffect(tp,28915312)~=0 then return end
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x72C))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,28915312,RESET_PHASE+PHASE_END,0,1)
end

function ref.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function ref.ssfilter(c,e,tp)
	return c:IsSetCard(0x72D) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(ref.ssfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local g=eg:FilterSelect(tp,ref.ssfilter,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
