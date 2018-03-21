--created & coded by Lyris, art by 
The-SixthLeafClover of DeviantArt
--機光襲雷竜－ホウロウ
The-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtThe-SixthLeafClover of DeviantArtfunction c240100032.initial_effect(c)
aux.AddXyzProcedure(c,nil,4,2)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(c240100032.descon)
	e0:SetOperation(c240100032.desop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c240100032.con)
	e1:SetCost(c240100032.cost)
	e1:SetTarget(c240100032.tg)
	e1:SetOperation(c240100032.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c240100032.dop)
	c:RegisterEffect(e2)
end
function c240100032.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100032.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c240100032.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c240100032.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c240100032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c240100032.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c240100032.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetOverlayCount()
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c240100032.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
end
function c240100032.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetOverlayCount()
	local e1,g1,ct1,p1,l1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local e2,g2,ct2,p2,l2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_EFFECT)
	if g2:GetCount()>0 and Duel.Destroy(g2,REASON_EFFECT)~=0 and g1:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)
	end
end
