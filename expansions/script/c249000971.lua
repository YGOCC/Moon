--SKILL: Wings of Revoution
--Script by Somen00b
local function getID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
    --ED Skill Properties
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetCondition(cid.skillcon)
    e1:SetValue(cid.efilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetValue(0)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_USE_AS_COST)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Wings of Revolution
    local SKILL=Effect.CreateEffect(c)
    SKILL:SetType(EFFECT_TYPE_FIELD)
    SKILL:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE)
    SKILL:SetRange(LOCATION_EXTRA)
    SKILL:SetCode(EFFECT_SPSUMMON_PROC_G)
    SKILL:SetCondition(cid.skillcon_skill)
    SKILL:SetOperation(cid.skillop)
    SKILL:SetValue(SUMMON_TYPE_SPECIAL+1)
    c:RegisterEffect(SKILL)
    --immune to necro valley
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NECRO_VALLEY_IM)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,cid.counterfilter)
end
--filters
function cid.skillcon(e)
    return e:GetHandler():IsFaceup() and e:GetHandler():GetFlagEffect(99988871)>0
end
function cid.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function cid.counterfilter(c)
	return c:IsSetCard(0xba)
end
function cid.filter1(c,e,tp)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(cid.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2)
end
function cid.filter2(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cid.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cid.filter3(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0xba) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cid.filter4(c,e,tp)
	return c:IsSetCard(0xba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.filter5(c)
	return c:IsFaceup() and c:IsSetCard(0xba)
end
function cid.skillcon_skill(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return cid.skillcon(e) and Duel.GetFlagEffect(tp,id)<=0 and (Duel.IsExistingMatchingCard(cid.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	or Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) or (Duel.IsExistingMatchingCard(cid.filter4,tp,LOCATION_DECK,0,1,nil,e,tp)
	and Duel.GetMatchingGroupCount(cid.filter5,tp,LOCATION_MZONE,0,nil)<2 and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0))
end
function cid.skillop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_CARD,1-tp,id)
	local option
	if Duel.IsExistingMatchingCard(cid.filter4,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMatchingGroupCount(cid.filter5,tp,LOCATION_MZONE,0,nil)<2 then option=0 end
	if (Duel.IsExistingMatchingCard(cid.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp)) then option=1 end
	if (Duel.IsExistingMatchingCard(cid.filter4,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMatchingGroupCount(cid.filter5,tp,LOCATION_MZONE,0,nil)<2)
	and (Duel.IsExistingMatchingCard(cid.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp)) then
		option=Duel.SelectOption(tp,1000,1006)
	end
	if option==0 then
		local g=Duel.SelectMatchingCard(tp,cid.filter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cid.splimit1)
			Duel.RegisterEffect(e1,tp)
		end
	else
		local g=Group.CreateGroup()
		local g1=Duel.GetMatchingGroup(cid.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		local g2=Duel.GetMatchingGroup(cid.filter2,tp,LOCATION_MZONE,0,nil,e,tp)
		g:Merge(g1)
		g:Merge(g2)
		g:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		g=Duel.SelectMatchingCard(tp,cid.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
		local sc=g:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			local og=Group.FromCards(tc)
			Duel.Overlay(sc,og)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cid.splimit2)
			Duel.RegisterEffect(e1,tp)
		end
	end
    Duel.RegisterFlagEffect(tp,id,0,0,1)
    return
end
function cid.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and (not c:IsSetCard(0xba))
end
function cid.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xba)
end