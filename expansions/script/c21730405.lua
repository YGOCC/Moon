--S.G. Esper
function c21730405.initial_effect(c)
	--link procedure
	aux.AddLinkProcedure(c,c21730405.matfilter,1,1)
	c:EnableReviveLimit()
	--return monster to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730405,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c21730405.thcon)
	e2:SetTarget(c21730405.thtg)
	e2:SetOperation(c21730405.thop)
	c:RegisterEffect(e2)
	--add from deck to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c21730405.regop)
	c:RegisterEffect(e3)
end
--link procedure
function c21730405.matfilter(c)
	return c:IsLinkSetCard(0x719) and not c:IsType(TYPE_LINK)
end
--return monster to hand
function c21730405.thcon(e)
	return e:GetHandler():IsLinkState()
end
function c21730405.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c21730405.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--add from deck to hand
function c21730405.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730405,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetTarget(c21730405.thtg)
	e1:SetOperation(c21730405.thop)
	c:RegisterEffect(e1)
end
function c21730405.thfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21730405.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730405.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21730405.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21730405.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end