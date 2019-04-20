--Stumbling in the Dark
function c32084018.initial_effect(c)
    --Activate
     local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c32084018.condition)
    e1:SetTarget(c32084018.target)
    e1:SetOperation(c32084018.activate)
    c:RegisterEffect(e1)
end
function c32084018.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c32084018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c32084018.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
        Duel.BreakEffect()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,32084019,0,TYPES_TOKEN,500,500,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	for i=1,ft do
		local token=Duel.CreateToken(tp,32084019)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c32084018.damval)
	token:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	token:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	token:RegisterEffect(e6,true)
	end
	Duel.SpecialSummonComplete()
end
end
function c32084018.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end