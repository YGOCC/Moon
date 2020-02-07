--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cid.rev)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetDescription(1122)
	e2:SetCondition(cid.con)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(1110)
	e3:SetTarget(cid.target)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
end
function cid.rev(e,re,dam,r,rp,rc)
	local c=e:GetHandler()
	if r&REASON_EFFECT==0 or c:IsImmuneToEffect(e) then return dam end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(dam)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	return 0
end
function cid.con(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousAttackOnField()/2)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,e:GetLabel())
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabel()
	Duel.Damage(1-tp,d,REASON_EFFECT,true)
	Duel.Damage(tp,d,REASON_EFFECT,true)
	Duel.RDComplete()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cid.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function cid.sumlimit(e,c)
	return c:IsCode(id)
end