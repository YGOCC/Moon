--Paintress EX - Da Vinca
function c160002239.initial_effect(c)
	 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,c160002239.checku,7,c160002239.filter1,c160002239.filter2)
	c:EnableReviveLimit()
		--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	 e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2)
	Duel.RegisterEffect(e1)
 --cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	  --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160002239,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,160002239)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c160002239.pscost)
	e3:SetTarget(c160002239.pstg)
	e3:SetOperation(c160002239.psop)
	c:RegisterEffect(e3)
end

function c160002239.checku(sg,ec,tp)
return sg:IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function c160002239.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c160002239.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end
function c160002239.psfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c160002239.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c160002239.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c160002239.psfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c160002239.psop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c160002239.psfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c160002239.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end