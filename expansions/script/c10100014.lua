--Kalte Fee die um Hilfe bat
function c10100014.initial_effect(c)
	c:EnableUnsummonable()
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c10100014.synlimit)
	e1:SetTargetRange(1,1)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)	
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100014,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10100014)
	e2:SetTarget(c10100014.tg)
	e2:SetOperation(c10100014.op)
	c:RegisterEffect(e2)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100014,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,10100014)
	e3:SetCondition(c10100014.condition)
	e3:SetTarget(c10100014.tg)
	e3:SetOperation(c10100014.op)
	c:RegisterEffect(e3)
end
function c10100014.synlimit(e,c)
	return c:IsSetCard(0x321)
end
function c10100014.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10100014.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c10100014.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Recover(tp,800,REASON_EFFECT)
	if ft<=0 then return end
end