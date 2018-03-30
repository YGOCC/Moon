--Sacred Shielder - Mirror
--Script by XGlitchy30
function c37200261.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200261,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c37200261.condition)
	e1:SetTarget(c37200261.target)
	e1:SetOperation(c37200261.operation)
	c:RegisterEffect(e1)
	--Mirror Force effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37200261,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,37200261)
	e2:SetCondition(c37200261.MFcon)
	e2:SetCost(c37200261.MFcost)
	e2:SetTarget(c37200261.MFtg)
	e2:SetOperation(c37200261.MFop)
	c:RegisterEffect(e2)
	--set card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200261,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c37200261.setcon)
	e3:SetTarget(c37200261.settg)
	e3:SetOperation(c37200261.setop)
	c:RegisterEffect(e3)
end
--filters
function c37200261.MFfilter(c)
	return c:IsAttackPos()
end
function c37200261.setfilter(c)
	return c:IsSetCard(0xbf86) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
--Activate
function c37200261.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c37200261.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	--parameters
	local atk=a:GetAttack()
	local def=a:GetDefense()
	local lv=a:GetLevel()
	local race=a:GetRace()
	local att=a:GetAttribute()
	--
	if chk==0 then return a:IsOnField() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,37200261,0,0x21,atk,def,lv,race,att)
	end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c37200261.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	--parameters
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local lv=tc:GetLevel()
	local race=tc:GetRace()
	local att=tc:GetAttribute()
	--
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,37200261,0,0x21,atk,def,lv,race,att) then return end
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local op=Duel.GetOperatedGroup()
			c:AddMonsterAttribute(TYPE_TRAP+TYPE_EFFECT)
			Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP_ATTACK)
			c:AddMonsterAttributeComplete()
			--add monster stats
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0xfe0000)
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(def)
			c:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetValue(lv)
			c:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CHANGE_RACE)
			e4:SetValue(race)
			c:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e5:SetValue(att)
			c:RegisterEffect(e5,true)
			Duel.SpecialSummonComplete()
		end
	end
end
--Mirror Force effect
function c37200261.MFcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c37200261.MFcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c37200261.MFtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200261.MFfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c37200261.MFfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c37200261.MFop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c37200261.MFfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--set
function c37200261.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c37200261.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c37200261.setfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c37200261.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c37200261.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c37200261.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end