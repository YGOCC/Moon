--created & coded by Lyris
--サイバー・スペース・エクシーズ・ドラゴン
function c240100113.initial_effect(c)
c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c240100113.xyzfilter,7,3,c240100113.ovfilter,aux.Stringid(240100113,2),3)
	c:SetSPSummonOnce(240100113)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e6)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(c240100113.spslimit)
	c:RegisterEffect(e0)
	local fm=Effect.CreateEffect(c)
	fm:SetType(EFFECT_TYPE_SINGLE)
	fm:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fm:SetCode(EFFECT_FUSION_MATERIAL)
	fm:SetCondition(c240100113.fmcon)
	fm:SetOperation(c240100113.fmatl)
	c:RegisterEffect(fm)
	local fs=Effect.CreateEffect(c)
	fs:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	fs:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fs:SetCode(EVENT_SPSUMMON_SUCCESS)
	fs:SetOperation(c240100113.fop)
	c:RegisterEffect(fs)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c240100113.atkct)
	c:RegisterEffect(e1)
end
function c240100113.code(c)
	return c:IsFusionCode(70095154) or c:IsFusionCode(240100024)
end
function c240100113.spslimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c240100113.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c240100113.ovfilter(c,tc)
	return c:IsFaceup() and c:IsRankAbove(5) and c240100113.xyzfilter(c) and c:GetCode()~=240100024
end
function c240100113.ovop(e,tp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,aux.XyzAlterFilter,tp,LOCATION_MZONE,0,1,1,nil,c240100113.ovfilter,c)
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		local tc=mg2:GetFirst()
		while tc do
			mg:AddCard(tc)
			tc=mg2:GetNext()
		end
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	return
end
function c240100113.ffilter(c)
	return c:IsFusionSetCard(0x1093) or c:IsFusionSetCard(0x4093)
end
function c240100113.fmcon(e,g,gc,chkf)
	if g==nil then return false end
	if gc then
		local mg=g:Filter(c240100113.ffilter,nil)
		mg:AddCard(gc)
		return c240100113.ffilter(gc) and mg:GetClassCount(Card.GetCode)>=3
	end
	local fs=false
	local mg=g:Filter(c240100113.ffilter,nil)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetCode)>=3 and (fs or chkf==PLAYER_NONE)
end
function c240100113.fmatl(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(c240100113.ffilter,gc)
		sg:Remove(Card.IsCode,nil,gc:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=sg:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(c240100113.ffilter,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	g1:Merge(g3)
	Duel.SetFusionMaterial(g1)
end
function c240100113.olcheck(c)
	return c:GetOverlayCount()>0
end
function c240100113.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
		local g=c:GetMaterial()
		local ck=false
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then ck=true end
		local og=g:Filter(c240100113.olcheck,nil)
		local tc=og:GetFirst()
		if tc then Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE) end
		Duel.Overlay(c,g)
		if ck then Duel.ShuffleHand(tp) end
	end
end
function c240100113.atkct(e)
	return e:GetHandler():GetOverlayCount()-1
end
