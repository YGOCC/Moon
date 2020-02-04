--Viravolve Reaper
function c221812210.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 3 Level 2 Cyberse monsters. You can also Xyz Summon this card by using any number of Rank 1 or 2 Cyberse Xyz Monsters you control as materials. (Transfer its materials to this card.)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),2,3,c221812210.ovfilter,aux.Stringid(221812210,0),nil,c221812210.ovoperation)
	--You can only Xyz Summon "Viravolve Reaper(s)" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c221812210.regcon)
	e1:SetOperation(c221812210.regop)
	c:RegisterEffect(e1)
	--Gains 500 ATK and DEF for each material attached to it.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(function(e,c) return c:GetOverlayCount()*500 end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--If this face-up card on the field would be destroyed, you can detach 1 material from this card instead.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c221812210.reptg)
	e4:SetOperation(c221812210.repop)
	c:RegisterEffect(e4)
	--Once per turn, during the End Phase, if a material was detached from an Xyz Monster you control: You can target 1 card on the field; destroy it.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetCondition(c221812210.descon)
	e5:SetTarget(c221812210.destg)
	e5:SetOperation(c221812210.desop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c221812210.thop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
end
function c221812210.ovfilter(c)
	return c:IsFaceup() and c:IsRankAbove(1) and c:GetRank()<=2 and c:IsRace(RACE_CYBERSE)
end
function c221812210.xyzop(e,tp,chk,mc)
	if chk==0 then return true end
	if not Duel.SelectYesNo(tp,aux.Stringid(221812210,1)) then return end
	local g=Duel.SelectMatchingCard(tp,aux.XyzAlterFilter,tp,LOCATION_MZONE,0,1,64,nil,c221812210.ovfilter,e:GetHandler(),e,tp)
	Duel.Overlay(e:GetHandler(),g)
end
function c221812210.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c221812210.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c221812210.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c221812210.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(221812210) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c221812210.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c221812210.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c221812210.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,221812210)>0 then
		Duel.ResetFlagEffect(tp,221812210)
		return true
	else return false end
end
function c221812210.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c221812210.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c221812210.thfilter(c,tp)
	local loc=c:GetPreviousLocation()
	if c:IsControler(1-tp) then return false end
	if c:IsLocation(LOCATION_GRAVE) then
		return (bit.band and bit.band(loc,LOCATION_ONFIELD)~=0) or loc&LOCATION_ONFIELD~=0 or (loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE))
	else
		return loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE)
	end
end
function c221812210.thop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c221812210.thfilter,1,nil,tp) then
		Duel.RegisterFlagEffect(tp,221812210,RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c221812210.thfilter,1,nil,1-tp) then
		Duel.RegisterFlagEffect(1-tp,221812210,RESET_PHASE+PHASE_END,0,1)
	end
end
