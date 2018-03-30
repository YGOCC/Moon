--Spellbook of Unknown Arts
--Script by XGlitchy30
function c37200240.initial_effect(c)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37200240)
	e1:SetLabel(0)
	e1:SetTarget(c37200240.actg)
	e1:SetOperation(c37200240.act)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,37200240)
	e2:SetLabel(0)
	e2:SetCondition(c37200240.tgcon)
	e2:SetCost(c37200240.tgcost)
	e2:SetTarget(c37200240.tgtg)
	e2:SetOperation(c37200240.tgop)
	c:RegisterEffect(e2)
end
--filters
function c37200240.acfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c37200240.tgfilter(c,tp,e)
	return c:IsRace(RACE_SPELLCASTER) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToHand())
end
--Activate
function c37200240.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsRace(RACE_SPELLCASTER) end
	if chk==0 then return Duel.IsExistingTarget(c37200240.acfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c37200240.acfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c37200240.act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabelObject(c)
		e1:SetOperation(c37200240.acop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c37200240.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:GetHandler()~=e:GetLabelObject() then
		local ATK=Effect.CreateEffect(e:GetHandler())
		ATK:SetType(EFFECT_TYPE_SINGLE)
		ATK:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ATK:SetRange(LOCATION_MZONE)
		ATK:SetCode(EFFECT_UPDATE_ATTACK)
		ATK:SetValue(300)
		ATK:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(ATK)
		local DEF=ATK:Clone()
		DEF:SetCode(EFFECT_UPDATE_DEFENSE)
		e:GetHandler():RegisterEffect(DEF)
	end
end
--banish
function c37200240.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c37200240.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c37200240.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsRace(RACE_SPELLCASTER) end
	if chk==0 then 
		return Duel.IsExistingTarget(c37200240.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,e)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c37200240.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp,e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c37200240.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local opt=0
	if tc and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAbleToHand() then 
		opt=Duel.SelectOption(tp,aux.Stringid(37200240,1),aux.Stringid(37200240,2))
	elseif tc and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		opt=0
	elseif tc and tc:IsAbleToHand() then
		opt=1
	else return false
	end
	if opt==0 then
		if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	else
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
