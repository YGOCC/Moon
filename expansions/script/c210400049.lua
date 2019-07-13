--created & coded by Lyris
--リダンダンシ－情景国サイト
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetTarget(cid.sptg)
	e4:SetOperation(cid.spop)
	c:RegisterEffect(e4)
	if not cid.global_check then
		cid.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(cid.regcon)
		ge1:SetOperation(cid.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cid.filter(c)
	return c:IsSetCard(0xeeb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cid.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:GetSummonType()~=SUMMON_TYPE_SPECIAL+0x40
end
function cid.regcon(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(cid.cfilter,1,nil,0) then
		sf=sf+1
	end
	if eg:IsExists(cid.cfilter,1,nil,1) then
		sf=sf+2
	end
	e:SetLabel(sf)
	return sf~=0
end
function cid.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,e,r,rp,ep,e:GetLabel())
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cid.spfilter(c,tp)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_REDUNDANCY_TOKEN,0xeeb,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if bit.extract(ev,tp)~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 then
		local tg=eg:Filter(cid.spfilter,nil,1-tp)
		if eg:GetCount()>1 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) tg=eg:Select(tp,1,1,nil) end
		local tc=tg:GetFirst()
		if not tc then return end
		local token=Duel.CreateToken(tp,CARD_REDUNDANCY_TOKEN)
		Duel.SpecialSummonStep(token,0x40,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetDefense())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(tc:GetLevel())
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(tc:GetRace())
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(tc:GetAttribute())
		token:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UNRELEASABLE_SUM)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		e6:SetValue(1)
		token:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e7:SetValue(1)
		token:RegisterEffect(e7)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e8)
		local ea=e7:Clone()
		ea:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(ea)
	end
	if bit.extract(ev,1-tp)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp)>0 then
		local tg=eg:Filter(cid.spfilter,nil,1-tp)
		if eg:GetCount()>1 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) tg=eg:Select(tp,1,1,nil) end
		local tc=tg:GetFirst()
		if not tc then return end
		local token=Duel.CreateToken(1-tp,CARD_REDUNDANCY_TOKEN)
		Duel.SpecialSummonStep(token,0x40,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetDefense())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(tc:GetLevel())
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(tc:GetRace())
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(tc:GetAttribute())
		token:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UNRELEASABLE_SUM)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		e6:SetValue(1)
		token:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e7:SetValue(1)
		token:RegisterEffect(e7)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e8)
		local ea=e7:Clone()
		ea:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(ea)
	end
	Duel.SpecialSummonComplete()
end
