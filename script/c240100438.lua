--created & coded by Lyris
--サイバー・ドラゴン・ファーヤー
function c240100438.initial_effect(c)
	function aux.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op,mustbemat)
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.xyz=true
		if not maxct then maxct=ct end
		mt.xyz_filter=function(mc,ignoretoken) return mc and (not f or f(mc)) and mc:IsXyzLevel(c,lv) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
		mt.minxyzct=ct
		mt.maxxyzct=maxct
		mt.matlvl=lv
		mt.matchk=mustbemat
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(1073)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct,mustbemat))
		e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct,mustbemat))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct,mustbemat))
		e1:SetValue(SUMMON_TYPE_XYZ)
		c:RegisterEffect(e1)
		if alterf then
			mt.alterf=alterf
			mt.altdsc=desc
			mt.altrop=op
			local e2=e1:Clone()
			e2:SetDescription(desc)
			e2:SetCondition(Auxiliary.XyzCondition2(alterf,op))
			e2:SetTarget(Auxiliary.XyzTarget2(alterf,op))
			e2:SetOperation(Auxiliary.XyzOperation2(alterf,op))
			c:RegisterEffect(e2)
		end
		if not xyztemp then
			xyztemp=true
			xyztempg0=Group.CreateGroup()
			xyztempg0:KeepAlive()
			xyztempg1=Group.CreateGroup()
			xyztempg1:KeepAlive()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
			e3:SetCode(EVENT_ADJUST)
			e3:SetCountLimit(1)
			e3:SetOperation(Auxiliary.XyzMatGenerate)
			Duel.RegisterEffect(e3,0)
		end
	end
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,70095154,2,false,false)
	c:SetSPSummonOnce(240100438)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c240100438.xcon)
	e3:SetTarget(c240100438.xtarg)
	e3:SetOperation(c240100438.xop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return e:GetHandler():IsSSetable(true) end end)
	e4:SetOperation(c240100438.setop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(c240100438.condition)
	e5:SetOperation(c240100438.operation)
	c:RegisterEffect(e5)
	if not c240100438.global_check then
		c240100438.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(326)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c240100438.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c240100438.pandemonium=true
function c240100438.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c240100438.xcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c240100438.xfilter(c,e)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and mt.xyz and c:IsXyzSummonable(nil) and e:GetHandler():IsCanBeXyzMaterial(c)
end
function c240100438.xtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100438.xfilter,tp,LOCATION_EXTRA,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c240100438.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c240100438.xfilter,tp,LOCATION_EXTRA,0,nil,e)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local xg=nil
		if tp==0 then
			xg=xyztempg0
		else
			xg=xyztempg1
		end
		local matg=Duel.GetMatchingGroup(aux.XyzM12,tp,LOCATION_MZONE,LOCATION_MZONE,nil,sc.xyz_filter,sc.matlvl,sc,xg,sc.matchk,tp)
		local mg2=Duel.GetMatchingGroup(aux.XyzSubMatFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,sc.xyz_filter,sc.matlvl,sc,xg,sc.matchk)
		mg:Merge(mg2)
		local ct=0
		local minc=sc.minxyzct
		local maxc=sc.maxxyzct
		local matg=Group.CreateGroup()
		repeat
			while ct<minc or matg:IsExists(aux.XyzMatNumCheck,1,nil,matg:GetCount()) do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local g=mg:FilterSelect(tp,aux.XyzFilterChk,1,1,nil,mg,sc,tp,minc,maxc,matg,ct,false,false,sg,nil,nil,sc.matchk)
				local tc=g:GetFirst()
				local isDouble=false
				if not sc.matchk and tc:IsHasEffect(511001225) and (not tc.xyzlimit2 or tc.xyzlimit2(sc)) and ct+1<minc 
					and (not aux.XyzFilterChk(tc,mg,sc,tp,minc,maxc,matg,ct,true,true,sg,nil,nil,sc.matchk) or Duel.SelectYesNo(tp,65)) then
					isDouble=true
				end
				if not sc.matchk and tc:IsHasEffect(511003001) and (not tc.xyzlimit3 or tc.xyzlimit3(sc)) and ct+2<minc then
					if (isDouble and not aux.XyzFilterChk(tc,mg,sc,tp,minc,maxc,matg,ct,false,true,sg,nil,nil,sc.matchk)) 
						or (not isDouble and not aux.XyzFilterChk(tc,mg,sc,tp,minc,maxc,matg,ct,true,true,sg,nil,nil,sc.matchk)) 
						or Duel.SelectYesNo(tp,65) then
						local tct=2
						if isDouble then tct=1 end
						ct=ct+tct
					end
				end
				if isDouble then ct=ct+1 end
				if not sc.matchk then
					local eqg=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,511001175)
					mg:Merge(eqg)
				end
				mg:RemoveCard(tc)
				matg:AddCard(tc)
				ct=ct+1
			end
		until matg:IsContains(c)
		Duel.XyzSummon(tp,sg:GetFirst(),matg)
	end
end
function c240100438.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c240100438.cfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsRace(RACE_MACHINE) and bit.band(c:GetReason(),REASON_BATTLE+REASON_EFFECT)~=0
end
function c240100438.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c240100438.cfilter,1,nil)
end
function c240100438.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c240100438.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c240100438.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
