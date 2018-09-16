--Forest Daiyoukai
--Scripted by Kedy
--Concept by XStutzX
--Edited 16.9.18 v1.1
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xf05a),1,1)
	--SP Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(function (e) return e:GetHandler():GetFlagEffect(id)>0 end)
	e1:SetTarget(cod.splimit)
	c:RegisterEffect(e1)
	--Shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cod.rttg)
	e2:SetOperation(cod.rtop)
	c:RegisterEffect(e2)
	--GY H+SP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function (e) return e:GetHandler():GetTurnID()==Duel.GetTurnCount() end)
	e3:SetTarget(cod.grtg)
	e3:SetOperation(cod.grop)
	c:RegisterEffect(e3)
	if not cod.global_check then
		cod.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(cod.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end

--Summon Reg
function cod.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetOriginalCode()==id then
			tc:RegisterFlagEffect(id,RESET_EVENT+0x1ec0000,0,1)
		end
		tc=eg:GetNext()
	end
end

--SPLimit
function cod.splimit(e,c)
	return not c:IsSetCard(0xf05b) and c:IsLocation(LOCATION_EXTRA)
end

--Shuffle into the Extra
function cod.rfilter(c)
	return c:IsSetCard(0xf05b) and c:IsAbleToExtra()
end
function cod.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() 
		and Duel.IsExistingMatchingCard(cod.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_GRAVE)
end
function cod.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cod.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g<=0 then return end
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

--GY Antics
function cod.cfilter(c,e,tp)
	return c:IsReason(REASON_LINK) and c:GetReasonCard()==e:GetHandler() and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cod.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)>0
		and Duel.IsExistingTarget(cod.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cod.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetFirst():IsAbleToHand() then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
	if g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function cod.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local b1=tc:IsAbleToHand()
	local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	if op==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	elseif op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else end
end