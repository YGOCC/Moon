--Paintress Charexia
function c160001200.initial_effect(c)
  
   aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
  aux.AddEvoluteProc(c,nil,5,c160001200.filter1,c160001200.filter2,1,99)
	  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160001200,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   -- e1:SetCountLimit(1,160001200)
	e1:SetCondition(c160001200.drcon)
   -- e1:SetCost(c160001200.drcost)
	e1:SetTarget(c160001200.drtg)
	e1:SetOperation(c160001200.drop)
	c:RegisterEffect(e1) 
	  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160001200,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c160001200.cost)
	e2:SetTarget(c160001200.destg)
	e2:SetOperation(c160001200.desop)
	c:RegisterEffect(e2)
end
function c160001200.filter1(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c160001200.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end

function c160001200.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c160001200.filterx(c,ec,tp)
	return c:IsSetCard(0xc50) and c:IsAbleToRemove()
end

function c16000538.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160001200.filterx,tp,LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c160001200.filterx,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end

function c16000538.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c160001200.filterx,tp,LOCATION_GRAVE,0,nil)
	 Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.Recover(p,500,REASON_EFFECT)

end
function c160001200.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc50) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160001200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
	 e:GetHandler():RemoveEC(tp,3,REASON_COST)
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
function c160001200.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsIsDestructable() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c160001200.thfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsIsDestructable,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c160001200.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c160001200.thfilter,tp,LOCATION_PZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			
		end
	end
end