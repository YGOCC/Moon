--Sweethard-Powered: Sagi Rabbit
function c50031003.initial_effect(c)
 aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
 aux.AddEvoluteProc(c,nil,4,c50031003.filter1,c50031003.filter2)  

--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(50031003,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c50031003.hspcon)
	e0:SetOperation(c50031003.hspop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+388)
	c:RegisterEffect(e0)
		--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50031003,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c50031003.cost)
	e1:SetTarget(c50031003.target)
	e1:SetOperation(c50031003.operation)
	c:RegisterEffect(e1)
	   --to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50031003,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c50031003.retcon)
	e2:SetTarget(c50031003.rettg)
	e2:SetOperation(c50031003.retop)
	c:RegisterEffect(e2)
end
function c50031003.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c50031003.filter2(c,ec,tp)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c50031003.spfilter(c,ft)
	return c:IsFaceup() and c:IsCode(500310030) 
		and (ft>0 or c:GetSequence()<5)
end
function c50031003.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c50031003.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c50031003.hspop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_MATERIAL)
	local g=Duel.SelectMatchingCard(tp,c50031003.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x10000000)
	 if chk==0 then return Duel.GetFlagEffect(tp,50031003)==0 end
	Duel.RegisterFlagEffect(tp,50031003,RESET_PHASE+PHASE_END,0,1)
end
function c50031003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST) end
	e:GetHandler():RemoveEC(tp,5,REASON_COST)
end
function c50031003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,3):GetCount()==3 end
end
function c50031003.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetDecktopGroup(tp,3):GetCount()==3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sel=0
	if g:IsExists(function(tc) return tc:IsSetCard(0xa34) and tc:IsType(TYPE_MONSTER) end,1,nil) then sel=sel+1 end
	if g:IsExists(function(tc) return tc:IsSetCard(0xa034) and tc:IsType(TYPE_SPELL) end,1,nil) then sel=sel+2 end
	if g:IsExists(function(tc) return tc:IsSetCard(0xa034) and tc:IsType(TYPE_TRAP) end,1,nil) then sel=sel+4 end
	if sel==0 then return end
	--setting the option
	if sel==1 then
		Duel.SelectOption(tp,aux.Stringid(50031003,1))
		opt=0
	elseif sel==2 then
		Duel.SelectOption(tp,aux.Stringid(50031003,2))
		opt=1
	elseif sel==3 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031003,1),aux.Stringid(50031003,2))
	elseif sel==4 then
		Duel.SelectOption(tp,aux.Stringid(50031003,3))
		opt=2
	elseif sel==5 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031003,1),aux.Stringid(50031003,3))
		if opt==1 then opt=2 end
	elseif sel==6 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031003,2),aux.Stringid(50031003,3))+1
	elseif sel==7 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031003,1),aux.Stringid(50031003,2),aux.Stringid(50031003,3))
	end
	--getting the option and executing
	if opt==0 then
	   Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-500)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			g2:GetFirst():RegisterEffect(e2)
		end
	end
	if opt==2 then
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetValue(c50031003.aclimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end

 for i=1,3 do
			local g=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(g:GetFirst(),1)

end
end


function c50031003.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end

function c50031003.retcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():GetPreviousControler()==tp
end

function c50031003.thfilter(c,e,tp)
	return c:IsSetCard(0xa34) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50031003.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50031003.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50031003.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50031003.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end


