--Paintress Rembrandia 
function c16100666.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c16100666.splimit)
	e2:SetCondition(c16100666.splimcon)
	c:RegisterEffect(e2)
			--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e3:SetValue(c16100666.indval)
	c:RegisterEffect(e3)
				--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16100666,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c16100666.condition)
	e5:SetTarget(c16100666.target)
	e5:SetOperation(c16100666.operation)
	c:RegisterEffect(e5)
end
function c16100666.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c16100666.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c16100666.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c16100666.gfilter(c,tp)
	return not c:IsFaceup() and c:IsSetCard(0xc50) and  c:IsPreviousLocation(LOCATION_EXTRA) and c:GetOwner()==tp
end
function c16100666.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16100666.gfilter,1,nil,tp)
end
function c16100666.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c16100666.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c16100666.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16100666.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c16100666.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c16100666.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end