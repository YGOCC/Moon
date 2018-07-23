--Brad, General of the Army
function c600000027.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(600000027,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60000027)
	e1:SetCost(c600000027.spcost)
	e1:SetTarget(c600000027.sptg)
	e1:SetOperation(c600000027.spop)
	c:RegisterEffect(e1)
	--attackup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c600000027.atkval)
	c:RegisterEffect(e2)
	--Cannot Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c600000027.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6)
	--atkdown
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(600000027,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,60000127)
	e7:SetCost(c600000027.atkcost)
	e7:SetTarget(c600000027.atktg)
	e7:SetOperation(c600000027.atkop)
	c:RegisterEffect(e7)
	--to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(600000027,2))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,60000227)
	e8:SetCondition(c600000027.thcon)
	e8:SetTarget(c600000027.thtg)
	e8:SetOperation(c600000027.thop)
	c:RegisterEffect(e8)
end
function c600000027.atkval(e,c)
	return Duel.GetCounter(e:GetOwnerPlayer(),1,0,0x4a8)*100
end
function c600000027.sumlimit(e,c)
	return not c:IsSetCard(0x24a8)
end
function c600000027.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,4)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==4 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c600000027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c600000027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c600000027.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,1,0,0x4a8)>0 end
	local gt=Duel.GetCounter(tp,1,0,0x4a8)
	local ct={}
	for i=gt,1,-1 do
		table.insert(ct,i)
	end
	if #ct==1 then
		Duel.RemoveCounter(tp,1,0,0x4a8,ct[1],REASON_COST)
		e:SetLabel(100)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(600000027,3))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.RemoveCounter(tp,1,0,0x4a8,ac,REASON_COST)
		e:SetLabel(ac*100)
	end
end
function c600000027.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c600000027.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local val=e:GetLabel()
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		tc:RegisterEffect(e1)
	end
end
function c600000027.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_MZONE and c:IsReason(REASON_EFFECT)
		and c:IsReason(REASON_DESTROY)
end
function c600000027.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c600000027.cfilter,1,nil)
end
function c600000027.thfilter(c)
	return c:IsSetCard(0x24a8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c600000027.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c600000027.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c600000027.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c600000027.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end