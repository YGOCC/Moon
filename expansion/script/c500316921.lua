--Frex
function c500316921.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500316921,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c500316921.condition)
	e1:SetCost(c500316921.discost)
	e1:SetTarget(c500316921.target)
	e1:SetOperation(c500316921.operation)
	c:RegisterEffect(e1)
	if not c500316921.global_check then
		c500316921.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c500316921.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c500316921.evolute=true
c500316921.material1=function(mc) return mc:IsAttribute(ATTRIBUTE_EARTH) and (mc:GetLevel()==3 or mc:GetRank()==3) and mc:IsFaceup() end
c500316921.material2=function(mc) return mc:IsRace(RACE_DINOSAUR) and (mc:GetLevel()==3 or mc:GetRank()==3) and mc:IsFaceup() end
function c500316921.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c500316921.stage_o=6
c500316921.stage=c500316921.stage_o
end

function c500316921.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,3,REASON_COST)
end
function c500316921.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
end
function c500316921.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lp=Duel.GetLP(tp)
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:GetSummonLocation()==LOCATION_EXTRA then
			Duel.SetLP(1-tp,lp-1000)
		end
	end
end
