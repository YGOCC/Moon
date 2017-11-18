--Bushido Wolf
function c1020041.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020041.tgval)
	c:RegisterEffect(e1)
	--NS/Monster Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1020041,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,1020041)
	e2:SetTarget(c1020041.thtg)
	e2:SetOperation(c1020041.thop)
	e2:SetLabel(TYPE_MONSTER)
	c:RegisterEffect(e2)
	--Banish/Spell/Trap Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1020041)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c1020041.thtg)
	e3:SetOperation(c1020041.thop)
	e3:SetLabel(TYPE_SPELL+TYPE_TRAP)
	c:RegisterEffect(e3)
end
function c1020041.tgval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020041.filter(c,tpe)
	return c:IsSetCard(0x4b0) and c:IsType(tpe) and c:IsAbleToHand()
end
function c1020041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tpe=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c1020041.filter,tp,LOCATION_DECK,0,1,nil,tpe) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1020041.thop(e,tp,eg,ep,ev,re,r,rp)
	local tpe=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1020041.filter,tp,LOCATION_DECK,0,1,1,nil,tpe)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
