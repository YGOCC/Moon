--T.G. V-LAN Hyperion
function c240100002.initial_effect(c)
	c:EnableReviveLimit()
	--2+ monsters
	aux.AddLinkProcedure(c,nil,2)
	--You can also Link Summon this card using 1 "T.G." Synchro Monster as the Link Material.
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(240100002,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c240100002.linkcon)
	e0:SetOperation(c240100002.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--If a monster(s) with a monster card type(s) (Fusion, Synchro, Xyz, Pendulum, or Link) of a monster this card points to is Special Summoned: Draw 1 card. This card must be face-up on the field to activate and to resolve this effect.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(240100002,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c240100002.drcon)
	e1:SetTarget(c240100002.drtg)
	e1:SetOperation(c240100002.drop)
	c:RegisterEffect(e1)
	--If this card is destroyed: You can target 1 other "T.G." monster in your GY; Special Summon it.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,240100002)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(c240100002.sptg)
	e2:SetOperation(c240100002.spop)
	c:RegisterEffect(e2)
end
function c240100002.linkfilter(c,lc)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x27) and c:IsCanBeLinkMaterial(lc) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),lc)>0
end
function c240100002.linkcon(e,c)
	if c==nil then return true end
	if (c:IsType(TYPE_PENDULUM) or not Card.IsTypeCustom or c:IsTypeCustom("Pandemonium") or c:IsTypeCustom("Relay")) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c240100002.linkfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c240100002.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c240100002.linkfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function c240100002.filter1(c,tc,tp)
	local xtype=bit.band(c:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
	return c:IsFaceup() and xtype~=0 and tc:GetLinkedGroup():IsExists(c240100002.filter2,1,c,xtype)
end
function c240100002.filter2(c,xtyp)
	return bit.band(c:GetType(),xtyp)~=0
end
function c240100002.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c240100002.filter1,1,c,c,tp)
end
function c240100002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c240100002.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c240100002.spfilter(c,e,tp)
	return c:IsSetCard(0x27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100002.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c240100002.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c240100002.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c240100002.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
