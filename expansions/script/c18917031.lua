--Protector Statue of the Drought
local ref=_G['c'..18917031]
function ref.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--ACtivate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18917031,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE+LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(ref.actcon)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1)
	--On Normal
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(ref.nstg)
	e2:SetOperation(ref.nsop)
	c:RegisterEffect(e2)
	--Re-Set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(ref.setcon)
	e3:SetCost(ref.setcost)
	e3:SetTarget(ref.settg)
	e3:SetOperation(ref.setop)
	c:RegisterEffect(e3)
end

--Pandemonium effect
function ref.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and eg:GetFirst():IsControler(1-tp)
end
function ref.actfilter(c)
	return c:IsAttackPos()
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local trigc=eg:GetFirst()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc~=trigc and ref.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.actfilter,tp,0,LOCATION_MZONE,1,trigc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.actfilter,tp,0,LOCATION_MZONE,1,1,trigc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) then
		local pos=0
		if tc:IsAttackPos() then
			if tc:IsCanTurnSet() then
				pos=Duel.SelectPosition(tp,tc,POS_DEFENSE+POS_FACEDOWN_ATTACK)
			else
				pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE)
			end
			Duel.ChangePosition(tc,pos)
		else
			if tc:IsCanTurnSet() then
				pos=Duel.SelectPosition(tp,tc,POS_ATTACK+POS_FACEDOWN_DEFENCE)
			else
				pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK)
			end
			Duel.ChangePosition(tc,pos)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

--On Normal Summon effects
function ref.nsfilter(c,e,tp)
	return c:GetLevel()>0 and c:GetLevel()<=4
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.nstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.nsfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.nsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.nsfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function ref.nsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Reset to your side of the field
function ref.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and aux.exccon(e)
end
function ref.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_EARTH)
	Duel.Release(g,REASON_COST)
end
function ref.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function ref.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
