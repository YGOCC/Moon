--Overlay-Force Royal Archer
function c249000447.initial_effect(c)
	--ATK up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31786629,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c249000447.target)
	e1:SetOperation(c249000447.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000447.spcon)
	c:RegisterEffect(e2)
	--xyzlv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c249000447.xyzlv)
	c:RegisterEffect(e3)
end
function c249000447.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000447.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c249000447.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000447.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000447.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c249000447.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RANK)
		e2:SetValue(2)
		tc:RegisterEffect(e2)	
	end
end
function c249000447.cfilter(c)
	return (c:IsFacedown() or not (c:IsSetCard(0x1BF) or c:IsType(TYPE_XYZ))) and c:IsType(TYPE_MONSTER)
end
function c249000447.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c249000447.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c249000447.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end