--created & coded by Lyris, art by Takayama Toshiaki
--機光襲雷－アーフタヌーン
function c240100011.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c240100011.damcon1)
	e1:SetOperation(c240100011.damop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c240100011.damcon2)
	e3:SetOperation(c240100011.damop2)
	e3:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c240100011.regcon)
	e2:SetOperation(c240100011.regop)
	e2:SetRange(LOCATION_PZONE)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(c240100011.descon)
	e0:SetTarget(c240100011.destg)
	e0:SetOperation(c240100011.desop)
	c:RegisterEffect(e0)
end
function c240100011.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c240100011.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c240100011.cfilter(c)
	return (c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) or c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER) and c:IsSetCard(0x7c4)
end
function c240100011.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c240100011.cfilter,nil)
	e:SetLabelObject(g:GetFirst())
	return g:GetCount()==1
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c240100011.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,240100011)
	Duel.Damage(1-tp,e:GetLabelObject():GetBaseAttack()+500,REASON_EFFECT)
end
function c240100011.regcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c240100011.cfilter,nil)
	e:GetLabelObject():SetLabelObject(g:GetFirst())
	return g:GetCount()==1
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c240100011.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,240100011,RESET_CHAIN,0,1)
end
function c240100011.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,240100011)>0
end
function c240100011.damop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,240100011)
	Duel.ResetFlagEffect(tp,240100011)
	Duel.Hint(HINT_CARD,0,240100011)
	Duel.Damage(1-tp,e:GetLabelObject():GetBaseAttack()+500,REASON_EFFECT)
end
