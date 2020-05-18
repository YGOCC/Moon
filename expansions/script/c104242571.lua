--Moon's Dreamscape
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableCounterPermit(0x666)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cid.spcon)
	e2:SetTarget(cid.xtg)
	e2:SetOperation(cid.xop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(cid.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(cid.desreptg)
	e5:SetOperation(cid.desrepop)
	c:RegisterEffect(e5)
end
function cid.atkval(e,c)
	return e:GetHandler():GetCounter(0x666)*-100
end
function cid.searchfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) 
end
function cid.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousSetCard(0x666)
end
--destroy replace
function cid.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and e:GetHandler():GetCounter(0x666)>=2 end
	return true
end
function cid.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x666,2,REASON_EFFECT)
end
--send to extra and counter
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cid.cfilter,nil,tp)
	e:SetLabel(ct)
	return ct>0
end
function cid.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.searchfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cid.xop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cid.searchfilter,tp,LOCATION_DECK,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,cid.searchfilter,tp,LOCATION_DECK,0,1,1,c)
	if Card.Type then 
		local tc=g:GetFirst()
			Card.Type(tc,TYPE_PENDULUM+TYPE_MONSTER+TYPE_EFFECT) 
				Duel.RemoveCards(tc,nil,REASON_EFFECT+REASON_RULE)
					Duel.SendtoExtraP(tc,POS_FACEUP,REASON_RULE+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function() if not tc:IsLocation(LOCATION_EXTRA) then Card.Type(tc,TYPE_EFFECT+TYPE_MONSTER) Card.Race(tc,RACE_BEAST)  e1:Reset() e1:GetLabelObject():Reset() end end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	else
	local tc=g:GetFirst()
			tc:SetCardData(CARDDATA_TYPE,tc:GetType()+TYPE_PENDULUM)
				Duel.Exile(tc,REASON_EFFECT+REASON_RULE)
					Duel.SendtoExtraP(tc,POS_FACEUP,REASON_RULE+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function() if not tc:IsLocation(LOCATION_EXTRA) then tc:SetCardData(CARDDATA_TYPE,tc:GetType()-TYPE_PENDULUM) e1:Reset() e1:GetLabelObject():Reset() end end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	end
	e:GetHandler():AddCounter(0x666,1)
end	