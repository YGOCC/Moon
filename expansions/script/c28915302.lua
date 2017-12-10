--VRT.EXE Excell
--Design and code by Kindrindra
local ref=_G['c'..28915302]
function ref.initial_effect(c)
	--Fusion
	--aux.AddFusionProcFunFunRep(c,ref.matfilter1,ref.matfilter2,1,63,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(ref.FConditionFunFunRep(ref.matfilter1,ref.matfilter2,1,63,true))
	e1:SetOperation(ref.FOperationFunFunRep(ref.matfilter1,ref.matfilter2,1,63,true))
	c:RegisterEffect(e1)
	--Mat Check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(ref.matcheck)
	c:RegisterEffect(e2)
	--Field Wipe
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28915302,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(ref.tdcon)
	e3:SetCost(ref.tdcost)
	e3:SetTarget(ref.tdtg)
	e3:SetOperation(ref.tdop)
	c:RegisterEffect(e3)
end
--Materials
function ref.matfilter1(c)
	return c:IsType(TYPE_FUSION)
end
function ref.matfilter2(c)
	return c:IsFusionSetCard(0x72B)
end

--Custom Fusion
function ref.FConditionCheckF(c,chkf)
	return c:IsOnField() and c:IsControler(chkf)
end
function ref.FConditionFilterFFR(c,f1,f2,mg,minc,chkf)
	if not f1(c) then return false end
	if chkf==PLAYER_NONE or ref.FConditionCheckF(c,chkf) then
		return minc<=0 or mg:IsExists(f2,minc,c)
	else
		local mg2=mg:Filter(f2,c)
		return mg2:GetCount()>=minc and mg2:IsExists(ref.FConditionCheckF,1,nil,chkf)
	end
end
function ref.FConditionFilterFFR(c,f1,f2,mg,minc,chkf)
	if not f1(c) then return false end
	if chkf==PLAYER_NONE or ref.FConditionCheckF(c,chkf) then
		return minc<=0 or mg:IsExists(f2,minc,c)
	else
		local mg2=mg:Filter(f2,c)
		return mg2:GetCount()>=minc and mg2:IsExists(ref.FConditionCheckF,1,nil,chkf)
	end
end
function ref.FConditionFunFunRep(f1,f2,minc,maxc,insf)
	return	function(e,g,gc,chkfnf)
			if g==nil then return insf end
			local chkf=bit.band(chkfnf,0xff)
			local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
			if gc then
				if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
				if ref.FConditionFilterFFR(gc,f1,f2,mg,minc,chkf) then
					return true
				elseif f2(gc) then
					mg:RemoveCard(gc)
					if ref.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
					return mg:IsExists(ref.FConditionFilterFFR,1,nil,f1,f2,mg,minc-1,chkf)
				else return false end
			end
			return mg:IsExists(ref.FConditionFilterFFR,1,nil,f1,f2,mg,minc,chkf)
		end
end
function ref.FConditionCheckF(c,chkf)
	return c:IsOnField() and c:IsControler(chkf)
end
function ref.FOperationFunFunRep(f1,f2,minc,maxc,insf)
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
			local chkf=bit.band(chkfnf,0xff)
			local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
			local minct=minc
			local maxct=maxc
			if gc then
				g:RemoveCard(gc)
				if ref.FConditionFilterFFR(gc,f1,f2,g,minct,chkf) then
					if ref.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
					local g1=Group.CreateGroup()
					if f2(gc) then
						local mg1=g:Filter(ref.FConditionFilterFFR,nil,f1,f2,g,minct-1,chkf)
						if mg1:GetCount()>0 then
							--if gc fits both, should allow an extra material that fits f1 but doesn't fit f2
							local mg2=g:Filter(f2,nil)
							mg1:Merge(mg2)
							if chkf~=PLAYER_NONE then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
								local sg=mg1:FilterSelect(tp,ref.FConditionCheckF,1,1,nil,chkf)
								g1:Merge(sg)
								mg1:Sub(sg)
								minct=minct-1
								maxct=maxct-1
								if not f2(sg:GetFirst()) then
									if mg1:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
										if minct<=0 then minct=1 end
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
										local sg=mg1:FilterSelect(tp,f2,minct,maxct,nil)
										g1:Merge(sg)
									end
									Duel.SetFusionMaterial(g1)
									return
								end
							end
							if maxct>1 and (minct>1 or Duel.SelectYesNo(tp,93)) then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
								local sg=mg1:FilterSelect(tp,f2,minct-1,maxct-1,nil)
								g1:Merge(sg)
								mg1:Sub(sg)
								local ct=sg:GetCount()
								minct=minct-ct
								maxct=maxct-ct
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
							local sg=mg1:Select(tp,1,1,nil)
							g1:Merge(sg)
							mg1:Sub(sg)
							minct=minct-1
							maxct=maxct-1
							if mg1:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
								if minct<=0 then minct=1 end
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
								local sg=mg1:FilterSelect(tp,f2,minct,maxct,nil)
								g1:Merge(sg)
							end
							Duel.SetFusionMaterial(g1)
							return
						end
					end
					local mg=g:Filter(f2,nil)
					if chkf~=PLAYER_NONE then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg:FilterSelect(tp,ref.FConditionCheckF,1,1,nil,chkf)
						g1:Merge(sg)
						mg:Sub(sg)
						minct=minct-1
						maxct=maxct-1
					end
					if mg:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
						if minct<=0 then minct=1 end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg:Select(tp,minct,maxct,nil)
						g1:Merge(sg)
					end
					Duel.SetFusionMaterial(g1)
					return
				else
					if ref.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
					minct=minct-1
					maxct=maxct-1
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(tp,ref.FConditionFilterFFR,1,1,nil,f1,f2,g,minct,chkf)
			local mg=g:Filter(f2,g1:GetFirst())
			if chkf~=PLAYER_NONE and not ref.FConditionCheckF(g1:GetFirst(),chkf) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,ref.FConditionCheckF,1,1,nil,chkf)
				g1:Merge(sg)
				mg:Sub(sg)
				minct=minct-1
				maxct=maxct-1
			end
			if mg:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
				if minct<=0 then minct=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:Select(tp,minct,maxct,nil)
				g1:Merge(sg)
			end
			local cc=g1:GetFirst()
			while cc do
				if cc:IsFusionSetCard(0x72B) then
					e:GetHandler():CopyEffect(cc:GetOriginalCodeRule(),RESET_EVENT+0xfe0000,1)
					cc=g1:GetNext()
				end
			end
			Duel.SetFusionMaterial(g1)
		end
end

--Mat Check
function ref.matcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsType,nil,TYPE_FUSION)
	if g:GetCount()>1 then
		c:RegisterFlagEffect(28915302,RESET_EVENT+0xfe0000,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1)
	end
end

--Field Wipe
function ref.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(28915302)~=0
end
function ref.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SendtoGrave(Duel.GetFieldGroup(tp,LOCATION_HAND,0),REASON_COST+REASON_DISCARD)
end
function ref.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function ref.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
