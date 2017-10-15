--Yaranzo, Pendulum Treasure Box
--Keddy was her~
local id,cod=1013071,c1013071
function cod.initial_effect(c)
	--Pendulum Zone
	aux.EnablePendulumAttribute(c)
	---==Pendulum Effect==---
	--Negate
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,id)
    e1:SetCondition(cod.ngcon)
    e1:SetTarget(cod.ngtg)
    e1:SetOperation(cod.ngop)
    c:RegisterEffect(e1)
	---==Monster Effect==---
	--Replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(cod.repcost)
	e2:SetTarget(cod.reptg)
	e2:SetOperation(cod.repop)
	c:RegisterEffect(e2)
end
function cod.ngcon(e,tp,eg,ep,ev,re,r,rp,chk)
    local ph=Duel.GetCurrentPhase()
    return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) and ep~=tp
        and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cod.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cod.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		local tc=eg:GetFirst()
		if not tc then return end
   		if tc:IsType(TYPE_PENDULUM) then
   			local flag=false
   			if flag==false then
	   			local e1=Effect.CreateEffect(c)
	   			e1:SetType(EFFECT_TYPE_SINGLE)
	   			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	   			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	   			e1:SetLabelObject(c)
	   			e1:SetOperation(cod.rpop)
	  			e1:SetReset(RESET_EVENT+0x1000000)
	   			tc:RegisterEffect(e1)
	   			flag=true
	   		end
	    	if flag==true then
	    		Duel.Destroy(tc,REASON_EFFECT)
	    	end
   		else
   			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
   		end
		c:SetCardTarget(tc)
   		--Cannot Activate
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetCondition(cod.rcon)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
       	--Return
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetTarget(cod.rttg)
		e2:SetOperation(cod.rtop)
		e2:SetReset(RESET_EVENT+0x1000000)
		c:RegisterEffect(e2)
	end
end
function cod.rpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    if c:IsFaceup() then
    	Duel.ChangePosition(c,POS_FACEDOWN)
    end
end
function cod.rcon(e)
    return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function cod.rttg(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:IsLocation(LOCATION_SZONE) and tc:IsAbleToHand()
end
function cod.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function cod.repcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cod.rfilter(c)
	return (c:GetSequence()==7 or c:GetSequence()==6) and c:IsAbleToExtra() and c:IsFaceup()
end
function cod.reptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and cod.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cod.rfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_SZONE)
end
function cod.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cod.rfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT) then
		Duel.BreakEffect()
		if not Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_DECK)
		e1:SetLabelObject(g:GetFirst())
		e1:SetCountLimit(1)
		e1:SetCondition(function (e) return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
		e1:SetTarget(cod.rttg2)
		e1:SetOperation(cod.rtop2)
		e1:SetReset(RESET_EVENT+0x1000000)
		c:RegisterEffect(e1)
	end
end
function cod.rttg2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:IsLocation(LOCATION_EXTRA) and tc:IsAbleToHand()
end
function cod.rtop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end