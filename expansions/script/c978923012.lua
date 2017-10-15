--Transfigurer, Breeze
function c978923012.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2521011,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,978923012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c978923012.settg)
	e1:SetOperation(c978923012.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(952312343,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c978923012.thcon)
	e5:SetTarget(c978923012.thtg)
	e5:SetOperation(c978923012.thop)
	c:RegisterEffect(e5)
end
function c978923012.setfilter(c)
	return c:IsSetCard(0xfe9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c978923012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c978923012.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c978923012.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c978923012.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c978923012.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonCard():IsSetCard(0xfe9) and c:IsReason(0x100000000)
end
function c978923012.thfilter(c)
	return c:IsSetCard(0xfe9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c978923012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c978923012.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c978923012.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c978923012.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c978923012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end