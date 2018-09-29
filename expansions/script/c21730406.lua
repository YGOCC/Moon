--A.O. Subjugator
function c21730406.initial_effect(c)
	c:SetUniqueOnField(1,0,21730406)
	--link procedure
	aux.AddLinkProcedure(c,c21730406.matfilter,1,1)
	c:EnableReviveLimit()
	--take control of monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730406,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c21730406.cttg)
	e2:SetOperation(c21730406.ctop)
	c:RegisterEffect(e2)
	--add from deck to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c21730406.regop)
	c:RegisterEffect(e3)
end
--link procedure
function c21730406.matfilter(c)
	return c:IsLinkSetCard(0x719) and not (c:IsSummonType(SUMMON_TYPE_LINK) and c:IsStatus(STATUS_SPSUMMON_TURN))
end
--take control of monster
function c21730406.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c21730406.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.GetControl(tc,tp,PHASE_BATTLE,1)
	end
end
--add from deck to hand
function c21730406.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730406,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x86c0000+RESET_PHASE+PHASE_END)
	e1:SetTarget(c21730406.thtg)
	e1:SetOperation(c21730406.thop)
	c:RegisterEffect(e1)
end
function c21730406.thfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21730406.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730406.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21730406.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21730406.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end