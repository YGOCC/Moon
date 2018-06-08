--Shadow Mage of the Graveyard
--Keddy was here~
local id,cod=1013072,c1013072
function cod.initial_effect(c)
	c:EnableReviveLimit()
	--Pendulum Summon
	aux.EnablePendulumAttribute(c,false)
	--Synchro Summon
	aux.AddSynchroMixProcedure(c,cod.matfilter1,nil,nil,aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1,99)
	--No Tuner Check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(80896940)
	c:RegisterEffect(e1)
	--===Pendulum Effects===--
	--Gain LP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(cod.lpcost)
	e3:SetTarget(cod.lptg)
	e3:SetOperation(cod.lpop)
	c:RegisterEffect(e3)
	--Cannot Negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetValue(cod.efilter)
	c:RegisterEffect(e4)
	--===Monster Effects===--
	--Add to Hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(cod.thcon)
	e5:SetTarget(cod.thtg)
	e5:SetOperation(cod.thop)
	c:RegisterEffect(e5)
	--Place
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cod.pencon)
	e6:SetTarget(cod.pentg)
	e6:SetOperation(cod.penop)
	c:RegisterEffect(e6)
end

--Synchro Summon
function cod.matfilter1(c)
	return (c:IsType(TYPE_TUNER) and c:IsRace(RACE_ZOMBIE))
		or (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsNotTuner())
end

--Gain LP
function cod.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.GetFirstMatchingCard(Card.IsDestructable,tp,LOCATION_PZONE,0,e:GetHandler())
	local g=Group.FromCards(e:GetHandler(),tc)
	Duel.Destroy(g,REASON_COST)
	e:SetLabel(g:GetSum(Card.GetAttack)/2)
end
function cod.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function cod.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

--Cannot Negate
function cod.efilter(e,ct)
	local te,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return loc==LOCATION_GRAVE and te:IsActiveType(TYPE_MONSTER) and tc:IsRace(RACE_ZOMBIE)
end

--Add to Hand
function cod.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_ZOMBIE)
end
function cod.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	if bit.band(e:GetHandler():GetSummonType(),0x46000000)~=SUMMON_TYPE_SYNCHRO then return false end
	if g:IsExists(cod.mfilter,1,nil) then
		e:SetLabel(2)
		return true
	else
		e:SetLabel(1)
		return true
	end
end
function cod.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cod.nvfilter(chkc) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.IsType,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cod.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsType,nil,g1:GetFirst():GetType())
	if g:GetCount()>0 and e:GetLabel()>1 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	if g1:GetCount()==0 then return end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end

--Place
function cod.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r|REASON_EFFECT+REASON_BATTLE~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cod.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cod.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end