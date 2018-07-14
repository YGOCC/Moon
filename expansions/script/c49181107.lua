--Shadow Combination Crowstorm
--by Nix
--known issues: 
function c49181107.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c49181107.lvtg)
	e1:SetValue(c49181107.lvval)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c49181107.atkval)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49181107,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c49181107.eqcost)
	e3:SetTarget(c49181107.eqtg)
	e3:SetOperation(c49181107.eqop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49181107,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c49181107.reccon)
	e4:SetTarget(c49181107.rectg)
	e4:SetOperation(c49181107.recop)
	c:RegisterEffect(e4)
	--activate field
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetOperation(c49181107.acop)
	c:RegisterEffect(e5)
end
function c49181107.lvtg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5AA)
end
function c49181107.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 7
	else return lv end
end
function c49181107.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c49181107.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c49181107.eqfilter(c,e,tp,ec)
	return c:IsSetCard(0x5AA) and c:IsType(TYPE_UNION) and c:CheckEquipTarget(c,ec)
end
function c49181107.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c49181107.eqfilter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c49181107.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	end
	local g=Duel.GetMatchingGroup(c49181107.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c49181107.eqfilter,tp,LOCATION_GRAVE,nil,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c49181107.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) and tc~=c then
			Duel.Equip(tp,tc,c,false)
			aux.SetUnionState(c)
		end
	end
end
function c49181107.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c49181107.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c49181107.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c49181107.acfilter(c)
	return c:IsCode(49181108) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c49181107.acop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c49181107.acfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end