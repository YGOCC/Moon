--CXyz Swordsmasterror Genghis
function c240100257.initial_effect(c)
	c:EnableReviveLimit()
	--3 Level 5 monsters
	aux.AddXyzProcedure(c,nil,5,3,c240100257.ovfilter,aux.Stringid(240100257,1))
	--If this card attacks a Defense Position monster, inflict piercing battle damage.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--Gains 200 ATK for each material attached to it and 100 ATK for each "Swordsmaster" monster that was destroyed within the last 2 Standby Phases while this card was on the field.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100257.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetOperation(c240100257.regop)
	c:RegisterEffect(e2)
	--If this card is destroyed: You can target 1 Attack Position monster your opponent controls; change its battle position. A "Swordsmaster" Xyz Monster must be in your GY to activate and to resolve this effect. Gains this effect, while it has a "Swordsmaster" Xyz Monster as an Xyz Material. If another "Swordsmaster" monster you control is destroyed: You can target 1 Attack Position monster your opponent controls; change its battle position.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetTarget(c240100257.postg)
	e3:SetOperation(c240100257.posop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(e3:GetProperty()+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c240100257.poscon)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	c:RegisterEffect(e4)
end
function c240100257.val(e,c)
	return c:GetFlagEffect(240100257)*100+c:GetOverlayCount()*200
end
function c240100257.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c240100257.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c240100257.rfilter,1,c) then
		c:RegisterFlagEffect(240100257,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
	end
end
function c240100257.ovfilter(c)
	return c:IsFaceup() and c:IsCode(240100214)
end
function c240100257.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xbb2)
end
function c240100257.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xbb2) and eg:IsExists(Card.IsSetCard,1,e:GetHandler(),0xbb2)
end
function c240100257.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c240100257.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c240100257.posfilter(chkc) end
	if chk==0 then return (Duel.IsExistingMatchingCard(c240100257.filter,tp,LOCATION_GRAVE,0,1,nil) or e:IsHasType(EFFECT_TYPE_FIELD))
		and Duel.IsExistingTarget(c240100257.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c240100257.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c240100257.posop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c240100257.filter,tp,LOCATION_GRAVE,0,1,nil) and e:IsHasType(EFFECT_TYPE_SINGLE) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
