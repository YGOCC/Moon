--Zedo - Paladin of the Banishing Light
function c10268932.initial_effect(c)
	aux.EnableDualAttribute(c)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10268932,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c10268932.descon)
	e4:SetTarget(c10268932.destg)
	e4:SetOperation(c10268932.desop)
	c:RegisterEffect(e4)
end
function c10268932.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsDualState() and Duel.GetAttacker()==c
		and bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and bc:IsAbleToRemove()
end
function c10268932.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c10268932.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
