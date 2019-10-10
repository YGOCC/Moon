--Skyburner Havoc
--Commissioned by: Leon Duvall
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--pop backrow
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.drycon)
	e1:SetCost(cid.drycost)
	e1:SetTarget(cid.drytg)
	e1:SetOperation(cid.dryop)
	c:RegisterEffect(e1)
	--sequence
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cid.movecon)
	e2:SetTarget(cid.movetg)
	e2:SetOperation(cid.moveop)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2x)
	local e2y=e2:Clone()
	e2y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2y)
end
--POP MONSTERS
function cid.drycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cid.drycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cid.drytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_MZONE,1,2,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cid.dryop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
--SEQUENCE
--filters
function cid.excolumn(c,e,tp,mode)
	if c:GetSequence()==e:GetHandler():GetSequence() then
		return false
	end
	if not mode then
		return c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)>0
			and Duel.CheckLocation(1-tp,LOCATION_MZONE,e:GetHandler():GetSequence())
	else
		return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_PENDULUM+TYPE_FIELD)
			and ((c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,e:GetHandler():GetSequence()))
			or (c:IsLocation(LOCATION_SZONE) and Duel.GetLocationCount(1-tp,LOCATION_SZONE,1-tp,LOCATION_REASON_CONTROL)>0) and Duel.CheckLocation(1-tp,LOCATION_SZONE,e:GetHandler():GetSequence()))
	end
end
---------
function cid.movecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cid.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then 
		return Duel.IsExistingTarget(cid.excolumn,tp,0,LOCATION_MZONE,1,nil,e,tp,nil) or Duel.IsExistingTarget(cid.excolumn,tp,0,LOCATION_ONFIELD,1,nil,e,tp,true)
	end
	local g1=Duel.GetMatchingGroup(cid.excolumn,tp,0,LOCATION_MZONE,nil,e,tp,nil)
	local g2=Duel.GetMatchingGroup(cid.excolumn,tp,0,LOCATION_ONFIELD,nil,e,tp,true)
	g1:Merge(g2)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local sg=g1:Select(tp,1,1,nil)
		if #sg>0 then
			if sg:GetFirst():IsType(TYPE_MONSTER) and g1:IsExists(cid.excolumn,1,sg:GetFirst(),e,tp,true) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				local sg2=g1:FilterSelect(tp,cid.excolumn,1,1,sg:GetFirst(),e,tp,true)
				sg2:GetFirst():RegisterFlagEffect(id,RESET_CHAIN,0,1)
				sg:Merge(sg2)
			else
				if sg:GetFirst():IsType(TYPE_SPELL+TYPE_TRAP) and g1:IsExists(cid.excolumn,1,sg:GetFirst(),e,tp,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					sg:GetFirst():RegisterFlagEffect(id,RESET_CHAIN,0,1)
					local sg2=g1:FilterSelect(tp,cid.excolumn,1,1,sg:GetFirst(),e,tp,nil)
					sg:Merge(sg2)
				end
			end
		end
		if #sg>0 then
			Duel.SetTargetCard(sg)
		end
	end
end
function cid.moveop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(1-tp,LOCATION_MZONE,e:GetHandler():GetSequence()) and not Duel.CheckLocation(1-tp,LOCATION_MZONE,e:GetHandler():GetSequence()) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(id)<=0 then
			if Duel.CheckLocation(1-tp,LOCATION_MZONE,e:GetHandler():GetSequence()) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				Duel.MoveSequence(tc,4-e:GetHandler():GetSequence())
			end
		else
			if tc:IsLocation(LOCATION_MZONE) and Duel.CheckLocation(1-tp,LOCATION_MZONE,e:GetHandler():GetSequence()) then
				Duel.MoveSequence(tc,4-e:GetHandler():GetSequence())
			elseif tc:IsLocation(LOCATION_SZONE) and Duel.CheckLocation(1-tp,LOCATION_SZONE,e:GetHandler():GetSequence()) then
				Duel.MoveSequence(tc,4-e:GetHandler():GetSequence())
			end
		end
		tc=g:GetNext()
	end
end
