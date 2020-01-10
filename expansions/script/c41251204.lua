--created by Alastar Rainford, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(cid.spcost)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
	aux.AddFusionProcFunRep(c,cid.cfilter2,2,false)
	aux.AddContactFusionProcedure(c,cid.cfilter,LOCATION_ONFIELD,LOCATION_ONFIELD,cid.sprop(c)):SetCondition(function(e,tc)
		if tc==nil then return true end
		return aux.ContactFusionCondition(cid.cfilter,LOCATION_ONFIELD,LOCATION_ONFIELD)
			and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,CARD_BLACK_GARDEN)
	end)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(function(e) return e:GetHandler():GetLocation()~=LOCATION_EXTRA end)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCost(cid.atkcost)
	e3:SetOperation(cid.atkup)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(function(e) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() end)
	e5:SetTarget(cid.pentg)
	e5:SetOperation(cid.penop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e6)
end
function cid.cfilter1(c,tp)
	return not c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT) and (c:IsFaceup() or c:IsControler(tp))
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=(Duel.GetReleaseGroup(tp)+Duel.GetReleaseGroup(1-tp)):Filter(cid.cfilter1,nil,tp)
	if chk==0 then return #g>0 end
	local sg=g:Select(tp,1,1,nil)
	e:SetLabel(math.floor(sg:GetFirst():GetBaseAttack()/2))
	Duel.Release(sg,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cid.cfilter2(c)
	return not c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
end
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(2)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cid.cfilter2,2,nil) end
	Duel.Release(Duel.SelectReleaseGroup(tp,cid.cfilter2,2,2,nil),REASON_COST)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>-e:GetLabel()
	local c=e:GetHandler()
	if chk==0 then e:SetLabel(0) return res and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function cid.cfilter(c,fc)
	local tp=fc:GetControler()
	return Duel.GetReleaseGroup(tp):IsContains(c) and (c:IsControler(tp) or c:IsFaceup())
end
function cid.sprop(c)
	return  function(g)
				Duel.Release(g,REASON_COST)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(function(e,te) return te:GetHandler():IsCode(CARD_BLACK_GARDEN) end)
				c:RegisterEffect(e1)
			end
end
function cid.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cid.cfilter2,1,nil) end
	Duel.Release(Duel.SelectReleaseGroup(tp,cid.cfilter2,1,1,nil),REASON_COST)
end
function cid.atkup(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function cid.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cid.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
