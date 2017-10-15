--T.G. Malice Witch
function c240100001.initial_effect(c)
	c:EnableReviveLimit()
	--2 monsters with different Types
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(240100001,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c240100001.linkcon)
	e0:SetOperation(c240100001.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--You can also Link Summon this card using 1 "T.G. Wonder Magician" you control as the Link Material. 
	local e3=e0:Clone()
	e3:SetDescription(aux.Stringid(240100001,2))
	e3:SetCondition(c240100001.alcon)
	e3:SetOperation(c240100001.alop)
	c:RegisterEffect(e3)
	--Once per turn: You can target 1 other "T.G." monster you control and 1 Spell/Trap your opponent controls; destroy them.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(240100001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c240100001.destg)
	e1:SetOperation(c240100001.desop)
	c:RegisterEffect(e1)
	--If this card is destroyed: You can Special Summon 1 "T.G. Wonder Magican" from your Extra Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(c240100001.sptg)
	e2:SetOperation(c240100001.spop)
	c:RegisterEffect(e2)
end
function c240100001.linkfilter1(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and Duel.IsExistingMatchingCard(c240100001.linkfilter2,tp,LOCATION_MZONE,0,1,c,lc,c,tp)
end
function c240100001.linkfilter2(c,lc,mc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and not c:IsRace(mc:GetRace()) and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function c240100001.linkcon(e,c)
	if c==nil then return true end
	if (c:IsType(TYPE_PENDULUM) or (not Card.IsTypeCustom or c:IsTypeCustom("Pandemonium") or c:IsTypeCustom("Relay"))) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c240100001.linkfilter1,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c240100001.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c240100001.linkfilter1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,c240100001.linkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
function c240100001.linkfilter(c,lc)
	return c:IsFaceup() and c:IsCode(98558751) and c:IsCanBeLinkMaterial(lc) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),lc)>0
end
function c240100001.alcon(e,c)
	if c==nil then return true end
	if (c:IsType(TYPE_PENDULUM) or not Card.IsTypeCustom or c:IsTypeCustom("Pandemonium") or c:IsTypeCustom("Relay")) and c:IsFaceup() then return false end
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
