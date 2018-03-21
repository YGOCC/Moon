--created & coded by Lyris, art from Yu-Gi-Oh! 5D's Episode 74
--ＴＧ マリス・ウィッチ
function c240100001.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c240100001.lcheck)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetDescription(aux.Stringid(122518919,3))
	e3:SetCondition(c240100001.alcon)
	e3:SetOperation(c240100001.alop)
	e3:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c240100001.destg)
	e1:SetOperation(c240100001.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(c240100001.sptg)
	e2:SetOperation(c240100001.spop)
	c:RegisterEffect(e2)
end
function c240100001.lcheck(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount()
end
function c240100001.linkfilter(c,lc)
	return c:IsFaceup() and c:IsCode(98558751) and c:IsCanBeLinkMaterial(lc) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),lc)>0
end
function c240100001.alcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM+TYPE_PANDEMONIUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c240100001.linkfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c240100001.alop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c240100001.linkfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function c240100001.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x27) and c:IsDestructable()
end
function c240100001.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c240100001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c240100001.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c240100001.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c240100001.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c240100001.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c240100001.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c240100001.spfilter(c,e,tp)
	return c:IsSetCard(0x27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100001.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c240100001.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c240100001.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c240100001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
