--Transfigured Lotus Beast
function c998721301.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c998721301.runcon)
	r1:SetOperation(c998721301.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c998721301.runlimit)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c998721301.atcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95457011,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c998721301.sptg)
	e4:SetOperation(c998721301.spop)
	c:RegisterEffect(e4)
end
function c998721301.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetAttack()==0 and c:GetDefense()==0)
end
function c998721301.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c998721301.runfilter1(c)
	return c998721301.matfilter1(c) and Duel.IsExistingMatchingCard(c998721301.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c998721301.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c998721301.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c998721301.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local mt1=Duel.SelectMatchingCard(tp,c998721301.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,2,nil,c)
	local g2=Duel.GetMatchingGroup(c998721301.matfilter2,tp,LOCATION_ONFIELD,0,nil,c)
	g:Merge(mt1)
	g2:Sub(mt1)
	local mt2=g2:Select(tp,2,2,nil)
	g:Merge(mt2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c998721301.runlimit(e,se,sp,st)
	return bit.band(st,0x4f000000)==0x4f000000
end
function c998721301.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x84)
end
function c998721301.atcon(e)
	return Duel.IsExistingMatchingCard(c998721301.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c998721301.spfilter(c,e,tp)
	return c:IsSetCard(0xfe9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c998721301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c998721301.spfilter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c998721301.spfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c998721301.spfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c998721301.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft>0 and (g:GetCount()>0 or (g:GetCount()>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if g:GetCount()>ft then g=g:Select(tp,ft,ft,nil) end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
