--Paintress Niemöllina
function c160005555.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c160005555.reptg)
	e2:SetValue(c160005555.repval)
	e2:SetOperation(c160005555.repop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,160007855)
	--e3:SetCondition(c160005555.thcon)
   -- e3:SetCost(c160005555.thcost)
	e3:SetTarget(c160005555.thtg)
	e3:SetOperation(c160005555.thop)
	c:RegisterEffect(e3)
end
function c160005555.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160005555.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160005555.target(e,c)
	return c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL)
end
function c160005555.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xc50)
end
function c160005555.cfilter(c)
	return  c:IsType(TYPE_NORMAL) and c:IsFaceup () and c:IsAbleToRemoveAsCost()
end
function c160005555.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160005555.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160005555.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160005555.spfilter(c)
	return c:IsSetCard(0xc50) and c:IsDestructable()
end
function c160005555.sipfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160005555.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c160005555.spfilter,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(c160005555.sipfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c160005555.spfilter,tp,LOCATION_MZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c160005555.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160005555.spfilter,tp,LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT) ~=0  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c160005555.sipfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
			local tc=g2:GetFirst()
			if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				tc:RegisterEffect(e2)
				 local e3=e1:Clone()
				e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				tc:RegisterEffect(e3)
				 local e4=e1:Clone()
				e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				tc:RegisterEffect(e4)
				 local e5=e1:Clone()
				e5:SetCode(EFFECT_CANNOT_BE_POLARITY_MATERIAL)
				tc:RegisterEffect(e5)
				 local e6=e1:Clone()
				e6:SetCode(EFFECT_CANNOT_BE_SPACE_MATERIAL)
				tc:RegisterEffect(e6)

  local e7=e1:Clone()
				e6:SetCode(EFFECT_CANNOT_BE_BIGBANG_MATERIAL)
				 tc:RegisterEffect(e7)
   local e11=e1:Clone()
 e11:SetCode(EFFECT_CANNOT_BE_SPATIAL_MATERIAL)
		tc:RegisterEffect(e11)  
		local e12=e1:Clone()
		e12:SetCode(EFFECT_CANNOT_BE_HARMONIZED_MATERIAL)
		tc:RegisterEffect(e12)
		local e13=e1:Clone()
		e13:SetCode(EFFECT_CANNOT_BE_BYPATH_MATERIAL)
		tc:RegisterEffect(e13)
		local e14=e1:Clone()
		e14:SetCode(EFFECT_CANNOT_BE_TIMELEAP_MATERIAL)
		tc:RegisterEffect(e14)
		local e15=e1:Clone()
		e15:SetCode(EFFECT_CANNOT_HAVE_CHROMA_MATERIAL)
		tc:RegisterEffect(e15)
		local e16=e1:Clone()
		e16:SetCode(EFFECT_CANNOT_BE_ANNOTEE_MATERIAL)
		tc:RegisterEffect(e16)
		local e17=e1:Clone()
		e17:SetCode(EFFECT_CANNOT_BE_ACCENTED_MATERIAL)
		tc:RegisterEffect(e17)
		local e18=e1:Clone()
		e18:SetCode(EFFECT_CANNOT_BE_ACCENTED_MATERIAL)
		tc:RegisterEffect(e18)
			end
		end
	end
end
function c160005555.repfilter(c,tp)
	return c:IsFaceup() and  c:IsSetCard(0xc50) and c:IsLocation(LOCATION_PZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c160005555.repfilterxxl(c,e)
	return not c:IsType(TYPE_EFFECT)
		and c:IsAbleToRemove()
end
function c160005555.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c160005555.repfilter,1,e:GetHandler(),tp)  and Duel.IsExistingMatchingCard(c160005555.repfilterxxl,tp,LOCATION_EXTRA,0,1,c,e) end
   if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c160005555.repfilterxxl,tp,LOCATION_EXTRA,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c160005555.repval(e,c)
	return c160005555.repfilter(c,e:GetHandlerPlayer())
end
function c160005555.repop(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function c160005555.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xc50)
end
