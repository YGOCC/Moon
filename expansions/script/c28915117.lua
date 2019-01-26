--Synchro
local ref=_G['c'..28915117]
local id=28915117
function ref.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,ref.matfilter,nil,nil,aux.NonTuner(nil),1,99)
	--On-Summon Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.drcon)
	e1:SetTarget(ref.drtg)
	e1:SetOperation(ref.drop)
	c:RegisterEffect(e1)
	--On-banish Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+EFFECT_COUNT_SECOND_HOPT)
	e2:SetCondition(ref.descon)
	e2:SetTarget(ref.destg)
	e2:SetOperation(ref.desop)
	c:RegisterEffect(e2)
end
function ref.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or Duel.GetFlagEffect(c:GetControler(),1600000000)~=0
end

--Draw
function ref.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--Destroy
function ref.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_GRAVE)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	local g0 = Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.GetFirstTarget()
	Duel.Destroy(g0,REASON_EFFECT)
end
