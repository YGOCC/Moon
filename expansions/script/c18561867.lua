--Legendary Six Samurai-Tatsu "Katana" Yamashiro
function c18531867.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18531867.spcon)
	e1:SetOperation(c18531867.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(185318676,1))
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCondition(c18531867.wincon)
	e5:SetOperation(c18531867.winop)
	c:RegisterEffect(e5)
end
function c18531867.spfilter(c,code)
	return c:IsOriginalCodeRule(code)
end
function c18531867.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(tp,c18531867.spfilter,1,nil,27782503)
		and Duel.CheckReleaseGroup(tp,c18531867.spfilter,1,nil,49721904)
		and Duel.CheckReleaseGroup(tp,c18531867.spfilter,1,nil,75116619)
end
function c18531867.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c18531867.spfilter,1,1,nil,27782503)
	local g2=Duel.SelectReleaseGroup(tp,c18531867.spfilter,1,1,nill,49721904)
	local g3=Duel.SelectReleaseGroup(tp,c18531867.spfilter,1,1,nil,75116619)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Release(g1,REASON_COST)
end
function c18531867.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d)
end
	function cfunction c18531867.winfilter(e,c)
	return c:GetOwner()==1-e:GetHandlerPlayer()
		and c:GetPreviousRaceOnField()&RACE_DRAGON~=0 and c:GetPreviousAttributeOnField()&ATTRIBUTE_DARK~=0 and c:Islevel(4)
end
function c18531867.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return c:GetSummonType()==SUMMON_TYPE_ADVANCE+1 and c18531867.winfilter(e,tc)
end
function c18531867.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_Legendary_Six_Samurai_Kaoru=0x
	Duel.Win(tp,WIN_REASON_Legendary_Six_Samurai__Tsukiko).winfilter(e,c)
	return c:GetOwner()==1-e:GetHandlerPlayer()
		and c:GetPreviousRaceOnField()&RACE__DRAGON~=0 and c:GetPreviousAttributeOnField()&ATTRIBUTE_Dark=0 
end
function c18531867.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return c:GetSummonType()==SUMMON_TYPE_ADVANCE+1 and c18531867.winfilter(e,tc)
end
function c18531867.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON__Legendary_Six_Samurai_Tsukiko=0x3d
	Duel.Win(tp,WIN_REASON_Legendary_Six_Samurai_Tsukiko)
