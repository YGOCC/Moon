--created & coded by Lyris, art by emryswolf of DeviantArt
--襲雷竜－闇
function c240100006.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_BATTLE_START)
	e0:SetCondition(c240100006.descon)
	e0:SetTarget(c240100006.destg)
	e0:SetOperation(c240100006.desop)
	c:RegisterEffect(e0)
end
function c240100006.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()~=e:GetHandler()
end
function c240100006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c240100006.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
