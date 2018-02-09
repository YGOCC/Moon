--created & coded by Lyris
--サイバーダーク・エクステンション・コード
function c240100058.initial_effect(c)
	--Activate this card by targeting 1 "Cyberdark" Machine monster in your GY and 1 Dragon monster in the GY, plus an additional Level 3 or lower card unless you targeted a "Cyberdark" Fusion Monster; Special Summon the first target, then equip the last target in the GY (this is treated as equipping by the Summoned monster's effect) and this card to the first target. (HOPT1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,240100058)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCost(c240100058.cost)
	e1:SetOperation(c240100058.activate)
	c:RegisterEffect(e1)
	--If exactly 1 "Cyberdark" Machine monster is Summoned: You can target 1 Dragon monster in the GY, plus another Level 3 or lower Dragon monster unless you Summoned a Fusion Monster; unless the Summoned monster activated an effect that targets a card, equip the last target to it (this is treated as equipping that target by the Summoned monster's effect). Otherwise, that effect now targets the newest target. (HOPT1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,240100058)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCondition(c240100058.condition)
	e2:SetTarget(c240100058.target)
	e2:SetOperation(c240100058.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
end
function c240100058.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x4093)
end
function c240100058.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c240100058.cfilter,nil)
	e:SetLabelObject(g:GetFirst())
	return g:GetCount()==1
end
function c240100058.filter(c,ec,tp)
	return c:IsRace(RACE_DRAGON) and not c:IsForbidden()
		and (ec:IsType(TYPE_FUSION) or Duel.IsExistingTarget(c240100058.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c))
end
function c240100058.filter2(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_DRAGON) and not c:IsForbidden()
end
function c240100058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetLabelObject()
	if chkc then return c:IsType(TYPE_FUSION) and chkc:IsLocation(LOCATION_GRAVE) and c240100058.filter(chkc,c,tp) end
	if chk==0 then
		local b=e:GetHandler():IsLocation(LOCATION_HAND)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ((b and ft>1) or (not b and ft>0))
			and Duel.IsExistingTarget(c240100058.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c240100058.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,c,tp)
	if not c:IsType(TYPE_FUSION) then
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		g=Duel.SelectTarget(tp,c240100058.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc,c,tp)
	end
	if not c:IsStatus(STATUS_CHAINING) then c:CreateEffectRelation(e) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c240100058.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetLabelObject()
	if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Equip(tp,e:GetHandler(),c)
		--Add Equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(function(e,c) return e:GetLabelObject()==c end)
		e1:SetLabelObject(c)
		e:GetHandler():RegisterEffect(e1)
	elseif c:IsLocation(LOCATION_GRAVE) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for ec in aux.Next(tg) do
		if tg:GetCount()==1 then break end
		tg:RemoveCard(ec)
	end
	for i=1,Duel.GetCurrentChain() do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()==c and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			Duel.ChangeTargetCard(i,tg)
			return
		end
	end
	local tc=tg:GetFirst()
	if c:IsFaceup() and tc then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c240100058.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(c240100058.repval)
		tc:RegisterEffect(e3)
	end
end
function c240100058.eqlimit(e,c)
	return e:GetOwner()==c
end
function c240100058.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c240100058.filter3(c,tp,e)
	return c240100058.cfilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c240100058.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,tp)
end
function c240100058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c240100058.filter3,tp,LOCATION_GRAVE,0,1,nil,tp,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c240100058.filter3,tp,LOCATION_GRAVE,0,1,1,nil,tp,e):GetFirst()
	e:SetLabelObject(tc)
	Duel.BreakEffect()
	c240100058.target(e,tp,eg,ep,ev,re,r,rp,1)
end
