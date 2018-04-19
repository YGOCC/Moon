--Deepwood Lancer of Continuum
local voc=c1914
function c1914.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(voc.spcon)
	e2:SetCost(voc.spcost)
	e2:SetTarget(voc.sptg)
	e2:SetOperation(voc.spop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(voc.sdcon)
	c:RegisterEffect(e3)
	--cannot tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(voc.recon)
	c:RegisterEffect(e4)
	--add to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1914,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,1914)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(voc.addtohandcon)
	e5:SetTarget(voc.limtg)
	e5:SetOperation(voc.addtohandactivate)
	c:RegisterEffect(e5)
	--immune spell
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(voc.efilter)
	c:RegisterEffect(e6)
	--Atk update
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(voc.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	--Banish and gain
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_BATTLE_CONFIRM)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(voc.atttg)
	e9:SetOperation(voc.attop)
	c:RegisterEffect(e9)
end
function voc.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function voc.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d~=nil and d:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,d,1,0,0)
end
function voc.attop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function voc.atkval(e,c)
	local cont=c:GetControler()
	local lpvalue=0
	if Duel.GetLP(cont)<Duel.GetLP(1-cont) then lpvalue=Duel.GetLP(1-cont)-Duel.GetLP(cont) else lpvalue=Duel.GetLP(cont)-Duel.GetLP(1-cont) end
	return lpvalue
end
function voc.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function voc.addtohandactivate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(voc.handval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	--to grave
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetDescription(aux.Stringid(1914,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,1915)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetTarget(voc.tgtg)
	e5:SetOperation(voc.tgop)
	e:GetHandler():RegisterEffect(e5)
end
function voc.chlimit(e,ep,tp)
	return tp==ep
end
function voc.handval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
function voc.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function voc.togravefilter(c,p)
	return c:IsAbleToGrave()
end
function voc.togravefilter2(c,p)
	return not c:IsType(TYPE_TOKEN)
end
function voc.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local ttg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		Duel.SendtoGrave(ttg,REASON_EFFECT)
		local tttg=ttg:Filter(voc.togravefilter2,nil)
		local ct=tttg:GetCount()
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:FilterSelect(1-tp,voc.togravefilter,ct,ct,nil,1-tp)
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function voc.hfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousSetCard(0x5AA) and not c:IsReason(REASON_RULE)
end
function voc.addtohandcon(e,tp,eg,ep,ev,re,r,rp)		
	return eg:IsExists(voc.hfilter,1,nil,tp) and Duel.GetTurnPlayer()~=tp and Duel.GetLP(tp)<Duel.GetLP(1-tp) and (Duel.GetLP(1-tp)-Duel.GetLP(tp)>=4000)
end
function voc.recon(e,c)
	return not c:IsSetCard(0x5AA)
end
function voc.sdfilter(c)
	return not c:IsSetCard(0x5AA)
end
function voc.sdcon(e)
	return Duel.IsExistingMatchingCard(voc.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function voc.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function voc.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function voc.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function voc.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_ONFIELD)==0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end