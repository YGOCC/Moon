--Tool Gear
function c101600108.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600108,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101600108.tg)
	e1:SetOperation(c101600108.op)
	e1:SetCountLimit(1,101600108)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(e2)
	--synchro custom
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(c101600108.syntg)
	e4:SetValue(1)
	e4:SetOperation(c101600108.synop)
	c:RegisterEffect(e4)
end
function c101600108.filter(c)
	return c:IsSetCard(0xcd01) and c:IsAbleToHand() and not c:IsCode(101600108)
end
function c101600108.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101600108.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101600108.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101600108.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101600108.synfilter1(c,syncard,tuner,f)
    return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c101600108.synfilter2(c,syncard,tuner,f)
    return c:IsSetCard(0xcd01) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c101600108.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
    g:AddCard(c)
    local ct=g:GetCount()
    local res=c101600108.syngoal(g,tp,lv,syncard,minc,ct)
        or (ct<maxc and mg:IsExists(c101600108.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
    g:RemoveCard(c)
    return res
end
function c101600108.syngoal(g,tp,lv,syncard,minc,ct)
    return ct>=minc
        and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
        and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function c101600108.syntg(e,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local tp=syncard:GetControler()
    local lv=syncard:GetLevel()
    if lv<=c:GetLevel() then return false end
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c101600108.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    if (syncard:GetLevel()==7 or syncard:GetLevel()==8) and syncard:IsRace(RACE_DRAGON) then
        local exg=Duel.GetMatchingGroup(c101600108.synfilter2,syncard:GetControler(),LOCATION_GRAVE,0,c,syncard,c,f)
        mg:Merge(exg)
    end
    return mg:IsExists(c101600108.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c101600108.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local lv=syncard:GetLevel()
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c101600108.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    if (syncard:GetLevel()==7 or syncard:GetLevel()==8) and syncard:IsRace(RACE_DRAGON) then
        local exg=Duel.GetMatchingGroup(c101600108.synfilter2,syncard:GetControler(),LOCATION_GRAVE,0,c,syncard,c,f)
        mg:Merge(exg)
    end
    for i=1,maxc do
        local cg=mg:Filter(c101600108.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
        if cg:GetCount()==0 then break end
        local minct=1
        if c101600108.syngoal(g,tp,lv,syncard,minc,i) then
            if not Duel.SelectYesNo(tp,210) then break end
            minct=0
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local sg=cg:Select(tp,minct,1,nil)
        if sg:GetCount()==0 then break end
        g:Merge(sg)
    end
	local ban=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if ban then
		for i=1,ban:GetCount() do
			bann=ban:GetFirst()
			g:RemoveCard(bann)
		end
	end
	Duel.SetSynchroMaterial(g)
	if ban and Duel.SendtoDeck(ban,nil,0,REASON_EFFECT+REASON_MATERIAL)~=0 then Duel.ShuffleDeck(tp) end
end
