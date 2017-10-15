--Ascended Brightvale-Aurelie
function c57418399.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c57418399.fscon)
	e0:SetOperation(c57418399.fsop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c57418399.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c57418399.sprcon)
	e2:SetOperation(c57418399.sprop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(57418399,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,57418386)
	e3:SetTarget(c57418399.tgtg)
	e3:SetOperation(c57418399.tgop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(57418399,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1,57418384)
	e4:SetCondition(c57418399.descon)
	e4:SetTarget(c57418399.destg)
	e4:SetOperation(c57418399.desop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57418399,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,57418381)
	e5:SetCondition(c57418399.spcon3)
	e5:SetTarget(c57418399.sptg3)
	e5:SetOperation(c57418399.spop3)
	c:RegisterEffect(e5)
end
function c57418399.filter1(c)
	return c:IsFusionSetCard(0x9c4) and c:IsFusionType(TYPE_FUSION) and not c:IsHasEffect(6205579)
end
function c57418399.filter2(c)
	return c:IsFusionSetCard(0x9c4) and not c:IsHasEffect(6205579)
end
function c57418399.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c54401832.filter1
	local f2=c54401832.filter2
	local chkf=bit.band(chkfnf,0xff)
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	local mg1=mg:Filter(aux.FConditionFilterConAndSub,nil,f1,true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		return aux.FConditionFilterFFRCol1(gc,f1,f2,2,chkf,mg,nil,0) 
			or mg1:IsExists(aux.FConditionFilterFFRCol1,1,nil,f1,f2,2,chkf,mg,nil,0,gc)
	end
	return mg1:IsExists(Auxiliary.FConditionFilterFFRCol1,1,nil,f1,f2,2,chkf,mg,nil,0)
end
function c57418399.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c54401832.filter1
	local f2=c54401832.filter2
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	local mg1=g:Filter(aux.FConditionFilterConAndSub,nil,f1,true)
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		local matg=Group.CreateGroup()
		if aux.FConditionFilterFFRCol1(gc,f1,f2,2,chkf,g,nil,0) then
			matg:AddCard(gc)
			for i=1,2 do
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
				local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,i-1)
				matg:Merge(g1)
				g:Sub(g1)
			end
			matg:RemoveCard(gc)
			if sfhchk then Duel.ShuffleHand(tp) end
			Duel.SetFusionMaterial(matg)
		else
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			local matg=mg1:FilterSelect(p,aux.FConditionFilterFFRCol1,1,1,nil,f1,f2,2,chkf,g,nil,0,gc)
			matg:AddCard(gc)
			g:Sub(matg)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,1)
			matg:Merge(g1)
			g:Sub(g1)
			matg:RemoveCard(gc)
			if sfhchk then Duel.ShuffleHand(tp) end
			Duel.SetFusionMaterial(matg)
		end
		return
	end
	local matg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local matg=mg1:FilterSelect(p,aux.FConditionFilterFFRCol1,1,1,nil,f1,f2,2,chkf,g,nil,0,gc)
	g:Sub(matg)
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,i-1)
		matg:Merge(g1)
		g:Sub(g1)
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(matg)
end


function c57418399.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c57418399.spfilter1(c,tp,sc)
	return c:IsFusionSetCard(0x9c4) and c:IsFusionType(TYPE_FUSION) and c:IsCanBeFusionMaterial(sc,true) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c57418399.spfilter2,tp,LOCATION_ONFIELD,0,2,c,sc)
end
function c57418399.spfilter2(c,sc)
	return c:IsFusionSetCard(0x9c4) and c:IsFusionType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(sc,true) and c:IsAbleToGraveAsCost()
end
function c57418399.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c57418399.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
function c57418399.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c57418399.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c57418399.spfilter2,tp,LOCATION_ONFIELD,0,2,2,tc,c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c57418399.tgfilter(c)
	return c:IsSetCard(0x9c4) and c:IsAbleToGrave()
end
function c57418399.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57418399.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c57418399.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c57418399.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c57418399.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c57418399.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c57418399.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c57418399.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c57418399.spfilter3(c,e,tp)
	return c:IsSetCard(0x9c4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c57418399.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c57418399.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c57418399.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57418399.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end