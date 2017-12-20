--Viravolve Demon
function c221812204.initial_effect(c)
	--If you Xyz Summon a Rank 1 Cyberse Xyz Monster: You can equip this card from your hand to it.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_HAND)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetCondition(c221812204.condition)
	e0:SetTarget(c221812204.eqtg)
	e0:SetOperation(c221812204.eqop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c221812204.eqlimit)
	c:RegisterEffect(e1)
	--The equipped monster gains 300 ATK.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--If this card is sent from the field to the GY, or detached from an Xyz Monster, inflict 200 damage to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c221812204.thcon)
	e2:SetOperation(c221812204.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_OVERLAY) and not c:IsReason(REASON_RULE) end)
	c:RegisterEffect(e3)
end
function c221812204.cfilter(c)
	return c:GetRank()==1 and c:IsRace(RACE_CYBERS)
end
function c221812204.condition(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg:GetFirst())
	return eg:GetCount()==1 and eg:GetFirst():IsSummonType(SUMMON_TYPE_XYZ) and eg:GetFirst():IsControler(tp) and c221812204.cfilter(eg:GetFirst())
end
function c221812204.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetLabelObject()~=nil end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c221812204.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	if not tc:IsSetCard(0xa67) then return end
	--Once per turn, during your Standby Phase: Inflict 200 damage to your opponent.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c221812204.damcon)
	e1:SetTarget(c221812204.damtg)
	e1:SetOperation(c221812204.damop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	--If you would detach exactly 1 material from this card: you can send 1 "Viravolve Demon" equipped to this card to the GY instead.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetDescription(aux.Stringid(221812204,0))
	e4:SetCondition(c221812204.rcon)
	e4:SetOperation(c221812204.rop)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
end
function c221812204.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipGroup():IsContains(e:GetOwner()) and Duel.GetTurnPlayer()==tp
end
function c221812204.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c221812204.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c221812204.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler():GetEquipTarget() and ep==e:GetOwnerPlayer() and ev==1 and re:GetHandler():GetOverlayCount()>=1
end
function c221812204.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c221812204.eqlimit(e,c)
	return (c:GetRank()==1 and c:IsRace(RACE_CYBERS)) or e:GetHandler():GetEquipTarget()==c
end
function c221812204.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetPreviousLocation()
	return (bit.band and bit.band(loc,LOCATION_ONFIELD)~=0) or loc&LOCATION_ONFIELD~=0 or (loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE))
end
function c221812204.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,221812204)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
