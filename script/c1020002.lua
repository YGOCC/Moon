--Glaactic Codeman: Zero
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--SPSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(scard.condition)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.operation)
	e1:SetCountLimit(1,s_id)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function scard.condition(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep or eg:GetCount()~=1 or eg:GetFirst():GetSummonPlayer()==tp then return false end
	if Duel.GetMatchingGroupCount(scard.filter,tp,LOCATION_MZONE,0,nil)>0
	and Duel.GetMatchingGroupCount(scard.filter2,tp,LOCATION_DECK,0,nil,e,tp)>0 then
		local c=eg:GetFirst()
		local g=Duel.GetMatchingGroup(scard.filter,tp,LOCATION_MZONE,0,nil)
		local tg=g:GetMinGroup(Card.GetAttack)
		return c:GetBaseAttack()>tg:GetFirst():GetAttack()
	end
end
function scard.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xded)
end
function scard.filter1(c)
	return c:IsFaceup()
end
function scard.filter2(c,e,tp)
	return c:IsSetCard(0x1ded) and c:GetLevel()==7
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(s_id)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	e:SetLabel(tc:GetAttack())
	local g=Duel.GetMatchingGroup(scard.filter1,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=tg:Select(tp,1,1,nil)
		local dc=sg:GetFirst()
		Duel.SetTargetCard(dc)
	else Duel.SetTargetCard(tg)
	end
	Duel.SetTargetCard(eg)
	Duel.SetChainLimit(scard.chlimit)
end
function scard.chlimit(e,ep,tp)
	return tp==ep
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local c=e:GetHandler()
	if g:GetCount()==2 then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local tc=Duel.SelectMatchingCard(tp,scard.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(tc:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	end
end
