--Ibaraki Doji
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:SetSPSummonOnce(id)
	--fusion material
	c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,cid.ffilter,cid.ffilter,false)
    aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(cid.atkcon)
	e3:SetOperation(cid.atkop)
	c:RegisterEffect(e3)
	--Double Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Tag Out
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(cid.spcost)
	e4:SetTarget(cid.sptg)
	e4:SetOperation(cid.spop)
	c:RegisterEffect(e4)
end
function cid.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cid.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x219) and c:IsType(TYPE_SPELL+TYPE_NORMAL) and (not sg or not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function cid.filter1(c,e,tp)
    local stats={}
    table.insert(stats,Duel.ReadCard(c,CARDDATA_SETCODE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_TYPE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_ATTACK))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_DEFENSE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_LEVEL))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_RACE))
    table.insert(stats,Duel.ReadCard(c,CARDDATA_ATTRIBUTE))
    return c:IsSetCard(0x219) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),table.unpack(stats))
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.filter1,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,cid.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if g:GetCount()<=ft then
		for c in aux.Next(g) do
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL)
		end
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		for c in aux.Next(sg) do
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL)
		end
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function cid.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetAttackTarget()
	if tc:GetLevel()>0 then
		ct=tc:GetLevel() --sets level if has level
	elseif tc:GetRank()>0 then
		ct=tc:GetRank() --sets rank if has rank
	elseif tc:GetLink()>0 then
		ct=tc:GetLink() --sets link rating if has link rating
	else ct=0 --sets 0 if it has none of those (like evolutes) just so you don't get an error if you multiply against a nil value
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end