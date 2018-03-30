--Cyber Soldato d'Assalto
--Script by XGlitchy30
function c37200266.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37200266)
	e1:SetCondition(c37200266.spcon)
	e1:SetOperation(c37200266.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--level change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c37200266.lvcon)
	e2:SetOperation(c37200266.lvop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--effect #1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(37200266,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c37200266.ecost)
	e5:SetTarget(c37200266.etarget)
	e5:SetOperation(c37200266.eoperation)
	c:RegisterEffect(e5)
	--effect #2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(37200266,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c37200266.ecost)
	e6:SetTarget(c37200266.etg)
	e6:SetOperation(c37200266.eop)
	c:RegisterEffect(e6)
end
--filters
function c37200266.cfilter(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())) and c:IsLevelBelow(4) and c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c37200266.fcheck(c)
	return c:IsFacedown() or not c:IsRace(RACE_MACHINE)
end
function c37200266.lvfilter(c,lv)
	return c:IsFaceup() and c:GetLevel()==lv
end
function c37200266.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_XYZ) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--special summon
function c37200266.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c37200266.cfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,1,c)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c37200266.fcheck,tp,LOCATION_MZONE,0,1,nil)
end
function c37200266.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c37200266.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c37200266.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c37200266.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(37200266,3)) then return end
	local c=e:GetHandler()
	local lv=e:GetLabelObject():GetLabel()
	--
	local ct={}
	for i=lv,1,-1 do
		table.insert(ct,i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37200266,2))
	local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ac)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
--effect
function c37200266.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c37200266.etarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:GetLocation()==LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c37200266.eoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
--effect #2
function c37200266.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	if chkc then return chkc:IsControler(1-tp) and chkc:GetLocation()==LOCATION_MZONE and c37200266.lvfilter(chkc,lv) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c37200266.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) 
		and Duel.IsExistingTarget(c37200266.lvfilter,tp,0,LOCATION_MZONE,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c37200266.lvfilter,tp,0,LOCATION_MZONE,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c37200266.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lv=c:GetLevel()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.GetLocationCountFromEx(tp)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c37200266.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				Duel.Overlay(Duel.GetOperatedGroup():GetFirst(),Group.FromCards(c,tc))
			end
		end
	end
end