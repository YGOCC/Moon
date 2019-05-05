--Reality Procedure
Reality=Reality or {}
local cm=Reality
cm.m=88880062
TYPE_REALITY							=0x903
SUMMON_TYPE_REALITY		 =SUMMON_TYPE_SPECIAL+903
function Reality.AddRealityProcedure(c,f,gf,minc,maxc,desc,op)
	c:EnableCounterPermit(0x77)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Reality.RealityCondition(f,gf,minc,maxc))
	e1:SetTarget(Reality.RealityTarget(f,gf,minc,maxc))
	e1:SetOperation(Reality.RealityOperation(f,gf,minc,maxc))
	e1:SetValue(SUMMON_TYPE_REALITY)
	c:RegisterEffect(e1)
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsSetCard,0x903),LOCATION_MZONE)
end
--Reality Summon
function Reality.RealityFilter(c,realityc,f)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(realityc) and (not f or f(c,realityc))
end
function Reality.RealityGoal(g,tp,realityc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,realityc)>0
end
function Reality.RealityCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Reality.RealityFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Reality.RealityFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Reality.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Reality.RealityGoal,minc,maxc,tp,c,gf)
				Reality.GCheckAdditional=nil
				return res
			end
end
function Reality.RealityTarget(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Reality.RealityFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Reality.RealityFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88880062,1))
				Reality.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Reality.RealityGoal,true,minc,maxc,tp,c,gf)
				Reality.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Reality.RealityOperation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EFFECT_REMOVE_TYPE)
					e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetValue(TYPE_XYZ)
					c:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_SPSUMMON_SUCCESS)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
					e2:SetCondition(Reality.addcon)
					e2:SetOperation(Reality.addc)
					e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
					c:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetDescription(aux.Stringid(88880062,2))
					e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e3:SetRange(LOCATION_MZONE)
					e3:SetCountLimit(1)
					e3:SetCondition(Reality.rccon)
					e3:SetOperation(Reality.rcop)
					c:RegisterEffect(e3)
				end
			end
end
function Reality.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+903
end
function Reality.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x77,1)
end
function Reality.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function Reality.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mon=e:GetHandler():GetOverlayGroup()
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x77,1,REASON_RULE) end
	e:GetHandler():RemoveCounter(tp,0x77,1,REASON_RULE)
	if e:GetHandler():GetCounter(0x77)==0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
		Duel.SpecialSummon(mon,CATEGORY_SPECIAL_SUMMON,tp,tp,true,false,POS_FACEUP)
	end
end