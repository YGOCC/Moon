--Complete Release Virtuakit-X
function c979812053.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c979812053.runcon)
	r1:SetOperation(c979812053.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c979812053.runlimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c979812053.atkval)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c979812053.defval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(38517737,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c979812053.descon)
	e4:SetTarget(c979812053.destg)
	e4:SetOperation(c979812053.desop)
	c:RegisterEffect(e4)
	--Indes Battle
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c979812053.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2fe5)
end
function c979812053.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c979812053.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c979812053.matfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c979812053.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,nil)
end
function c979812053.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c979812053.matfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c979812053.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,2,nil,c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c979812053.runlimit(e,se,sp,st)
	return bit.band(st,0x4f000000)==0x4f000000
end
function c979812053.atkval(e,c)
	local g=e:GetHandler():GetEquipGroup()
	return g:GetSum(Card.GetAttack)
end
function c979812053.defval(e,c)
	local g=e:GetHandler():GetEquipGroup()
	return g:GetSum(Card.GetDefense)
end
function c979812053.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c979812053.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c979812053.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
