--Paintress Everdingenia
function c161002234.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c161002234.splimit)
	e2:SetCondition(c161002234.splimcon)
	c:RegisterEffect(e2)
		--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(161002234,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c161002234.descon)
	e3:SetTarget(c161002234.destg)
	e3:SetOperation(c161002234.desop)
	c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c161002234.thcon)
	e4:SetTarget(c161002234.thtg)
	e4:SetOperation(c161002234.thop)
	c:RegisterEffect(e4)
end


function c161002234.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c161002234.splimcon(e)
	return not e:GetHandler():IsForbidden()
end

function c161002234.cfilter(c,tp)
	return c:IsControler(tp)  and c:IsSetCard(0xc50) 
		and c:GetPreviousControler()==tp

end

function c161002234.descon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c161002234.cfilter,1,nil,tp)
end
function c161002234.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local tc=eg:GetFirst()
if chkc then return chkc==tc end
if chk==0 then return tc and tc:GetReasonCard() and tc:GetReasonCard():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc:GetReasonCard())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c161002234.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c161002234.thcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return a:IsSetCard(0xc50)
		and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c161002234.xxfilter(c)
	return c:IsDestructable()
end
function c161002234.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c161002234.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c161002234.xxfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c161002234.xxfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c161002234.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
