--Mysterious Cosmic Dragon
function c53313917.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--Once per turn when a monster you control would be destroyed either by battle or by card effect: You can destroy this card instead, then you can add 1 "Mysterious" or Pandemonium monster from your Deck to your Hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c53313917.reptg)
	e1:SetValue(c53313917.repval)
	e1:SetOperation(c53313917.repop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,false,TYPE_SYNCHRO)
	--spsummon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xCF6),aux.NonTuner(nil),1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c53313917.aclimit)
	e3:SetCondition(c53313917.actcon)
	c:RegisterEffect(e3)
	--Once per turn you can banish 1 monster in your Hand, GY, or your side of the field, this card's effect becomes that monster's effect, These changes last until the End Phase. When this card is destroyed: You can activate this card in your Spell/Trap zone.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53313917,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c53313917.remtg)
	e2:SetOperation(c53313917.remop)
	c:RegisterEffect(e2)
	--When this card is destroyed: You can activate this card in your Spell/Trap zone.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c53313917.sttg)
	e4:SetOperation(c53313917.stop)
	c:RegisterEffect(e4)
end
function c53313917.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_REPLACE)
end
function c53313917.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.PandActCheck(e) and eg:IsExists(c53313917.filter,1,nil,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c53313917.repval(e,c)
	return c53313917.filter(c,e:GetHandlerPlayer())
end
function c53313917.thfilter(c)
	return (c:IsSetCard(0xcf6) and c:IsType(TYPE_MONSTER) or c:IsType(TYPE_PANDEMONIUM))
end
function c53313917.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	local g=Duel.GetMatchingGroup(c53313917.thfilter,tp,LOCATION_DECK,0,nil)
end
function c53313917.rfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsLocation(LOCATION_EXTRA) 
		or c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemove()
end
function c53313917.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x16) and chkc:IsType(TYPE_MONSTER) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(c53313917.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c53313917.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c53313917.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	for tc in aux.Next(g) do
		c:CopyEffect(tc:GetCode(),RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	end
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c53313917.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c53313917.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c53313917.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not Duel.IsExistingMatchingCard(aux.PaCheckFilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
end
function c53313917.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)
		and not Duel.IsExistingMatchingCard(aux.PaCheckFilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
