--Gaia Dragon, Mythic Guardian of the Earth
--Script by XGlitchy30
function c37200239.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,37200210,c37200239.dragonmat)
	--lock spell/traps
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200239,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c37200239.lockcon)
	e1:SetOperation(c37200239.lockop)
	c:RegisterEffect(e1)
	--atk/def boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c37200239.boost)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--secure attacks
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c37200239.actcon)
	e4:SetValue(c37200239.aclimit)
	c:RegisterEffect(e4)
	--piercing battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	--battle destruction
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(37200239,2))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_NEGATE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_DESTROYED)
	e6:SetCondition(c37200239.btdcon)
	e6:SetTarget(c37200239.btdtg)
	e6:SetOperation(c37200239.btdop)
	c:RegisterEffect(e6)
	--effect destruction
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(37200239,3))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c37200239.edcon)
	e7:SetTarget(c37200239.edtg)
	e7:SetOperation(c37200239.edop)
	c:RegisterEffect(e7)
end
--fusion material filters
function c37200239.dragonmat(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:GetLevel()>=5
end
--filters
function c37200239.thfilter(c)
	return (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_DRAGON)) and c:IsAbleToHand()
end
--values
function c37200239.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c37200239.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--lock spell/traps
function c37200239.lockcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c37200239.lockop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c37200239.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--atk/def boost condition
function c37200239.boost(e,tp,eg,ep,ev,re,r,rp)
	local fd=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(fd,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(fd,0,LOCATION_MZONE)
end
--secure attacks condition
function c37200239.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
--battle destruction effect
function c37200239.btdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
		and e:GetHandler():GetReasonCard():IsRelateToBattle()
end
function c37200239.btdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local rc=e:GetHandler():GetReasonCard()
	Duel.SetTargetCard(rc)
end
function c37200239.btdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove() and rc:IsFaceup() and rc:IsRelateToEffect(e) then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.NegateRelatedChain(rc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(-1000)
			rc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			e4:SetValue(-1000)
			rc:RegisterEffect(e4)
			if rc:IsType(TYPE_TRAPMONSTER) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				rc:RegisterEffect(e5)
			end
		end
	end
end
--effect destruction effect
function c37200239.edcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c37200239.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c37200239.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c37200239.edop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove() then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c37200239.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end