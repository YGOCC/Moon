--Moon Burst's Spirit Mark
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
--	c:SetUniqueOnField(1,0,id)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cid.sprcon)
	e1:SetOperation(cid.sprop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(cid.playcost)
	e2:SetTarget(cid.eqtg)
	e2:SetOperation(cid.eqop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--defup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
		--add type
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetValue(TYPE_TUNER)
	c:RegisterEffect(e5)
		--Atk Gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id+1000)
	e6:SetTarget(cid.atktg)
	e6:SetOperation(cid.atkop)
	c:RegisterEffect(e6)
end
--Filters
function cid.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:GetBaseAttack()<1501
end
function cid.atkfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function cid.equipfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
function cid.fcheck(c,sg)
	return c:IsFaceup() and c:IsSetCard(0x666) and sg:IsExists(cid.fcheck2,1,c)
end
function cid.fcheck2(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.cfilter(c)
	return (c:IsFaceup() and c:IsSetCard(0x666))
		and (c:IsAbleToGraveAsCost() or c:IsAbleToDeckOrExtraAsCost())
end
--Alt Summon Method
function cid.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(cid.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(cid.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function cid.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(cid.fselect,1,nil,tp,mg,sg)
end
function cid.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,cid.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,nil,2,REASON_COST)
		c:CompleteProcedure()
end
--Grave Equip
function cid.playcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==2 end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function cid.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and cid.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cid.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)==0 then return end
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(cid.eqlimit)
		c:RegisterEffect(e2)
	end
end
function cid.eqlimit(e,c)
	return c:IsSetCard(0x666)
end
--(Quick Effect) ATK boost
function cid.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cid.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local val=Duel.GetMatchingGroupCount(cid.atkfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)*200
	if val>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
	end
end