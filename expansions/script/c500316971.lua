--Buttercup of Fiber VINE 
function c500316971.initial_effect(c)
	  aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
  aux.AddEvoluteProc(c,nil,7,c500316971.filter1,c500316971.filter2,1,1)
		--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500316971,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	--e2:SetCountLimit(1,500316971)
	e2:SetCondition(c500316971.thcon)
	e2:SetTarget(c500316971.thtg)
	e2:SetOperation(c500316971.thop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--spsummon count limit


	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c500316971.con)
	e4:SetTarget(c500316971.sumlimit)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)

   local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(500316971)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c500316971.con)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	if c500316971.global_check==nil then
		c500316971.global_check=true
		c500316971[0]=1
		c500316971[1]=1
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c500316971.resetop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c500316971.checkop)
		Duel.RegisterEffect(ge2,0)
	end
end

function c500316971.filter1(c,ec,tp)
	return c:IsType(TYPE_RITUAL)
end
function c500316971.filter2(c,ec,tp)
	return c:IsRace(RACE_PLANT) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c500316971.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_EVOLUTE) and c500316971[sump]<=0
end
function c500316971.con(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetCounter(0x88)==7
end
function c500316971.resetop(e,tp,eg,ep,ev,re,r,rp)
	c500316971[0]=1
	c500316971[1]=1
end
function c500316971.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_EXTRA) then
			local p=tc:GetSummonPlayer()
			c500316971[p]=c500316971[p]-1
		end
		tc=eg:GetNext()
	end
end


function c500316971.xfilter(c,tp)
	return c:IsSetCard(0x185a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  --and Duel.IsExistingMatchingCard(c500316971.xfilter2,tp,LOCATION_DECK,0,1,nil,c)
	 
end
function c500316971.xfilter2(c,mc)
	 return c:IsSetCard(0x85a) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c500316971.thcon(e,tp,eg,ep,ev,re,r,rp)
return  e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c500316971.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500316971.xfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c500316971.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500316971.xfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c500316971.xfilter2),tp,LOCATION_DECK,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		if g:IsExists(c500316971.xfilter3,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
	Duel.Draw(tp,1,REASON_EFFECT)
end
		end
	end
end
function c500316971.xfilter3(c)
return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_RITUAL)
end