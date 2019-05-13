--Paintress Duchumpia
function c500310786.initial_effect(c)
	  --pendulum summon
	aux.EnablePendulumAttribute(c)
	

 -- local e3=Effect.CreateEffect(c)
   -- e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
   -- e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
   -- e3:SetRange(LOCATION_PZONE)
	--e3:SetCode(EVENT_BE_BATTLE_TARGET)
	--e3:SetOperation(c500310786.operation666)
	--c:RegisterEffect(e3)
  --tohand
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(function(e) return e:GetHandler():GetFlagEffect(500310786)~=0 end)
	e2:SetTarget(c500310786.atklimtg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(c500310786.checkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,500310786)
	--e4:SetCost(c500310786.cost)
	e4:SetTarget(c500310786.target)
	e4:SetOperation(c500310786.operation)
	c:RegisterEffect(e4)
end

function c500310786.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc50) and not c:IsForbidden()
end
function c500310786.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra()  end
  --  Duel.SendtoExtraP(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_COST)
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c500310786.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c500310786.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2 end
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)

end
function c500310786.operation(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c500310786.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(500310786,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(500310786,0))
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoExtraP(tg1,tp,REASON_EFFECT)
	end
end

function c500310786.atklimtg(e,c)
	return c:GetFieldID()~=e:GetLabel() and c:IsType(TYPE_EFFECT) and not c:IsSetCard(0xc50)
end
function c500310786.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(500310786)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(500310786,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end

function c500310786.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500310786.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c500310786.operation666(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_CHAIN)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc52))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
  local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	Duel.RegisterEffect(e2,tp)
end
