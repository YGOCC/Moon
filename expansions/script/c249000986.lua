--Dragofinity Caller
function c249000986.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75878039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,249000986)
	e1:SetTarget(c249000986.target)
	e1:SetOperation(c249000986.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--hand link
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c249000986.matval)
	c:RegisterEffect(e4)
end
function c249000986.filter(c)
	return c:IsSetCard(0x1FF) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c249000986.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000986.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000986.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000986.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000986.mfilter(c,e)
	return c==e:GetHandler()
end
function c249000986.matval(e,c,mg)
	return c:IsRace(RACE_DRAGON) and mg:IsExists(c249000985.mfilter,1,nil,e)
end