--Buttergal of Fiber VINE
function c500311550.initial_effect(c)
	 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,4,c500311550.filter1,c500311550.filter2)
	c:EnableReviveLimit() 
  --cannot be target/battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c500311550.con)
	e1:SetTarget(c500311550.tgtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e2)
		 --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500311550,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1)
	--e3:SetCondition(c500311550.condition)
	e3:SetCost(c500311550.cost)
	e3:SetTarget(c500311550.target)
	e3:SetOperation(c500311550.operation)
	c:RegisterEffect(e3)
   
end
function c500311550.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) 
end
function c500311550.filter2(c,ec,tp)
	return c:IsRace(RACE_PLANT+RACE_INSECT) 
end
function c500311550.con(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetCounter(0x88)==4
end
function c500311550.tgtg(e,c)
	return  c:IsType(TYPE_RITUAL) or c:IsType(TYPE_EVOLUTE)
end
function c500311550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	c:RemoveCounter(tp,0x88,4,REASON_COST) 
	--local e1=Effect.CreateEffect(c)
  --  e1:SetType(EFFECT_TYPE_FIELD)
   -- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
   -- e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  --  e1:SetReset(RESET_PHASE+PHASE_END)
  --  e1:SetLabelObject(c)
  --  e1:SetTargetRange(1,0)
  --  e1:SetTarget(c50031569.splimit)
   -- Duel.RegisterEffect(e1,tp)
end
function c500311550.tgfilter(c)
	 return c:IsLevelBelow(4) and c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c500311550.thfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c500311550.thfilter(c,code)
	return (c:IsRace(RACE_PLANT) or c:IsSetCard(0x185a)) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and not c:IsForbidden() and c:IsAbleToHand()
end
function c500311550.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c500311550.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c500311550.operation(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c500311550.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c500311550.thfilter,tp,LOCATION_DECK,0,2,2,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
