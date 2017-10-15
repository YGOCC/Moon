--Digimon Myotismon
function c47000040.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3E4),aux.NonTuner(Card.IsSetCard,0x6E7),1)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(47000040,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c47000040.target)
	e2:SetOperation(c47000040.operation)
	c:RegisterEffect(e2)
	--Special Summon 1 Token
  	local e3=Effect.CreateEffect(c)
  	e3:SetDescription(aux.Stringid(47000040,1))
  	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  	e3:SetType(EFFECT_TYPE_IGNITION)
  	e3:SetRange(LOCATION_MZONE)
  	e3:SetCountLimit(1)
  	e3:SetTarget(c47000040.tktg)
  	e3:SetOperation(c47000040.tkop)
  	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47000040,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c47000040.thcost)
	e5:SetTarget(c47000040.thtg)
	e5:SetOperation(c47000040.thop)
	c:RegisterEffect(e5)
end
function c47000040.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,47000034,0x3E4, 0x4011,300,200,1,RACE_FIEND,ATTRIBUTE_DARK) end
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47000040.tkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,47000034,0x3E4,0x4011,300,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
  local token=Duel.CreateToken(tp,47000034)
  Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c47000040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c47000040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c47000040.retcon)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c47000040.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c47000040.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c47000040.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsForbidden() then 
		Duel.SendtoGrave(tc,REASON_RULE)
	elseif Duel.ReturnToField(tc) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e2)
	end
end
function c47000040.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_TOKEN)
	Duel.Release(g,REASON_COST)
end
function c47000040.filter(c)
	return c:IsCode(47000038) and c:IsAbleToHand()
end
function c47000040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000040.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c47000040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47000040.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

