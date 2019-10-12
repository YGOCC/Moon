--Shiro Mujou
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	c:SetSPSummonOnce(id)
	--fusion material
	c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,cid.ffilter,cid.ffilter,false)
    aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--SpSummon Count Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cid.limitcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Tag Out
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(cid.spcost)
	e4:SetTarget(cid.sptg)
	e4:SetOperation(cid.spop)
	c:RegisterEffect(e4)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cid.limitcon(e,tp)
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetLevel,nil)>=2
end
function cid.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cid.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x219) and c:IsType(TYPE_SPELL+TYPE_NORMAL) and (not sg or not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function cid.filter1(c,e,tp)
    local stats={}
    table.insert(stats,Duel.ReadCard(c,CARDDATA_SETCODE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_TYPE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_ATTACK))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_DEFENSE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_LEVEL))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_RACE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_ATTRIBUTE))
    return c:IsSetCard(0x219) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),table.unpack(stats))
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.filter1,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,cid.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if g:GetCount()<=ft then
		for c in aux.Next(g) do
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL)
		end
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		for c in aux.Next(sg) do
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL)
		end
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end