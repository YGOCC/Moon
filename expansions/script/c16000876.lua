--Medivatale Scorpionboi
function c16000876.initial_effect(c)
   --special summon
   -- local e1=Effect.CreateEffect(c)
   -- e1:SetType(EFFECT_TYPE_FIELD)
   -- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
   -- e1:SetCode(EFFECT_SPSUMMON_PROC)
   -- e1:SetRange(LOCATION_HAND)
  --  e1:SetCountLimit(1,16000876)
  --  e1:SetCondition(c16000876.sprcon)
  --  c:RegisterEffect(e1) 
--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,16000876)
	e2:SetTarget(c16000876.sptg)
	e2:SetOperation(c16000876.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c16000876.condition2)
	e5:SetOperation(c16000876.operation2)
	c:RegisterEffect(e5)
end
function c16000876.cfilter(c)
	return c:IsFaceup() and  c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT)
end
function c16000876.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  not Duel.IsExistingMatchingCard(c16000876.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16000876.filter(c,e,tp)
	return   c:IsSetCard(0xab5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16000876.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c16000876.spop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16000876.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16000876.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
		function c16000876.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return  ec:GetMaterial():IsExists(c16000876.ffilter,1,nil) and r&(REASON_SUMMON+REASON_FUSION+REASON_SYNCHRO+REASON_RITUAL+REASON_XYZ+REASON_LINK)==0
end
function c16000876.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
 if Duel.GetFlagEffect(tp,16000876)~=0 then return end  
			  --pierce
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000876,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(c16000876.con)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c16000876.damcon)
	e2:SetOperation(c16000876.damop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(16000876,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000876,0))
	Duel.RegisterFlagEffect(tp,16000876,RESET_PHASE+PHASE_END,0,1)
end
function c16000876.con(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetCounter(0x88)>=4
end
function c16000876.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and e:GetHandler():GetCounter(0x88)>=4 and  c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c16000876.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
