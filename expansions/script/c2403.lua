--Random Name Maker
function c2403.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xf7)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c2403.start)
	c:RegisterEffect(e1)
end
function c2403.start(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,2401)==0 and Duel.GetFlagEffect(1-tp,2401)==0 then
		Duel.DisableShuffleCheck()
		Duel.ConfirmCards(0,c)
		if Duel.Exile(c,REASON_EFFECT)==0 then
			Duel.SendtoDeck(c,nil,-2,REASON_EFFECT)
		end
		if c:GetPreviousLocation()==LOCATION_HAND then
			Duel.Draw(tp,1,REASON_RULE)
		end
		local io,string,os=require('io'),require('string'),require('os')
		local ct=0
		::redo::
		local chk={
			[1]={
				[1]="Kaiba- -Seto",[2]={
					[01]="Shizuka- -Kawai",
					[02]="Psychotic-Marik",
					[03]="Marufuji- -Ryou",
					[04]="Edo- - -Phoenix",
					[05]="American- -Badass",
				}
			},
			[2]={
				[1]="Malik- -Ishtar",[2]={
					[01]="Shizuka- -Kawai",
					[02]="Marufuji- -Ryou",
					[03]="Edo- - -Phoenix",
					[04]="American- -Badass",
				}
			},
			[3]={
				[1]="Psychotic-Marik",[2]={
					[01]="Malik- -Ishtar",
				}
			},
			[4]={
				[1]="Shizuka- -Kawai",[2]={
					[01]="Kaiba- -Seto",
					[02]="Marufuji- -Ryou",
					[03]="Edo- - -Phoenix",
					[04]="American- -Badass",
				}
			},
			[5]={
				[1]="Marufuji- -Ryou",[2]={
					[01]="Kaiba- -Seto",
					[02]="Shizuka- -Kawai",
					[03]="Psychotic-Marik",
					[04]="American- -Badass",
				}
			},
			[6]={
				[1]="Edo- - -Phoenix",[2]={
					[01]="Kaiba- -Seto",
					[02]="Shizuka- -Kawai",
					[03]="American- -Badass",
				}
			},
			[7]={
				[1]="American- -Badass",[2]={
					[01]="Kaiba- -Seto",
					[02]="Psychotic-Marik",
					[03]="Marufuji- -Ryou",
					[04]="Edo- - -Phoenix",
				}
			},
		}
		local chkn=#chk
		local base,new,id,n,id1,name,name1,name2,chkc,seed,content,ls={table.unpack(chk)},nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
		math.randomseed(os.time()+ct)
		repeat
			repeat
				id=math.max(1,math.ceil(math.random(0,#base)))
				n=base[id][1]
			until n~="Malik- -Ishtar" and n~=nil
			na=n:gsub(" ","")
			new={na}
			for l=1,#base do
				for m=1,#base[l][2] do
					if n==base[l][2][m] then
						table.remove(base[l][2],m)
					end
				end
			end
			::regen::
			repeat
				id1=math.max(1,math.ceil(math.random(0,#base[id][2])))
				name=base[id][2][id1]
			until name~=nil or #base[id][2]==0
			if name then
				name2=name:gsub(" ","")
				table.insert(new,name2)
				table.remove(base,id)
				for i=1,#base do
					for k=1,#base[i][2] do
						if name==base[i][2][k] then
							table.remove(base[i][2],k)
						end
					end
				end
				if #new==chkn then
					chkc=false
					for o=1,#chk do
						name1=chk[o][1]:gsub(" ","")
						if name1==new[1] then
							for p=1,#chk[o][2] do
								if chk[o][2][p]==name then chkc=true end
							end
						end
					end
					while not chkc do
						ct=ct+1
						goto redo
					end
				end
				for j=1,#base do
					if base[j][1]==name then id=j end
				end
			else
				if #base[id][2]==0 then
					Duel.Win(1-tp,3)
					break
				end
			end
			if #new>=chkn then
				content=table.concat(new,"\n")
				for q in content:gmatch("%S+") do
					Debug.Message(q)
				end
				ls=io.open("SVW_line-Mock.txt","w+")
				ls:write(content.."\n")
				ls:flush()
				ls:close()
				Duel.Win(tp,3)
				break
			else
				while name do
					ct=ct+1
					goto regen
				end
			end
			ct=ct+1
		until false
		Duel.RegisterFlagEffect(tp,2401,0,0,1)
	end
end
