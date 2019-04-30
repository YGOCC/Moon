--Virus Polimero
--Script by XGlitchy30
function c39759363.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,-1,nil,c39759363.penaltycon,c39759363.penalty)
	--Ability: Fusion Mutation
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCode(EFFECT_SPSUMMON_PROC_G)
	ab:SetCountLimit(1)
	ab:SetCondition(c39759363.fuscon)
	ab:SetOperation(c39759363.fustg)
	ab:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(ab)
	--Master Summon Custom Proc
	local ms=Effect.CreateEffect(c)
	ms:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ms:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	ms:SetCode(EVENT_SPSUMMON_SUCCESS)
	ms:SetRange(LOCATION_SZONE)
	ms:SetCondition(c39759363.mscon)
	ms:SetOperation(c39759363.msop)
	c:RegisterEffect(ms)
	--Monster Effects--
	--take control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c39759363.tccon)
	e1:SetTarget(c39759363.tctg)
	e1:SetOperation(c39759363.tcop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c39759363.tgcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_SINGLE)
	e2x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2x:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2x:SetRange(LOCATION_MZONE)
	e2x:SetCondition(c39759363.tgcon)
	e2x:SetValue(aux.tgoval)
	c:RegisterEffect(e2x)
end
--filters
function c39759363.notmaterial(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c39759363.fuscheck(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER)
end
function c39759363.fusmat(c,e,tp)
	local val=c:GetLevel()
	if c:IsType(TYPE_XYZ) then
		val=c:GetRank()
	elseif c:IsType(TYPE_LINK) then
		val=c:GetLink()
	else
		val=val
	end
	return c:IsFaceup() and not c:IsType(TYPE_FUSION) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c39759363.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,val)
		and ((c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c)>0) or (c:IsControler(1-tp) and Duel.GetLocationCountFromEx(tp)>0))
end
function c39759363.fusfilter(c,e,tp,val)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:GetLevel()==val
end
function c39759363.fuspenalty(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,1-tp,true,false) and Duel.GetLocationCountFromEx(1-tp)>0
end
function c39759363.fuscolumn(c)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA
		and not Duel.IsExistingMatchingCard(c39759363.columncheck,c:GetControler(),LOCATION_MZONE,0,1,c,c)
end
function c39759363.columncheck(c,cc)
	return c:GetColumnGroup():IsContains(cc)
end
function c39759363.fuscolumn2(c,i)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA and c:GetColumnGroup():IsContains(i)
end
function c39759363.tcfilter(c,e)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:GetColumnGroup():IsContains(e:GetHandler()) and c:IsType(TYPE_FUSION)
end
--Deck Master Functions
function c39759363.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(c39759363.notmaterial)
	e0:SetValue(1)
	Duel.RegisterEffect(e0,tp)
end
function c39759363.mscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c39759363.fuscolumn,1,nil)
end
function c39759363.msop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_MASTER,tp,false,false) then return end
	local check=false
	local zone=0
	for tc in aux.Next(eg) do
		local zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 then
			check=true
		end
	end
	if check then
		if Duel.SelectYesNo(tp,aux.Stringid(39759363,3)) then
			local g=eg:Filter(c39759363.fuscolumn,nil)
			local zn=0
			local flag=0
			for i in aux.Next(g) do
				zn=bit.bor(zone,i:GetColumnZone(LOCATION_MZONE,tp))
				local _,flag_tmp=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zn)
				flag=(~flag_tmp)&0x7f
			end
			local fzone=0
			if e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_MASTER,tp,false,false,POS_FACEUP,tp,zn) then
				fzone=fzone|(flag<<(tp==tp and 0 or 16))
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x00ff00ff&(~fzone))
			Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_MASTER,tp,tp,false,false,POS_FACEUP,sel_zone)
			e:GetHandler():RegisterFlagEffect(3340,RESET_EVENT+EVENT_CUSTOM+3340,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
		end
	end
end
function c39759363.penaltycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c39759363.fuspenalty,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,e,tp)
end
function c39759363.penalty(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(39759363,2)) then
		local xtr=Duel.GetFieldGroup(1-tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(1-tp,xtr)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,c39759363.fuspenalty,1-tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,1-tp,1-tp,true,false,POS_FACEUP)
		end
	end
end
		
--Ability: Fusion Mutation
function c39759363.fuscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local fd=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return fd:IsExists(c39759363.fuscheck,1,nil) and Duel.IsExistingMatchingCard(c39759363.fusmat,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
		and aux.CheckDMActivatedState(e)
end
function c39759363.fustg(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c39759363.fusmat,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp):GetFirst()
	Duel.SendtoGrave(g,REASON_COST)
	local val=g:GetLevel()
	if c:IsType(TYPE_XYZ) then val=c:GetRank()
	elseif c:IsType(TYPE_LINK) then val=c:GetLink()
	else val=val end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sp=Duel.SelectMatchingCard(tp,c39759363.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,val)
	if not sp then return end
	Duel.SpecialSummon(sp,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
--Monster Effects--
--take control
function c39759363.tccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MASTER)
end
function c39759363.tctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c39759363.tcfilter,tp,0,LOCATION_MZONE,1,nil,e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c39759363.tcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c39759363.tcfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
end
--cannot be target
function c39759363.tgcon(e)
	return Duel.IsExistingMatchingCard(c39759363.fuscheck,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end