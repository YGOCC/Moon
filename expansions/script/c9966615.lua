--Alza-Rango-Magico Forza Oscurità Irregolare
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cid.xyzcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cid.xyztg)
	e2:SetOperation(cid.xyzop)
	c:RegisterEffect(e2)
end
--filters
function cid.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x4999)
		and Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cid.filter2(c,e,tp,mc,rk)
	if c:GetOriginalCode()==6165656 and mc:GetCode()~=48995978 then return false end
	return (c:IsRank(rk+1) or c:IsRank(rk+2)) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x4999)
		and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cid.checkr(c,rc)
	return c:IsReason(REASON_BATTLE) and c:IsType(TYPE_MONSTER) and c:GetReasonCard()==rc and c~=rc and not c:IsReason(REASON_REPLACE)
end
function cid.flagchk(c)
	return c:GetFlagEffect(id)>0
end
function cid.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
--Activate
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cid.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cid.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
--attach
function cid.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or phase==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
end
function cid.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cid.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cid.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetLabelObject(tc)
		e1:SetOperation(cid.redirect)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cid.redirect(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local b1=a and not a:IsType(TYPE_TOKEN) and a:IsStatus(STATUS_BATTLE_DESTROYED) and a:IsControler(1-tp) and d and d==c and d:GetFlagEffect(id)>0
	local b2=d and not d:IsType(TYPE_TOKEN) and d:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsControler(1-tp) and a==c and a:GetFlagEffect(id)>0
	if (not b1 and not b2) or not c:IsOnField() or c:IsFacedown() or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetLabelObject(c)
	e1:SetTarget(cid.reptg)
	e1:SetOperation(cid.repop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	if b1 then
		a:RegisterEffect(e1)
	else
		d:RegisterEffect(e1)
	end
end
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE)
		and c:GetReasonCard()==e:GetLabelObject() and c:GetReasonCard():GetFlagEffect(id)>0 
	end
	return true
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	local xc=e:GetLabelObject()
	if not xc:IsOnField() or xc:IsFacedown() then return end
	Duel.Hint(HINT_CARD,1-tp,id)
	Duel.Overlay(xc,Group.FromCards(e:GetHandler()))
end