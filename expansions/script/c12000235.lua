--Tera Draco the Game Dragon
function c12000235.initial_effect(c)
	--spsummon token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(12000235,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12000235)
	e1:SetTarget(c12000235.toktg)
	e1:SetOperation(c12000235.tokop)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000235,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12001235)
	e2:SetTarget(c12000235.lvtg)
	e2:SetOperation(c12000235.lvop)
	c:RegisterEffect(e2)
	--Special Summon from Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000235,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12002235)
	e3:SetCondition(c12000235.spcon1)
	e3:SetCost(c12000235.spcost)
	e3:SetTarget(c12000235.sptg)
	e3:SetOperation(c12000235.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(c12000235.spcon2)
	c:RegisterEffect(e4)
end
function c12000235.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000247,0x856,0x4011,0,0,1,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12000235.tokop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,12000247,0x856,0x4011,0,0,1,RACE_ROCK,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,12000247)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12000235.lvfilter(c)
	return c:IsFaceup() and c:IsCode(12000247) and c:GetLevel()>0
end
function c12000235.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000235.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c12000235.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12000235.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c12000235.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x856)
		and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000235.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x856)
		and re:GetHandler():IsType(TYPE_LINK) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000235.spfilter1(c,e,tp,g,sg,rec,recmax,total_lv)
	if not rec then return false end
	total_lv=total_lv+c:GetLevel()
	if rec<recmax then
		if not sg:IsContains(c) then
			sg:AddCard(c)
			if c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and g:IsExists(c12000235.spfilter1,1,c,e,tp,g,sg,rec+1,recmax,total_lv) then
				return true
			else
				sg:Clear()
				return false
			end
		end
	else
		if sg:IsContains(c) then return false end
		if c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and sg:GetCount()+1==g:GetCount() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-(sg:GetCount()+1) and Duel.IsExistingMatchingCard(c12000235.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,total_lv) then
			sg:Clear()
			return true
		else
			sg:Clear()
			return false
		end
	end
	return false
end
function c12000235.no_rec_filter(c)
	return c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c12000235.spfilter2(c,e,tp,dlv)
	return c:IsSetCard(0x856) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(dlv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000235.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c12000235.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,12000247)
	local sg=Group.CreateGroup()
	local total_lv=0
	local exg=g:Filter(c12000235.no_rec_filter,nil)
	local fg=g:Filter(c12000235.spfilter1,nil,e,tp,exg,sg,1,exg:GetCount(),total_lv)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return fg:GetCount()>0 
	end
	Duel.Release(exg,REASON_COST)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		total_lv=total_lv+tc:GetPreviousLevelOnField()
	end
	e:SetLabel(total_lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12000235.spop(e,tp,eg,ep,ev,re,r,rp)
	local dlv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12000235.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,dlv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
