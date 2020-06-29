--Paintress Cabrera
local cid,id=GetID()
function cid.initial_effect(c)
	  --pendulum summon
	aux.EnablePendulumAttribute(c)

		--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cid.atktg)
	e1:SetValue(600)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2) 

	 --tohand
	local e3=Effect.CreateEffect(c)
	 e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(cid.thtg)
	e3:SetOperation(cid.thop)
	c:RegisterEffect(e3)
end
function cid.atktg(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TUNER)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chkc then return  chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.filter(chkc) end
	if chk==0 then return  e:GetHandler():GetFlagEffect(id)==0 and Duel.IsExistingTarget(cid.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cid.filter,tp,LOCATION_MZONE,0,1,1,nil)
 c:RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end

function cid.thop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	  local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetValue(cid.splimit)
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
				local e8=e1:Clone()
				e8:SetCode(EFFECT_CANNOT_BE_EVOLUTE_MATERIAL)
				 tc:RegisterEffect(e8)
	end
end
function cid.splimit(e,c)
	if not c then return false end
	return c:IsType(TYPE_EFFECT) 
end