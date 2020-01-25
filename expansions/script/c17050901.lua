--斯忒诺
local m=17050901
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
				local minc=2
				local maxc=zone:GetCount() 
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,cm.xyzfilter,7,minc,maxc,zone)
			end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
				local minc=minc
				local maxc=zone:GetCount() 
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.SelectXyzMaterial(tp,c,cm.xyzfilter,7,minc,maxc,zone)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17050901)
	e1:SetCondition(cm.hspcon)
	e1:SetOperation(cm.hspop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_REPTILE))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--ntr
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetDescription(aux.Stringid(17050901,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.cttg)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17050901,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.pencon)
	e6:SetTarget(cm.pentg)
	e6:SetOperation(cm.penop)
	c:RegisterEffect(e6)
end
cm.pendulum_level=7
function cm.xyzfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and (c:IsRace(RACE_REPTILE) or not c:IsLocation(LOCATION_GRAVE))
end
function cm.spfilter(c,ft)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE)
		and (ft>0 or c:GetSequence()<5)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	local sc=g:GetFirst()
	local sg1=sc:GetOverlayGroup()
	Duel.Overlay(c,sg1)
	Duel.Overlay(c,sc)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetOverlayGroup()
	if chk==0 then return lg:IsExists(Card.IsAbleToRemove,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=lg:FilterSelect(tp,Card.IsAbleToRemove,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
