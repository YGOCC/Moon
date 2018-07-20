--Ciber Skull Servant
--Keddy was here~
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Invocación Enlace
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.LinkCondition(cod.lfitler,2,2))
	e1:SetTarget(aux.LinkTarget(cod.lfitler,2,2))
	e1:SetOperation(aux.LinkOperation(cod.lfitler,2,2))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--Invocación Enlace 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cod.lkcon)
	e2:SetTarget(cod.lktg)
	e2:SetOperation(cod.lkop)
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)
	--Invoca del Cementerio
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,5))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
--  e3:SetCountLimit(1,id)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cod.spgcon)
    e3:SetTarget(cod.spgtg)
    e3:SetOperation(cod.spgop)
    c:RegisterEffect(e3)
	--Invoca de la Mano
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,6))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
--  e4:SetCountLimit(1,id)
    e4:SetCondition(cod.sphcon)
    e4:SetTarget(cod.sphtg)
    e4:SetOperation(cod.sphop)
    c:RegisterEffect(e4)
end

--Filtro para Materiales Enlace
function cod.lfitler(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_ZOMBIE)
end
--Segundo filtro para Materiales Enlace
function cod.lgfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end

--Invocación Enlace Secundario
function cod.lkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Auxiliary.GetLinkMaterials(tp,cod.lgfilter,c)
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,2,nil,RACE_ZOMBIE) 
end
function cod.lktg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_GRAVE,0,nil,nil,c)
	local lg=g:Filter(cod.lgfilter,nil)
	if #lg<2 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local sg=g:Select(tp,2,2,nil)
	if #sg==2 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cod.lkop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_LINK)>0 then
		g:DeleteGroup()
		--Reducir Enlace 
		Card.SetCardData(c,5,1)
		--Reducir Flecha
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
    	if op==0 then
    		Card.SetCardData(c,12,LINK_MARKER_RIGHT)
    	else
    		Card.SetCardData(c,12,LINK_MARKER_BOTTOM)
    	end
	end
end

--Invoca del Cementerio
function cod.spcfilter(c,ec)
    if c:IsLocation(LOCATION_MZONE) then
        return ec:GetLinkedGroup():IsContains(c)
    else
        return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
    end
end
function cod.spgcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cod.spcfilter,1,nil,e:GetHandler()) then
		local lv=eg:GetFirst():GetLevel()
		e:SetLabel(lv)
		return true
	end
end
function cod.spfilter1(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end		
function cod.spgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cod.spfilter1(chkc,e,tp,e:GetLabel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cod.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cod.spgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cod.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
	if #g<=0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

--Invoca de la Mano
function cod.spfilter2(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cod.sphcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function cod.sphtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and cod.spfilter2(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cod.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cod.sphop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cod.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g<=0 then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if c:IsAbleToExtra() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end