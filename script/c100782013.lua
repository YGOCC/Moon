--Wirewood Herold
function c100782013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100782013,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100782013.spcon)
	e1:SetOperation(c100782013.spop)
	c:RegisterEffect(e1)
		--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100782013,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100782013.thcon)
	e2:SetTarget(c100782013.thtg)
	e2:SetOperation(c100782013.thop)
	c:RegisterEffect(e2)
end
function c100782013.spfilter(c)
	return c:IsSetCard(0x189B7) and c:IsAbleToRemoveAsCost()
end
function c100782013.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100782013.spfilter,c:GetControler(),LOCATION_GRAVE,0,c:GetLevel(),nil)
end
function c100782013.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100782013.spfilter,tp,LOCATION_GRAVE,0,lv,lv,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100782013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c100782013.filter(c)
	return c:IsSetCard(0x189AE) and c:IsAbleToHand()
end
function c100782013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100782013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100782013.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end