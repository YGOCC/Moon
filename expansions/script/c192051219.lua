--coded by Lyris
--Steelus Infiltratem
function c192051219.initial_effect(c)
	c:EnableReviveLimit()
	--3 "Steelus" monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x617),3,3)
	--Gains 400 ATK for each "Steelus" monster with a different monster card type (Fusion, Synchro, Xyz) it points to.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c192051219.atkval)
	c:RegisterEffect(e1)
	--Once per turn: you can target 1 "Steelus" monster you control; give control of it to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetTarget(c192051219.target)
	e2:SetOperation(c192051219.activate)
	c:RegisterEffect(e2)
end
function c192051219.atkfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsSetCard(0x617)
end
function c192051219.atkval(e,c)
	return c:GetLinkedGroup():Filter(c192051219.atkfilter,nil):GetClassCount(Card.GetType)*400
end
function c192051219.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:IsSetCard(0x617)
end
function c192051219.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c192051219.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c192051219.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c192051219.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c192051219.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetControl(tc,1-tp,0,1) then
		--If that monster is sent to the GY this turn, inflict damage to your opponent equal to its original ATK.
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetLabel(1-tp)
		e1:SetOperation(c192051219.damop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c192051219.damop(e)
	Duel.Damage(e:GetLabel(),e:GetHandler():GetBaseAttack(),REASON_EFFECT)
end
