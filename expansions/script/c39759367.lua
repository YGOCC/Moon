--Nucleo Incubo
--Script by XGlitchy30
function c39759367.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,c39759367.actcon,c39759367.actcon_alt,c39759367.mscon,c39759367.mscustom,nil,c39759367.penalty)
	--Ability: Nightmare Charger
	local ab=Effect.CreateEffect(c)
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetCode(EFFECT_UPDATE_ATTACK)
	ab:SetRange(LOCATION_SZONE)
	ab:SetTargetRange(LOCATION_MZONE,0)
	ab:SetCondition(c39759367.atkcon)
	ab:SetTarget(c39759367.atktg)
	ab:SetValue(500)
	c:RegisterEffect(ab)
	local abx=ab:Clone()
	abx:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(abx)
	--Monster Effects--
	--def up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c39759367.defval)
	c:RegisterEffect(e0)
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,39759366+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c39759367.thtg)
	e1:SetOperation(c39759367.thop)
	c:RegisterEffect(e1)
	--reset type declaration
	local reg=Effect.CreateEffect(c)
	reg:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	reg:SetType(EFFECT_TYPE_QUICK_O)
	reg:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	reg:SetCode(EVENT_FREE_CHAIN)
	reg:SetRange(LOCATION_MZONE)
	reg:SetCountLimit(1,39759366+EFFECT_COUNT_CODE_DUEL)
	reg:SetTarget(c39759367.thtg)
	reg:SetOperation(c39759367.thop)
	c:RegisterEffect(reg)
end
c39759367.declared_race = 0
--filters
function c39759367.cfilter(c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c39759367.cfilter2,c:GetControler(),LOCATION_MZONE,0,2,c,c:GetRace())
		and not Duel.IsExistingMatchingCard(c39759367.cfilterexc,c:GetControler(),LOCATION_MZONE,0,1,c,c:GetRace())
end
function c39759367.cfilter2(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c39759367.cfilterexc(c,race)
	return c:IsFaceup() and not c:IsRace(race)
end
function c39759367.deffilter(c)
	local rc=c39759367.declared_race
	return c:IsFaceup() and c:IsRace(rc)
end
--Deck Master Functions
function c39759367.DMCost(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:GetHandler():SetHint(CHINT_RACE,rc)
	c39759367.declared_race=rc
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c39759367.costtg)
	e1:SetValue(-1000)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c39759367.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,39759367)==0
end
function c39759367.actcon_alt(e,c)
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,39759367)==0
end
function c39759367.mscon(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(c39759367.cfilter,1,nil)
end
function c39759367.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,39759367,RESET_EVENT+EVENT_CUSTOM+39759367,0,1)
end
function c39759367.penalty(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c39759367.costtg(e,c)
	local rc=c39759367.declared_race
	return not c:IsRace(rc)
end
--Ability: Nightmare Charger
function c39759367.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and c39759367.declared_race~=0
end
function c39759367.atktg(e,c)
	local rc=c39759367.declared_race
	return c:IsRace(rc)
end
--Monster Effects--
--def up
function c39759367.defval(e,c)
	return Duel.GetMatchingGroupCount(c39759367.deffilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
--return to hand
function c39759367.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c39759367.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end