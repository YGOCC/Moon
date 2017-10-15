--Codeman: Zero the ~~Hero~~ Warrior
function c1020011.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c1020011.splimit)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c1020011.indcon)
	e2:SetOperation(c1020011.indop)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCountLimit(1,1020011)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c1020011.atcon)
	e3:SetTarget(c1020011.attg)
	e3:SetOperation(c1020011.atop)
	c:RegisterEffect(e3)
end
function c1020011.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:GetLevel()>=7) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c1020011.cfilter(c,e,tp)
	return c:IsSetCard(0xded) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
		and (not e or c:IsRelateToEffect(e))
end
function c1020011.indcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1020011.cfilter,1,nil,nil,tp) and Duel.IsExistingMatchingCard(c1020011.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c1020011.filter(c)
	return c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1020011.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1020011.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c1020011.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) 
		and bc:IsType(TYPE_MONSTER)
end
function c1020011.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.GetAttackTarget():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetAttackTarget(),1,0,0)
end
function c1020011.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if not bc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(bc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
		if bc and bc:IsFaceup() and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetLabelObject(bc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetCondition(c1020011.con)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetLabelObject(bc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(c1020011.con)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2)
			bc:RegisterFlagEffect(1020011,RESET_EVENT+0x1fe0000,0,1)
		end
	end
end
function c1020011.con(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	return bc:GetFlagEffect(1020011)==1
end
