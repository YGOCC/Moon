--Root's Vellum
--Keddy was here~
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Fusion Summon
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,52894703,cod.ffilter,1,true,false)
	--Send (TP)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(cod.tgcon)
	e1:SetTarget(cod.tgtg)
	e1:SetOperation(cod.tgop)
	c:RegisterEffect(e1)
	--Send (OP)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetTarget(cod.tgtg)
	e3:SetOperation(cod.tgop)
	c:RegisterEffect(e3)
	--Move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cod.mvcon)
	e2:SetTarget(cod.mvtg)
	e2:SetOperation(cod.mvop)
	c:RegisterEffect(e2)
	--BGM Music
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(cod.bgmop)
    c:RegisterEffect(e4)
	if not cod.global_effect then
		cod.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(cod.opcon)
		ge1:SetOperation(cod.opop)
		Duel.RegisterEffect(ge1,0)
	end
end

--Fusion Filter
function cod.ffilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end

--To Grave
function cod.filter(c,e)
	if not c:IsAbleToGrave() then return false end
	if c:GetColumnGroup():IsContains(e:GetHandler()) then
		return true
	elseif e:GetHandler():GetSequence()<5 then
		return c:GetSequence()<5
	else
		return c:GetSequence()>=5
	end
end
function cod.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==tp
end
function cod.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),e) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end
--Row Filter Extra
function cod.rafilter(c,e)
	return c:IsAbleToGrave() and c:GetSequence()>=5
end
--Row Filter Main
function cod.rlfilter(c,e)
	return c:IsAbleToGrave() and c:GetSequence()<5
end

--Column Filter
function cod.cfilter(c,e)
	return c:GetColumnGroup():IsContains(e:GetHandler())
end
function cod.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.IsExistingMatchingCard(aux.AND(Card.IsAbleToGrave,aux.FilterBoolFunction(cod.cfilter,e)),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local b2=(c:GetSequence()<5 and Duel.IsExistingMatchingCard(cod.rlfilter,tp,LOCATION_MZONE,0,1,c))
				or (c:GetSequence()>=5 and Duel.IsExistingMatchingCard(cod.rafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c))
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(c:GetOwner(),aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(c:GetOwner(),aux.Stringid(id,2))
	else
		op=Duel.SelectOption(c:GetOwner(),aux.Stringid(id,3))+1
	end
	if op==0 then
		--Column
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		local cg=g:Filter(cod.cfilter,nil,e)
		if #cg>0 then
			Duel.SendtoGrave(cg,REASON_EFFECT)
		end
	else
		--Row
		local g=nil
		if c:GetSequence()<5 then
			--MMZ
			g=Duel.GetMatchingGroup(cod.rlfilter,tp,LOCATION_MZONE,0,c)
		else
			--EMZ
			g=Duel.GetMatchingGroup(cod.rafilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		end
		if g and #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

--Adjust for OP
function cod.opcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner() and c:IsLocation(LOCATION_MZONE) and c:GetFlagEffect(id)==1
end
function cod.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local con=cod.tgtg(e,tp,eg,ep,ev,re,r,rp,0)
	if not con then return end
	local res,feg=Duel.CheckEvent(EVENT_FLIP_SUMMON_SUCCESS,true)
	if not res or #feg<=0 then
		res,feg=Duel.CheckEvent(EVENT_FLIP,true)
		if not res or #feg<=0 then return end
	end
	if res and feg:GetFirst()==c and Duel.SelectYesNo(c:GetOwner(),aux.Stringid(id,1)) then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,e,0,tp,tp,0)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

--Move
function cod.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function cod.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function cod.mvop(e,tp,eg,ep,ev,er,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0),2)
	if seq>=16 then Duel.GetControl(c,1-tp) seq=seq-16 end
	Duel.MoveSequence(c,seq)
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE,0,POS_FACEDOWN_DEFENSE,0)
end

--BGM Music
function cod.bgmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(11,0,aux.Stringid(id,5))
end