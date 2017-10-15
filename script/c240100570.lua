--Winged Blademaster Iona
function c240100570.initial_effect(c)
	c:EnableReviveLimit()
	--2 "Blademaster" monsters with the same Level
	--xyz summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1073)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c240100570.xyzcon)
	e5:SetOperation(c240100570.xyzop)
	e5:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e5)
	--link summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1076)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(c240100570.lkcon)
	e6:SetOperation(c240100570.lkop)
	e6:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e6)
	--Inflicts piercing battle damage if it attacks a Defense Position monster.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--Gains 200 ATK for "Blademaster" monster you control and 100 ATK for each monster it points to.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100570.val)
	c:RegisterEffect(e1)
	--Once per turn while this card is on the field with material attached to it, if a "Blademaster" monster this card points to activates its effect, you can Special Summon 1 "Blademaster" monster from your GY to either field in a zone this card does not point to in face-up Defense Position immediately after that effect resolves.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c240100570.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(function(e) local c=e:GetHandler() if c:GetFlagEffect(240100570)==0 then c:RegisterFlagEffect(240100570,RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000,0,1) end end)
	c:RegisterEffect(e3)
	--Attach as many of this card's Link Materials as possible to this card as Xyz Materials immediately after it is Link Summoned.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c240100570.thcon)
	e4:SetOperation(c240100570.thop)
	c:RegisterEffect(e4)
end
function c240100570.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xbb2) and c:IsLevelAbove(1) and c:IsCanBeXyzMaterial(xyzc)
end
function c240100570.xyzfilter1(c,g,sc)
	return g:IsExists(c240100570.xyzfilter2,1,c,c,sc)
end
function c240100570.xyzfilter2(c,mc,sc)
	return c:GetLevel()==mc:GetLevel() and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),sc)>0
end
function c240100570.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c240100570.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c240100570.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and (not min or min<=2 and max>=2)
		and mg:IsExists(c240100570.xyzfilter1,1,nil,mg,c)
end
function c240100570.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c240100570.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c240100570.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c240100570.xyzfilter1,1,1,nil,mg,c)
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c240100570.xyzfilter2,1,1,tc,tc,c)
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c240100570.lkfilter1(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsSetCard(0xbb2) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c240100570.lkfilter2,tp,LOCATION_MZONE,0,1,c,lc,c,tp)
end
function c240100570.lkfilter2(c,lc,mc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsSetCard(0xbb2) and c:GetLevel()==mc:GetLevel() and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function c240100570.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c240100570.lkfilter1,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c240100570.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c240100570.lkfilter1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,c240100570.lkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
function c240100570.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c240100570.val(e)
	return Duel.GetMatchingGroupCount(c240100570.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*100+e:GetHandler():GetLinkedGroupCount()*200
end
function c240100570.filter(c,e,tp,zone)
	return c:IsSetCard(0xbb2)
		and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)))
end
function c240100570.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(240100570)==0 then return end
	c:ResetFlagEffect(240100570)
	local zone=bit.bxor(0x1f,c:GetLinkedZone())
	local g=Duel.GetMatchingGroup(c240100570.filter,tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	local rc=re:GetHandler()
	if c:GetFlagEffect(240100570)~=0 or c:GetOverlayCount()==0 or not re:IsActiveType(TYPE_MONSTER) or not rc:IsSetCard(0xbb2)
		or not c:GetLinkedGroup():IsContains(rc) or g:GetCount()==0
		or not Duel.SelectEffectYesNo(tp,c) then return end
	Duel.Hint(HINT_CARD,0,240100570)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(240100570,0),aux.Stringid(240100570,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(240100570,0))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(240100570,1))+1
		else return end
		if op==0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
		else
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	c:RegisterFlagEffect(240100570,RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000,0,1)
end
function c240100570.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c240100570.thfilter(c,g)
	return g:IsContains(c)
end
function c240100570.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(aux.NecroValleyFilter(aux.TRUE),nil)
	if mg:GetCount()>0 then
		Duel.Overlay(c,mg:Select(tp,1,1,nil))
	end
end
