--Azura the Esper of Hidden Power
function c249000235.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c249000235.spcon)
	e1:SetOperation(c249000235.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--special summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c249000235.splimit)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32999573,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c249000235.rcon)
	e3:SetOperation(c249000235.rop)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c249000235.drcon)
	e4:SetTarget(c249000235.drtg)
	e4:SetOperation(c249000235.drop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
	--copy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(83994433,0))
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,2490002354)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCost(c249000235.cost)
	e7:SetOperation(c249000235.operation)
	c:RegisterEffect(e7)
	--pendulum zone draw
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(16178681,1))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTarget(c249000235.drtg2)
	e8:SetOperation(c249000235.drop2)
	c:RegisterEffect(e8)
end
c249000235.pendulum_level=5
function c249000235.spfilter1(c,c2)
	return c:IsSetCard(0x1B7) and c~=c2
end
function c249000235.spfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(7)
end
function c249000235.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c249000235.spfilter2,tp,LOCATION_MZONE,0,nil)
	return (not c:IsFaceup()) and g:GetCount() > 0 and Duel.IsExistingMatchingCard(c249000235.spfilter1,tp,LOCATION_ONFIELD,0,2,nil,g:GetFirst())
end
function c249000235.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c249000235.spfilter1,tp,LOCATION_ONFIELD,0,nil,nil)
	local g2=Duel.GetMatchingGroup(c249000235.spfilter2,tp,LOCATION_MZONE,0,nil)
	g1:Merge(g2)
	local m1=false
	local m2=false
	local m3=false
	local mg=Group.CreateGroup()
	local sg=Group.CreateGroup()
	while not (m1 and m3 and m3) do
		sg:Merge(g1)
		m1=false
		m2=false
		m3=false
		mg=Group.CreateGroup()
		for i=1,3 do
			local mcg=sg:Select(tp,1,1,nil)
			mg:Merge(mcg)
			local cc=mcg:GetFirst()
			sg:RemoveCard(cc)
			if cc:IsLocation(LOCATION_MZONE) and c249000235.spfilter2(cc) then m1=true
			elseif cc:IsLocation(LOCATION_ONFIELD) and c249000235.spfilter1(cc,nil) and m2==false then m2=true
			elseif cc:IsLocation(LOCATION_ONFIELD) and c249000235.spfilter1(cc,nil) then m3=true end
		end
	end			
	e:GetHandler():SetMaterial(mg)
	Duel.Overlay(e:GetHandler(),mg)
end
function c249000235.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler()==e:GetHandler())
end
function c249000235.rcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler()~=re:GetHandler() then return false end
	return e:GetHandler():GetFlagEffect(2490002351)==0 and bit.band(r,REASON_COST)~=0 and re:GetHandler():GetOverlayCount()>=ev-1
end
function c249000235.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	if ct>1 then
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
	e:GetHandler():RegisterFlagEffect(2490002351,RESET_PHASE+PHASE_END,0,1)
end
function c249000235.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c249000235.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000235.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	if (dc:IsRace(RACE_SPELLCASTER) or dc:IsRace(RACE_FAIRY)) and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(69584564,0)) then
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,dc)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c249000235.costfilter(c)
	local label
	if c:GetLevel() > 0 then label=c:GetLevel() else label=c:GetRank() end
	if label <= 0 then return false end
	return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c249000235.targetfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,label)
end
function c249000235.targetfilter(c,label)
	local lvrk
	if c:GetLevel() > 0 then lvrk=c:GetLevel() else lvrk=c:GetRank() end	
	return lvrk > 0 and (lvrk==label or lvrk - 1 == label or lvrk + 1 == label)
end
function c249000235.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000235.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000235.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local lvrk
	if g:GetFirst():GetLevel() > 0 then lvrk=g:GetFirst():GetLevel() else lvrk=g:GetFirst():GetRank() end
	e:SetLabel(lvrk)
	Duel.SendtoGrave(g,REASON_COST)
end
function c249000235.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	local g=Duel.GetMatchingGroup(c249000235.targetfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil,e:GetLabel())
	Duel.ConfirmCards(tp,g)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	Duel.ConfirmCards(1-tp,tg)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(tc:GetAttack()/2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetCondition(c249000235.damcon)
	e2:SetOperation(c249000235.damop)
	c:RegisterEffect(e2)
	Duel.MajesticCopy(c,tc)
end
function c249000235.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()==nil
end
function c249000235.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c249000235.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000235.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end