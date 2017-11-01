--Stardust
function c101600104.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600104,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c101600104.spcon)
	e1:SetCost(c101600104.spcost)
	e1:SetTarget(c101600104.sptg)
	e1:SetOperation(c101600104.spop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101600104,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101600104.thtg)
	e2:SetOperation(c101600104.thop)
	e2:SetCountLimit(1,101600104)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--synchro custom
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(c101600104.syntg)
	e4:SetValue(1)
	e4:SetOperation(c101600104.synop)
	c:RegisterEffect(e4)
end
function c101600104.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c101600104.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101600104)<1 end
end
function c101600104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c101600104.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.RegisterFlagEffect(tp,101600104,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101600104.filter(c)
	return ((c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra())
		or (c:IsSetCard(0xcd01) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand())
end
function c101600104.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101600104.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101600104.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101600104.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101600104.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101600104.synfilter1(c,syncard,tuner,f)
    return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c101600104.synfilter2(c,syncard,tuner,f)
    return c:IsSetCard(0xcd01) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c101600104.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
    g:AddCard(c)
    local ct=g:GetCount()
    local res=c101600104.syngoal(g,tp,lv,syncard,minc,ct)
        or (ct<maxc and mg:IsExists(c101600104.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
    g:RemoveCard(c)
    return res
end
function c101600104.syngoal(g,tp,lv,syncard,minc,ct)
    return ct>=minc
        and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
        and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function c101600104.syntg(e,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local tp=syncard:GetControler()
    local lv=syncard:GetLevel()
    if lv<=c:GetLevel() then return false end
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c101600104.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    if (syncard:GetLevel()==7 or syncard:GetLevel()==8) and syncard:IsRace(RACE_DRAGON) then
        local exg=Duel.GetMatchingGroup(c101600104.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
        mg:Merge(exg)
    end
    return mg:IsExists(c101600104.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c101600104.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local lv=syncard:GetLevel()
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c101600104.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    if (syncard:GetLevel()==7 or syncard:GetLevel()==8) and syncard:IsRace(RACE_DRAGON) then
        local exg=Duel.GetMatchingGroup(c101600104.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
        mg:Merge(exg)
    end
    for i=1,maxc do
        local cg=mg:Filter(c101600104.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
        if cg:GetCount()==0 then break end
        local minct=1
        if c101600104.syngoal(g,tp,lv,syncard,minc,i) then
            if not Duel.SelectYesNo(tp,210) then break end
            minct=0
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local sg=cg:Select(tp,minct,1,nil)
        if sg:GetCount()==0 then break end
        g:Merge(sg)
    end
    Duel.SetSynchroMaterial(g)
end
