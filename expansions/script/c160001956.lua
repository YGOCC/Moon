--Paintress EX :Asslia Witchiee
function c160001956.initial_effect(c)
	 aux.AddOrigEvoluteType(c)
aux.AddEvoluteProc(c,nil,7,c160001956.filter1,c160001956.filter2,1,99) 
		--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c160001956.reptg)
	e2:SetValue(c160001956.repval)
	e2:SetOperation(c160001956.repop)
	c:RegisterEffect(e2)   
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160001956,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c160001956.descost)
	e3:SetTarget(c160001956.destg)
	e3:SetOperation(c160001956.desop)
	c:RegisterEffect(e3)
end



function c160001956.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY)
end
function c160001956.filter2(c,ec,tp)
	return not c:IsType(TYPE_EFFECT)
end


function c160001956.repfilter(c,tp)
	return c:IsFaceup() and  c:IsSetCard(0xc50)
		and c:IsControler(tp) and  c:IsLocation(LOCATION_ONFIELD) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c160001956.repfilterxxl(c,e)
	return not c:IsType(TYPE_EFFECT)
		and c:IsAbleToRemove()
end
function c160001956.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c160001956.repfilter,1,nil,tp)  and Duel.IsExistingMatchingCard(c160001956.repfilterxxl,tp,LOCATION_EXTRA,0,1,c,e) end
   if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c160001956.repfilterxxl,tp,LOCATION_EXTRA,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c160001956.repval(e,c)
	return c160001956.repfilter(c,e:GetHandlerPlayer())
end
function c160001956.repop(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function c160001956.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xc50)
end

function c160001956.filter(c,e,tp)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToHand()
end
function c160001956.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
	  --  and Duel.IsExistingMatchingCard(c160001956.filter(c),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c160001956.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function c160001956.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c160001956.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c160001956.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local lv=tc:GetOriginalLevel()
		if tc:IsType(TYPE_XYZ) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,c160001956.filter,tp,LOCATION_MZONE,LOCATION_MZONE,lv,lv,aux.ExceptThisCard(e))
	   -- local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			if  tc:IsPreviousSetCard(0xc50) then
				Duel.BreakEffect() 
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
			end
		end
	end
end
function c160001956.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c160001956.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function c160001956.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end