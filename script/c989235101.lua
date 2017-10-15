--Transfigured, Horseman
function c989235101.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c989235101.runcon)
	r1:SetOperation(c989235101.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c989235101.runlimit)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(494922,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c989235101.settg)
	e2:SetOperation(c989235101.setop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95457011,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,989235101+EFFECT_COUNT_CODE_OATH)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c989235101.thtg)
	e3:SetOperation(c989235101.thop)
	c:RegisterEffect(e3)
end
function c989235101.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetAttack()==0 and c:GetDefense()==0)
end
function c989235101.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c989235101.runfilter1(c)
	return c989235101.matfilter1(c) and Duel.IsExistingMatchingCard(c989235101.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c989235101.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c989235101.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c989235101.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local mt1=Duel.SelectMatchingCard(tp,c989235101.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,2,nil,c)
	local g2=Duel.GetMatchingGroup(c989235101.matfilter2,tp,LOCATION_ONFIELD,0,nil,c)
	g:Merge(mt1)
	g2:Sub(mt1)
	local mt2=g2:Select(tp,2,2,nil)
	g:Merge(mt2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c989235101.runlimit(e,se,sp,st)
	return bit.band(st,0x4f000000)==0x4f000000
end
function c989235101.setfilter(c,tp)
	return c:IsSetCard(0xfe9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c989235101.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c989235101.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c989235101.setfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c989235101.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c989235101.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c989235101.thfilter1(c)
	return c:IsType(0x10000000) and c:IsAbleToHand()
end
function c989235101.thfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c989235101.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c989235101.thfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c989235101.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c989235101.thfilter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c989235101.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c989235101.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
