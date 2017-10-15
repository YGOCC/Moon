function c500315424.initial_effect(c)
--remove
   c:EnableReviveLimit()
		aux.AddFusionProcCodeFun(c,160002427,aux.FilterBoolFunction(c500315424.ffilter),1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500315424,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c500315424.condition)
	e1:SetTarget(c500315424.target)
	e1:SetOperation(c500315424.operation)
	c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c500315424.con)
	e3:SetTarget(c500315424.tg)
	e3:SetOperation(c500315424.op)
	c:RegisterEffect(e3)

end
function c500315424.ffilter(c)
	return  c:GetLevel()<=4 and c:GetCode()~=500315424 and not c:IsCode(500315424)  and c:GetLevel()>0  or c:IsHasEffect(500317451)
end
function c500315424.condition(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION or e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION+0x786
end
function c500315424.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c500315424.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c500315424.con(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():IsReason(REASON_EFFECT)
end
function c500315424.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c500315424.op(e,tp,eg,ep,ev,re,r,rp)
			local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
				end
			return
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetOperation(c500315424.tdop)
		Duel.RegisterEffect(e2,tp)
		

end
function c500315424.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end