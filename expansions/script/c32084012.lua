--Bone Statue of the Orichalcos
function c32084012.initial_effect(c)
        --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32084012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c32084012.tg)
	e1:SetOperation(c32084012.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
		--search trap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32084012,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c32084012.thtg)
	e4:SetOperation(c32084012.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--Cost Change
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_LPCOST_CHANGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,0)
	e7:SetValue(c32084012.costchange)
	c:RegisterEffect(e7)
		local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e8:SetCondition(c32084012.con)
	e8:SetOperation(c32084012.operation)
	c:RegisterEffect(e8)
		--Negate Damage
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(aux.damcon1)
	e9:SetOperation(c32084012.opz)
	c:RegisterEffect(e9)
end
function c32084012.costchange(e,re,rp,val)
	if re and re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP) or re:GetHandler():IsType(TYPE_MONSTER) then
		return 0
	else
		return val
	end
end
function c32084012.filter(c,e,tp)
	return c:IsSetCard(0x7D54) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ROCK) and c:GetLevel()==4
end
function c32084012.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32084012.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c32084012.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32084012.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c32084012.thfilter(c)
	return c:IsSetCard(0x7D54) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c32084012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32084012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32084012.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32084012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c32084012.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c32084012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetOperation(c32084012.damop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c32084012.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c32084012.opz(e,tp,eg,ep,ev,re,r,rp,val,r,rc)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(cid)
	e2:SetValue(c32084012.refcon)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	end
end
function c32084012.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then e:SetLabel(val) return 0
	else return val end
end