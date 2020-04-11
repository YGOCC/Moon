--Moon's Dream, Wish Maker
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.battlephase)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	--c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetRange(LOCATION_GRAVE)
--	c:RegisterEffect(e1x)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return eg:IsExists(cid.cfilter,1,nil,tp) end)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2x)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32617464,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1000)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.drtg)
	e3:SetOperation(cid.drop)
--	c:RegisterEffect(e3)
	--Fragment creation
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1000)
	e4:SetCost(cid.selflock)
	e4:SetOperation(cid.fragment)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_HAND)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,cid.counterfilter)
end
--Filters
function cid.counterfilter(c)
	return c:IsSetCard(0x666) or (c:GetSummonLocation()~=LOCATION_EXTRA)
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x666)
end
function cid.mfilter0(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
end
function cid.fragmentfilter(c)
	return c:IsCode(104242585)
end
function cid.mfilter2(c,e)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cid.spfilter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x666) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function cid.cfilter(c,tp)
	return (c:IsPreviousPosition(POS_FACEUP) or c:GetPreviousControler()==tp) and c:IsSetCard(0x666)
end
function cid.moondream(c)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
--fragment
function cid.selflock(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local ex=Effect.CreateEffect(e:GetHandler())
	ex:SetType(EFFECT_TYPE_FIELD)
	ex:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	ex:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ex:SetReset(RESET_PHASE+PHASE_END)
	ex:SetTargetRange(1,0)
	ex:SetLabelObject(e)
	ex:SetTarget(cid.splimit)
	Duel.RegisterEffect(ex,tp)
end
function cid.fragment(e,tp,eg,ep,ev,re,r,rp,chk)	
	--	local sc=Duel.CreateToken(tp,104242585)
	--	sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
	--	Duel.SendtoExtraP(sc,tp,REASON_RULE)
	if not e:GetHandler():IsRelateToEffect(e) or ((e:GetHandler():IsOnField() and e:GetHandler():IsFacedown()) and not e:GetHandler():IsLocation(LOCATION_HAND)) then return end
	    local c=e:GetHandler()
	    Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end
--selfsummon
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
end
end
--Draw
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44335251,2))
		local a=Duel.IsExistingMatchingCard(cid.fragmentfilter,tp,LOCATION_REMOVED,0,1,nil)
		local b=Duel.IsExistingMatchingCard(cid.moondream,tp,LOCATION_GRAVE,0,3,nil)
if chk==0 then return a or b end
if a and b then
	op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
elseif a then
	op=0
elseif b then
	op=1
end
if op==0 then
	local tc=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_COST)
	end
end
if op==1 then
	local g=Duel.SelectMatchingCard(tp,cid.moondream,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
--Fuse
function cid.battlephase(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)) and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(cid.fragment,tp,LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(cid.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(cid.mfilter0,tp,LOCATION_REMOVED,0,nil)
		mg2:Merge(mg1)
		res=Duel.IsExistingMatchingCard(cid.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cid.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg0=Duel.GetMatchingGroup(cid.fragment,tp,LOCATION_REMOVED,0,nil)
	local mg2=Duel.GetMatchingGroup(cid.mfilter2,tp,LOCATION_REMOVED,0,nil,e)
	mg2:Merge(mg0)
	local sg1=Duel.GetMatchingGroup(cid.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(cid.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,tp)
			tc:SetMaterial(mat1)
			local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			mat1:Sub(mat2)
			Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Exile(mat1,REASON_RULE)
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) and e:GetHandler():IsRelateToEffect(e) then
				Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function cid.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end