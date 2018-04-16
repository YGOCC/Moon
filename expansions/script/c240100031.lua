--created & coded by Lyris, art by The-SixthLeafClover of DeviantArt
--機光襲雷竜－ホウロウ
function c240100031.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x7c4),2,2,function(g) return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() end)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c240100031.dop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(c240100031.pop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c240100031.atkcon)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(c240100031.descon)
	e0:SetTarget(c240100031.destg)
	e0:SetOperation(c240100031.desop)
	c:RegisterEffect(e0)
end
function c240100031.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100031.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c240100031.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c240100031.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) then
		Duel.Hint(HINT_CARD,0,240100031)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c240100031.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0x7c4) and not c:IsImmuneToEffect(e)
end
function c240100031.pop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c240100031.filter2,tp,LOCATION_MZONE,0,e:GetHandler(),e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(function(e,te) return not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and te:GetOwnerPlayer()~=e:GetOwnerPlayer() end)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(240100031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c240100031.descon)
	e2:SetOperation(c240100031.desop)
	Duel.RegisterEffect(e2,tp)]]
	end
end
function c240100031.desfilter(c,fid)
	return c:GetFlagEffectLabel(240100031)==fid
end
function c240100031.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c240100031.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c240100031.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c240100031.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end
function c240100031.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x7c4)
	and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c240100031.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c240100031.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
