--coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x617),3,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cid.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
end
function cid.atkfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsSetCard(0x617)
end
function cid.atkval(e,c)
	return c:GetLinkedGroup():Filter(cid.atkfilter,nil):GetClassCount(Card.GetType)*400
end
function cid.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:IsSetCard(0x617)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and cid.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetControl(tc,1-tp,0,1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetLabel(1-tp)
		e1:SetOperation(cid.damop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function cid.damop(e)
	Duel.Damage(e:GetLabel(),e:GetHandler():GetBaseAttack(),REASON_EFFECT)
end
