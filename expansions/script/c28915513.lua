--Infernoid Demiurge
--Design and code by Kindrindra
local ref=_G['c'..28915513]
function ref.initial_effect(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetRange(0xff)
	ge1:SetCountLimit(1,555+EFFECT_COUNT_CODE_DUEL)
	ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge1:SetOperation(ref.chk)
	c:RegisterEffect(ge1,tp)

	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(ref.fscon)
	e1:SetOperation(ref.fsop)
	--Level Down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(ref.lvcon)
	e2:SetOperation(ref.lvop)
	c:RegisterEffect(e2)
	--Field Wipe
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(ref.tgcon)
	e3:SetTarget(ref.tgtg)
	e3:SetOperation(ref.tgop)
	c:RegisterEffect(e3)
	--Create Banish
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(ref.regcost)
	e4:SetOperation(ref.regop)
	c:RegisterEffect(e4)
end
ref.burst=true
function ref.trapmaterial(c)
	return true
end
function ref.monmaterial(c)
	return true
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,555,nil,nil,nil,nil,nil,nil)		
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
end

--Level Down
function ref.voidmatfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0xc5)
end
function ref.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and c:GetMaterial():GetCount()>=3)
		or (bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL+0x555)==SUMMON_TYPE_SPECIAL+0x555 and c:GetMaterial():IsExists(ref.voidmatfilter,1,nil))
end
function ref.lvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(28915513,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end

--Field Wipe
function ref.GetLevelCount(tp)
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() and tc:IsType(TYPE_EFFECT) then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
	return sum
end
function ref.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function ref.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ref.GetLevelCount(tp) < ref.GetLevelCount(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,0,LOCATION_MZONE)
end
function ref.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	while (ref.GetLevelCount(tp) < ref.GetLevelCount(1-tp)) do
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end

--Create Banish
function ref.regcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_FIRE)
	Duel.Release(g,REASON_COST)
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(ref.rmtg)
	Duel.RegisterEffect(e1,tp)
end
function ref.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsType(TYPE_MONSTER)
end

--Fusion Material
function ref.ffilter(c,fc)
	return (c:IsFusionSetCard(0xbb) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function ref.filterchk1(c,mg,g2,ct,chkf)
	local tg
	if g2==nil or g2:GetCount()==0 then tg=Group.CreateGroup() else tg=g2:Clone() end
	local g=mg:Clone()
	tg:AddCard(c)
	g:RemoveCard(c)
	local ctc=ct+1
	if ctc==3 then
		return ref.filterchk2(tg,chkf)
	else
		return g:IsExists(ref.filterchk1,1,nil,g,tg,ctc,chkf)
	end
end
function ref.filterchk2(g,chkf)
	if g:IsExists(aux.TuneMagFusFilter,1,nil,g,chkf) then return false end
	local fs=false
	if g:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return g:IsExists(ref.namechk,1,nil,g) and (fs or chkf==PLAYER_NONE)
end
function ref.namechk(c,g,code1,code2)
	if not c:IsHasEffect(511002961) then
		if code1~=nil and c:IsCode(code1) then return false end
		if code2~=nil and c:IsCode(code2) then return false end
		if code1==nil then code1=c:GetCode() elseif code2==nil then code2=c:GetCode() end
	end
	local mg=g:Clone()
	mg:RemoveCard(c)
	return mg:IsExists(ref.namechk,1,nil,mg,code1,code2) or mg:GetCount()==0
end
function ref.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(ref.ffilter,nil,e:GetHandler())
	if gc then
		return ref.filterchk1(gc,mg,nil,0,chkf)
	end
	return mg:IsExists(ref.filterchk1,1,nil,mg,nil,0,chkf)
end
function ref.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(ref.ffilter,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		local matg=Group.FromCards(gc)
		for i=1,2 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(p,ref.filterchk1,1,1,nil,g,matg,i,chkf)
			g:Sub(g1)
			matg:Merge(g1)
		end
		if sfhchk then Duel.ShuffleHand(tp) end
		matg:RemoveCard(gc)
		Duel.SetFusionMaterial(matg)
		return
	end
	local matg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=g:FilterSelect(p,ref.filterchk1,1,1,nil,g,matg,i-1,chkf)
		g:Sub(g1)
		matg:Merge(g1)
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(matg)
end
