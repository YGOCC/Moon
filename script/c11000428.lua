--Naga War Queen
function c11000428.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c11000428.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x204),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11000428.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11000428.spcon)
	e2:SetOperation(c11000428.spop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11000428,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c11000428.tktg)
	e3:SetOperation(c11000428.tkop)
	c:RegisterEffect(e3)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11000428,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11000428)
	e3:SetTarget(c11000428.target)
	e3:SetOperation(c11000428.operation)
	c:RegisterEffect(e3)
end
function c11000428.ffilter(c)
	return c:IsSetCard(0x204)
end
function c11000428.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c11000428.spfilter1(c,tp,fc)
	return c:IsSetCard(0x204) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c11000428.spfilter2,1,c,fc)
end
function c11000428.spfilter2(c,fc)
	return c:IsSetCard(0x204) and c:IsCanBeFusionMaterial(fc)
end
function c11000428.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c11000428.spfilter1,1,nil,tp,c)
end
function c11000428.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c11000428.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c11000428.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c11000428.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11000405,0,0x4011,500,500,2,RACE_SEASERPENT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11000428.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11000405,0,0x4011,500,500,2,RACE_SEASERPENT,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,11000405)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c11000428.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD) and c:IsReleasableByEffect()
end
function c11000428.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.CheckReleaseGroupEx(tp,c11000428.filter,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11000428.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.SelectReleaseGroupEx(tp,c11000428.filter,1,ct,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Draw(tp,rct,REASON_EFFECT)
	end
end