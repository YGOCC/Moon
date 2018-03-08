--coded by Lyris
--Steelus Infiltratem Ultima
function c192051220.initial_effect(c)
	c:EnableReviveLimit()
	--2+ "Steelus" monsters whose total Levels equal 12
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c192051220.lkcon)
	e0:SetOperation(c192051220.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--Cannot attack.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	--If this card is Link Summoned: Give control of it to your opponent, but it remains in the Extra Monster Zone it is in (if it is in one).
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c192051220.thcon)
	e2:SetTarget(c192051220.thtg)
	e2:SetOperation(c192051220.thop)
	c:RegisterEffect(e2)
	--When a monster is Normal Summoned to a zone this card points to: Destroy 1 monster you control, then your opponent can Special Summon 1 Level 3 Dragon monster from their GY.
	local e3=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c192051220.descon)
	e1:SetTarget(c192051220.destg)
	e1:SetOperation(c192051220.desop)
	c:RegisterEffect(e1)
end
function c192051220.lkfilter(c,lc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsSetCard(0x617)
end
function c192051220.lkcon(e,c)
	if c==nil then return true end
	if (c:IsType(TYPE_PENDULUM) or not Card.IsTypeCustom or c:IsTypeCustom("Pandemonium") or c:IsTypeCustom("Relay")) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c192051220.lkfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:CheckWithSumEqual(Card.GetLevel,12,4,4)
end
function c192051220.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c192051220.lkfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=mg:SelectWithSumEqual(tp,Card.GetLevel,12,4,4)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function c192051220.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c192051220.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
end
function c192051220.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=11-c:GetSequence()
	if c:IsRelateToEffect(e) and Duel.GetControl(c,1-tp,0,1) then
		Duel.MoveSequence(c,seq)
	end
end
function c192051220.cfilter(c,tp,zone)
	local seq=c:GetSequence()
	if c:IsControler(1-tp) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c192051220.descon(e,tp,eg,ep,ev,re,r,rp)
	local zone=c:GetLinkedZone()*0x10000
	return eg:IsExists(c192051220.cfilter,1,nil,tp,zone)
end
function c192051220.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
end
function c192051220.filter(c,e,tp)
	return g:GetLevel()==3 and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function c192051220.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		local mg=Duel.GetMatchingGroup(c192051220.filter,tp,0,LOCATION_GRAVE,nil,e,tp)
		if mg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(192051220,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(1-tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
