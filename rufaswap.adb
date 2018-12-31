

--
-- Copyright (C) 2019  <fastrgv@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You may read the full text of the GNU General Public License
-- at <http://www.gnu.org/licenses/>.
--


-- RufasSwap:  restore scrambled pictures by swapping parts



-------------------------------------------------------------------------------


with snd4ada_hpp;

with gl, gl.binding, gl.pointers;
with glu, glu.binding, glu.pointers;
with glext, glext.binding, glext.pointers;

-------------------------------------------------------------
with System;
with Interfaces.C;
use  type interfaces.c.unsigned;
with Interfaces.C.Pointers;
with interfaces.c.strings;

----------------------------------------------------------------
with sdl;  use sdl;
----------------------------------------------------------------

with matutils;
with utex;

with ada.unchecked_conversion;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with ada.numerics.generic_elementary_functions;

----------------------------------------------------------------


with shader;  use shader;

with partobj;



with text_io;
with ada.integer_text_io;
with pngloader;
with matutils;

with ada.calendar;
with ada.directories;

with ada.strings.fixed;
with ada.numerics.float_random;

----------------------------------------------------------------
with gametypes;




procedure rufaswap is

	G : Ada.Numerics.Float_Random.Generator;

	use gametypes;
	use Ada.Strings.Unbounded;
	use Ada.Strings.Unbounded.Text_IO;


	use text_io;
	use pngloader;
	use matutils;

	use interfaces.c;
	use interfaces.c.strings;
	use glext;
	use glext.pointers;
	use glext.binding;
	use gl;
	use gl.binding;
	use gl.pointers;


	package fmath is new
			Ada.Numerics.generic_elementary_functions( float );
	use fmath;







procedure myassert( condition : boolean;  flag: integer:=0 ) is
begin
  if condition=false then
  		put("ASSERTION Failed!  ");
		if flag /= 0 then
			put_line( "@ " & integer'image(flag) );
		end if;
		new_line;
  		raise program_error;
  end if;
end myassert;






procedure InitSDL( width, height : glint;  flags:Uint32;  name: string ) is

use system;

	major, minor, profile, compflag,
  error, cver : interfaces.c.int;
  bresult : SDL_bool;

  compiled, linked : aliased SDL_version;


	pms : char_array := To_C("GL_ARB_multisample");
	psampl : aliased glint;
	glbp :  glboolean_pointer;

begin
	glbp := new glboolean;
	glbp.all := gl_false;


	-- Careful!  Only initialize what we use (otherwise exe won't run):
	error := SDL_Init(SDL_INIT_TIMER or SDL_INIT_EVENTS or SDL_INIT_VIDEO);
	myassert( error = 0 ,1001 );

---------- begin 14feb15 insert ------------------------------------------------
	SDL_SOURCEVERSION( compiled'access );
	put_line("We compiled against SDL version "
		&Uint8'image(compiled.major)&"."
		&Uint8'image(compiled.minor)&"."
		&Uint8'image(compiled.patch) );
	cver := SDL_COMPILEDVERSION;  
	put_line("SDL_compiledversion="&glint'image(cver));
	SDL_GetVersion( linked'access );
	put_line("We linked against SDL version "
		&Uint8'image(linked.major)&"."
		&Uint8'image(linked.minor)&"."
		&Uint8'image(linked.patch) );
---------- end 14feb15 insert --------------------------------------------------

	bresult := SDL_SetHint( SDL_HINT_RENDER_VSYNC, "1" );
	myassert( bresult = SDL_TRUE ,1002 );
	bresult := SDL_SetHint( SDL_HINT_RENDER_SCALE_QUALITY, "1" );
	myassert( bresult = SDL_TRUE ,1003 );




	--// Turn on double buffering.
	error := SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	myassert( error = 0 ,1004 );
	error := SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
	myassert( error = 0 ,1005 );
	error := SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
	myassert( error = 0 );





	error := SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	myassert( error = 0 ,1006 );
	error := SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
	myassert( error = 0 ,1007 );




	error := SDL_GL_SetAttribute( SDL_GL_CONTEXT_PROFILE_MASK, 
											SDL_GL_CONTEXT_PROFILE_CORE );
	myassert( error = 0 ,1008 );

	-- Note that OSX currently requires the forward_compatible flag!
	error := SDL_GL_SetAttribute( SDL_GL_CONTEXT_FLAGS, 
											SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG );
	myassert( error = 0 ,1009 );



	-- additions to reduce aliasing...
	-- Warning:  in case of failure on limited graphics hardware, 
	-- elliminate the next line.  It is known to cause failure
	-- on an Intel Skylake 520, for example.
	--error := SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 4);
	--myassert( error = 0 ,1010 );



	mainWindow := SDL_CreateWindow( To_C(name,true) , 
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
			width, height, flags);


	mainGLContext := SDL_GL_CreateContext(mainWindow);

	error := SDL_GL_MakeCurrent( mainWindow, mainGLContext );
	myassert( error = 0 ,1010 );


-- This next section is ugly.  If you know a better way
-- then please tell me how,  <fastrgv@gmail.com>
--
-- Note that it seems multisamples are not supported on OSX
-- although the aliasing seems subdued perhaps due to hiDPI.

---------------------------------------------------------------------
	--this FTN must be called AFTER context is created and made current:
	if SDL_TRUE = sdl_gl_extensionsupported(pms) then

		--multisamples are supported so reduce aliasing:

		put_line("MultSample is supported");
		error := SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 4);
		myassert( error = 0 ,1011 );

	SDL_GL_DeleteContext(mainGLContext);
	SDL_DestroyWindow(mainWindow);


		mainWindow := SDL_CreateWindow( To_C(name,true) , 
				SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
				width, height, flags);

		mainGLContext := SDL_GL_CreateContext(mainWindow);

		error := SDL_GL_MakeCurrent( mainWindow, mainGLContext );
		myassert( error = 0 ,1012 );

---------------------------------------------------------------------
		error := SDL_GL_GetAttribute(SDL_GL_MULTISAMPLESAMPLES,psampl'access);
		myassert( error = 0 ,1013 );
		put_line("psampl="&glint'image(psampl));   -- 4
---------------------------------------------------------------------

	else
		put_line("MultSample is NOT supported");
	end if;



	glgetintegerv(gl_major_version, major'address);
	glgetintegerv(gl_minor_version, minor'address);
	put_line("ogl-version-query:"&glint'image(major)&":"&glint'image(minor));



	glGetIntegerv(GL_CONTEXT_PROFILE_MASK, profile'address);
	if( profile = GL_CONTEXT_CORE_PROFILE_BIT ) then
		put_line("ogl-query:  Core Profile");
	end if;


	-- OSX currently requires the forward_compatible flag!
	glGetIntegerv(GL_CONTEXT_FLAGS, compflag'address);
	if( compflag = GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT ) then
		put_line("ogl-query:  Forward-Compatible bit is set");
	end if;



end InitSDL;











procedure first_prep is -- main program setup
      FileId : text_io.File_Type;
		ret: glint;
begin


	snd4ada_hpp.initSnds;

	fanfare := snd4ada_hpp.initSnd(
		Interfaces.C.Strings.New_String("data/fanfare.wav"),99);
	
	whoosh := snd4ada_hpp.initSnd(
		Interfaces.C.Strings.New_String("data/whoosh_4th.wav"),99);
	

	if fanfare<0 or whoosh<0 then
		put_line("snd4ada_hpp.initSnds ERROR");
		raise program_error;
	end if;




	playSecs := float( sdl_getticks ) / 1000.0;



------- begin SDL prep ---------------------------------------------------------

	ret := SDL_Init(SDL_INIT_VIDEO or SDL_INIT_EVENTS or SDL_INIT_TIMER);
	should_be_zero := SDL_GetCurrentDisplayMode(0, current'access);
	myassert( should_be_zero = 0 ,1012 );

	-- Note:  (current.w, current.h) = monitor size
	Mwid:=current.w;
	Mhit:=current.h;
	put_line( "Monitor: " 
		& interfaces.c.int'image(Mwid)&" X "
		& interfaces.c.int'image(Mhit) );



	contextFlags := 
		SDL_WINDOW_SHOWN 
		or SDL_WINDOW_OPENGL
		or SDL_WINDOW_RESIZABLE
		or SDL_WINDOW_ALLOW_HIGHDPI;

	Wwid:=Mwid/2;
	Whit:=Mhit/2;


	InitSDL(Wwid, Whit, contextFlags, "RufaSwap");

	--utex.inittext2d("data/rods3x.png", integer(Wwid),integer(Whit));
	utex.inittext2d("data/noto.png", integer(Wwid),integer(Whit));


	SDL_GL_GetDrawableSize( mainWindow, Fwid'access, Fhit'access );
	glViewport(0,0,Fwid,Fhit);


	key_map := sdl_getkeyboardstate(numkeys'access);
	--put_line("...numkeys=" & interfaces.c.int'image(numkeys) ); -- 512
	--myassert( sdl.keyrange'last <= numkeys );



	glgenvertexarrays(1, vertexarrayid'address );
	glbindvertexarray(vertexarrayid);

	glactivetexture(gl_texture0); -- moved here 5nov14 (outside main loop)

	glgenbuffers(1, vertbuff'address);
	glgenbuffers(1, uvbuff'address);
	glgenbuffers(1, elembuff'address);




	glenable(gl_depth_test);
	gldepthfunc( gl_lequal );
	glenable( gl_cull_face );


	glEnable(GL_MULTISAMPLE);
	glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

	glClearColor(0.5, 0.5, 0.5, 1.0);

end first_prep;











function signum( x : integer ) return integer is
begin
	if x>0 then
		return +1;
	elsif x<0 then
		return -1;
	else
		return 0;
	end if;
end signum;








function max( a, b : float ) return float is
begin
	if a>b then return a;
	else return b; end if;
end max;



MVP, ModelMatrix, ViewMatrix, ProjectionMatrix
	 : mat44 := identity;

procedure updateMVP( wid, hit : glint ) is
	xlook, ylook, zlook, xlk,ylk,zlk, xrt,yrt,zrt, xup,yup,zup : float;
	xme,yme,zme : float;

	woh : constant float := float(wid)/float(hit);
	how : constant float := float(hit)/float(wid);

	fovdeg : constant float := 45.0;
	fovrad : constant float := fovdeg*deg2rad;

	aspect : constant float := max(1.0,how);

	-- distance from eye so FOV encompasses proper field:
	eyeradius : constant float := aspect / fmath.tan(fovrad/2.0);

	horiAng : constant float := 0.0;
	near : constant float := 0.1;
	far  : constant float := 100.0;

	focus : constant vec3 := (0.0, -1.0, 0.0);
	eyepos: constant vec3 := (0.0, eyeradius-1.0 , 0.0);
	look  : constant vec3 := 
		( focus(1)-eyepos(1), focus(2)-eyepos(2), focus(3)-eyepos(3) );
	vertAng : constant float := fmath.arctan( look(2), look(3) );

begin

	ModelMatrix:=identity;
	--scale width versus height so pic fills window:
	if woh>1.0 then
		ModelMatrix(1,1):=woh;
	else
		ModelMatrix(3,3):=how;
	end if;

	xme:=eyepos(1);
	yme:=eyepos(2);
	zme:=eyepos(3);

	-- look direction:
	xlook := fmath.cos(vertang)*fmath.sin(horiang);
	ylook := fmath.sin(vertang);
	zlook := fmath.cos(vertang)*fmath.cos(horiang);

	xlk := xme+xlook;
	ylk := yme+ylook;
	zlk := zme+zlook;

	-- Right unit-Direction
	xrt:= fmath.sin(horiang-halfpi);
	yrt:= 0.0;
	zrt:= fmath.cos(horiang-halfpi);

	-- calculate UP unit-Direction
	cross( xrt,yrt,zrt, xlook,ylook,zlook, xup,yup,zup );

	perspective(ProjectionMatrix, fovdeg, woh,  near, far);

	lookat(ViewMatrix, xme,yme,zme, xlk,ylk,zlk, xup,yup,zup );

	MVP:=ModelMatrix;
	matXmat(MVP,ViewMatrix);
	matXmat(MVP,ProjectionMatrix);

end updateMVP;









procedure release_stuff is -- prepare to close down
begin

	glext.binding.glDeleteBuffers(1, vertbuff'address);
	glext.binding.glDeleteBuffers(1, uvbuff'address);
	glext.binding.glDeleteBuffers(1, elembuff'address);

	glext.binding.glDeleteProgram( pgmtexshadid );

	glext.binding.glDeleteVertexArrays(1, vertexarrayid'address);

end release_stuff;


procedure setup_stuff is  -- prepare dungeon textures
begin 

	pgmtexshadid := loadshaders("./data/texobj.vs", "./data/texobj.fs");
	matid := glgetuniformlocation(pgmtexshadid, pmvp);
	uniftex  := glgetuniformlocation(pgmtexshadid, pmyts);

end setup_stuff;












ppreviousTime : float := float(sdl_getticks)/1000.0;

pselBlockA, pselBlockB : integer := -1;

procedure handle_mouse_pick( 
	width, height : glint;
	xmouse, ymouse : glint ) is

 -- these coords have origin @ lower left of window:
 col : constant float := 1.0 - 2.0*float(xmouse)/float(width);
 row : constant float := 1.0 - 2.0*float(ymouse)/float(height);

 isel,k, i1,i2,s, j1,j2 : integer := -1;
 xok,zok : boolean;

begin

	for i in 1..np2 loop
	if isel<0 then
		k:=permut(i);
		xok := (xlo(k) <= col) and (col <= xhi(k));
		zok := (zlo(k) <= row) and (row <= zhi(k));
		if xok and zok then
			isel:=i;
		end if;
	end if;
	end loop;


	if isel >= 1  then

		if( isel = PselBlockA ) then --//undo pick
			PselBlockA:=-1;

		elsif( PselBlockA < 0 ) then
			PselBlockA:=isel;

		else
			PselBlockB:=isel;
		end if;


		if (PselBlockA>=1) and (PselBlockB>=1) then

			myassert( PselBlockA /= PselBlockB ,1013 );
			i1:=PselBlockA;
			i2:=PselBlockB;

			-- perform the swap:
			s:=permut(PselBlockA);
			permut(PselBlockA) := permut(PselBlockB);
			permut(PselBlockB) := s;

			PselBlockA:=-1;
			PselBlockB:=-1;

			snd4ada_hpp.playSnd(whoosh); -- whoosh



			j1:= permut(i1);
			j2:= permut(i2);

			partobj.setRect( subpic(i1), ycen,
					xlo(j1), xhi(j1), zlo(j1), zhi(j1), 
					ulo(i1), uhi(i1), vlo(i1), vhi(i1) );

			partobj.setRect( subpic(i2), ycen,
					xlo(j2), xhi(j2), zlo(j2), zhi(j2), 
					ulo(i2), uhi(i2), vlo(i2), vhi(i2) );


			winner:=true;
			for i in 1..np2 loop
				if( i /= permut(i) ) then winner:=false; end if;
			end loop;
			if winner then 
				put_line("WINNER");
				--SDL_Delay(200); --let swap sound finish before fanfare begins
				delay 0.2;
			end if;

		end if;

	end if; -- isel>=0


end handle_mouse_pick;







procedure scramble is
	r : Ada.Numerics.Float_Random.Uniformly_Distributed;
	n,s,k : integer;
begin


	for j in 1..99999 loop

		-- pick random n in 1..np2-1

		-- r in [0..1) :
		 r := Ada.Numerics.Float_Random.Random(G);


		-- n in 1..np2-1
		n := 1+integer( float(np2-1)*r );

		--assert( n<=np2-1 );
		if n>np2-1 then n:=np2-1; end if;
		myassert( n>=0 ,1014 );

		--swap n,n+1 :
		s:=permut(n);
		permut(n):=permut(n+1);
		permut(n+1):=s;
	end loop;

	for i in 1..np2 loop
		k:=permut(i);
		partobj.setRect( subpic(i), ycen,
			xlo(k), xhi(k), zlo(k), zhi(k), 
			ulo(i), uhi(i), vlo(i), vhi(i) );
	end loop;

	scrambled:=true;

end scramble;


--find m such that the interval width of
-- [lo(m), hi(m)] 
--is maximal, for m in 1..k
function maxInterval( lo, hi : cuttype; k: nprng ) return nprng is
	m: nprng:=nprng'first;
	fmax : float := hi(m)-lo(m);
begin
	for i in 1..k loop
		if hi(i)-lo(i) > fmax then
			m:=i; fmax:=hi(i)-lo(i);
		end if;
	end loop;
	return m;
end maxInterval;


--find a random point within the interval [lo+10%, hi-10%]
function randSlice( lo, hi : float ) return float is
	u, width, margin, offset, y : float;
	eps : constant float := 0.1; -- no slice smaller than this
begin

	u:= Ada.Numerics.Float_Random.Random(G); -- [0..1]

	width:=( hi - lo );
	margin:= width*eps; -- 10% of width

	offset:=( (hi-margin) - (lo+margin) ) * u;

	y := lo+margin + offset; -- [lo+e ... hi-e]

	return y;

end randSlice;


procedure setUparts( loh,hih, lov,hiv: in out cuttype ) is
-- define xlo,xhi,zlo,zhi, 1..nparts
	i,j,k: integer := 1;
	xx,zz : float;
begin

	i:=1;
	loh(i):=-1.0;
	hih(i):=1.0;
	while i<nparts loop
		k:=maxInterval(loh,hih,i);
		xx:=randSlice( loh(k), hih(k) );
		myassert( loh(k)<xx, 11);
		myassert( xx<hih(k), 12);
		for j in reverse k+1..i+1 loop
			hih(j):=hih(j-1);
			loh(j):=loh(j-1);
		end loop;
		loh(k+1):=xx;
		hih(k):=xx;
		i:=i+1;
	end loop; --horizontal partitions of [-1..1]

	i:=1;
	lov(i):=-1.0;
	hiv(i):=1.0;
	while i<nparts loop
		k:=maxInterval(lov,hiv,i);
		zz:=randSlice( lov(k), hiv(k) );
		myassert(lov(k)<zz, 13);
		myassert(zz<hiv(k), 14);
		for j in reverse k+1..i+1 loop
			hiv(j):=hiv(j-1);
			lov(j):=lov(j-1);
		end loop;
		lov(k+1):=zz;
		hiv(k):=zz;
		i:=i+1;
	end loop; --vertical partitions of [-1..1]

	--debug
	for i in 1..nparts-1 loop
		myassert( lov(i)<lov(i+1), 15 );
		myassert( hiv(i)<hiv(i+1), 16 );
		myassert( lov(i)<hiv(i), 17 );
	end loop;

--debug only
--for i in 1..nparts loop
--put(float'image(wlo(i))&":");
--end loop;
--put(float'image(whi(nparts)));
--put_line(integer'image(nparts));

end setUparts;


-- slice picture into nparts, both vertically and horizontally:
procedure subdivid is
	shrink : constant float := 0.99;
	xmx    : constant float := 1.0;
	zmx    : constant float := 1.0;
	fnp    : constant float := float(nparts);
	dx     : constant float := 2.0/fnp; --was 2/fnp
	dz     : constant float := 2.0/fnp; --was 2/fnp
	du     : constant float := 1.0/fnp;
	dv     : constant float := 1.0/fnp;
	k: integer := 0;
	uulo,uuhi,vvlo,vvhi,
	fi,fj, uu,vv, xc,zc, xd,zd : float;
	loh,hih,lov,hiv: cuttype;
begin

	myassert( nparts<=npmx, 1015 );
	myassert( nparts>=1 , 1016 );
	np2 := nparts*nparts;

	-- initialize permut
	for i in 1..np2 loop
		permut(i):=i;
	end loop;

	scrambled:=false;

--/////////// begin subdivision into np*np parts /////////////////

if uneven then

	setUparts(loh,hih,lov,hiv);

	for i in 1..nparts loop
		xd := hih(i)-loh(i);
		xc := -0.5*(hih(i)+loh(i));

		uulo := 0.5*(1.0+loh(i));
		uuhi := 0.5*(1.0+hih(i));

		for j in 1..nparts loop
			zd := hiv(j)-lov(j);
			zc := -0.5*(hiv(j)+lov(j));

			vvlo := 0.5*(1.0+lov(j));
			vvhi := 0.5*(1.0+hiv(j));

			k := k+1;

			-- position coords in [-1,1]
			xlo(k) := xc-shrink*xd/2.0;
			xhi(k) := xc+shrink*xd/2.0;
			zlo(k) := zc-shrink*zd/2.0;
			zhi(k) := zc+shrink*zd/2.0;

			-- texture coords in [0,1]
			ulo(k) := uuhi;
			uhi(k) := uulo;
			vlo(k) := vvlo;
			vhi(k) := vvhi;

		end loop;
	end loop;


--debug only
--for m in 1..np2 loop
--put_line(
--integer'image(m)&"::"&
--float'image(xlo(m))&":"&
--float'image(xhi(m))&":"&
--float'image(zlo(m))&":"&
--float'image(zhi(m))
--);
--end loop;
--debug only


else -- even partitions

	for i in 1..nparts loop
		fi := float(i-1);
		xc := xmx - fi*dx - dx/2.0;
		uu := fi*du;

		for j in 1..nparts loop
			fj := float(j-1);
			zc := zmx - fj*dz - dz/2.0;
			vv := fj*dv;

			k := k+1;

			-- position coords [-1,1]
			xlo(k) := xc-shrink*dx/2.0;
			xhi(k) := xc+shrink*dx/2.0;
			zlo(k) := zc-shrink*dz/2.0;
			zhi(k) := zc+shrink*dz/2.0;

			-- texture coords in [0,1]
			ulo(k) := uu+du;
			uhi(k) := uu;
			vlo(k) := vv;
			vhi(k) := vv+dv;

		end loop;
	end loop;

end if;



	for i in 1..np2 loop
		k := permut(i); -- Yes, k=i, this merely shows intent for later
		partobj.setRect( subpic(i), ycen,
			xlo(k), xhi(k), 
			zlo(k), zhi(k), 
			ulo(i), uhi(i), 
			vlo(i), vhi(i) );
	end loop;

--/////////// end subdivision into np*np parts ///////////////

end subdivid;





function odd( i: integer ) return boolean is
begin
	return ( i mod 2 = 1 );
end odd;













procedure loadPic( infilname : string ) is
	margin : constant glint := 120;
	shrink : float;
	wid,hit : glint;
	dbug : boolean := false;
	--dbug : boolean := true;
begin


--////// load picture begin //////////////////////////////////////


	pic_texid := loadPng( repeat, infilname, Wwid, Whit, dbug ); 
	--best match to cpp version used in swap.cc
	-- updated function now allows either RGB or RGBA modes



	shrink:=1.0;
	wid:=Wwid;
	hit:=Whit;
	while (wid+margin>Mwid) or (hit+margin>Mhit)  loop
		--proportionally shrink until pic fits screen
		shrink := shrink*0.9;
		wid := glint( float(Wwid)*shrink );
		hit := glint( float(Whit)*shrink );
	end loop;

	Wwid:=wid;
	Whit:=hit;

	--put_line( "loadPic.adjusted: Wwid-X-Whit : "
	--	&interfaces.c.int'image(Wwid)&" X "
	--	& interfaces.c.int'image(Whit) );


	updateMVP( Wwid, Whit );


	SDL_SetWindowSize( mainWindow, Wwid,Whit );
	SDL_SetWindowPosition(mainWindow, 
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED);
	SDL_GL_GetDrawableSize( mainWindow, Fwid'access, Fhit'access );
	glViewport(0,0, Fwid,Fhit);

	--put_line( "loadPic.Drawable: Fwid-X-Fhit : "
	--	&interfaces.c.int'image(Fwid)&" X "
	--	& interfaces.c.int'image(Fhit) );

--////// load picture end //////////////////////////////////////

	subdivid;

end loadPic;






function bitmatch( x, y : integer ) return boolean is
	result : boolean := false;
	a : integer := x;
	b : integer := y;
begin
	for i in 1..32 loop
		if ( odd(a) and odd(b) ) then result:=true; end if;
		a:=a/2;
		b:=b/2;
	end loop;
	return result;
end;






	use ada.directories;

	alt : boolean;

	pdlay : constant float := 0.20; --mousePickDelay interval

	search : search_type;
	directory_entry : directory_entry_type;
	npic, totpic : integer := 0;

	sName : unbounded_string;
	maxNpics : constant integer := 20;
	picname, shortname : array(1..maxNpics) of unbounded_string;
	pname : unbounded_string;


begin -- rufaswap

	Ada.Numerics.Float_Random.Reset(G); --randomize (time-dependent)

	-- find *.png files under ./pix/

	put_line("Here are the pictures found under ./pix/ :");
	totpic:=0;
	start_search( search, "./pix/",	"*.png" );
	while more_entries( search ) loop
		get_next_entry( search, directory_entry );
		totpic:=totpic+1;
		myassert( totpic <= maxNpics ,1017 );
		picname(totpic)  := to_unbounded_string( full_name( directory_entry ) );
		shortName(totpic):= to_unbounded_string( simple_name(directory_entry) );
		put_line( shortName(totpic) );
	end loop;
	put_line("...for a total of totpic="&integer'image(totpic));
	new_line;

	-- defaults:
	nparts:=2;
	npic:=1;

--put("...looking for: ");
--put_line(savename);
	if ada.directories.Exists(savename) then
	declare
      FileId : text_io.File_Type;
		xtotpic, xnpic, xnparts : integer;
		last: natural;
		linestr: string(1..9);
   begin
      text_io.Open
         (File => FileId,
          Mode => text_io.In_File,
          Name => savename);

--very annoying...won't read [dos] files so...

		--ada.integer_text_io.get(FileId, xtotpic);
		text_io.get_line(FileId, linestr, last);
		ada.integer_text_io.get(linestr, xtotpic, last);
--put_line(integer'image(xtotpic)); --19

		--ada.integer_text_io.get(FileId, xnpic);
		text_io.get_line(FileId, linestr, last);
		ada.integer_text_io.get(linestr, xnpic, last);
--put_line(integer'image(xnpic));

		--ada.integer_text_io.get(FileId, xnparts);
		text_io.get_line(FileId, linestr, last);
		ada.integer_text_io.get(linestr, xnparts, last);
--put_line(integer'image(xnparts));


      text_io.Close
         (File => FileId);

		if 
			xtotpic=totpic
			and
			xnpic>=1
			and
			xnpic<=xtotpic
			and
			xnparts>=2
			and
			xnparts<=npmx
		then
			npic:=xnpic;
			nparts:=xnparts;
		end if;

	end; --declare
	end if;

	-- keep np2 in synch:
	np2 := nparts*nparts;





	first_prep; -- init graphics/sound, defines fnum, flev

	setup_stuff;


	--initialize pic
	sname:=shortname(npic);
	pname:=picname(npic);
	loadPic( to_string(pname) );
	keytime:=currentTime;
	declare
		cptr : chars_ptr := 
			new_string( to_string(sname) &"     ...type <h> for Help");
		title : interfaces.c.char_array := value(cptr);
	begin
		SDL_SetWindowTitle(mainWindow, title);
	end; --declare




	currentTime := float(sdl_getticks)/1000.0;
	ppreviousTime := currentTime;


	updateMVP( Wwid, Whit );


	-- main event loop begin: -----------------------------------------------
   while not userexit loop

------- begin response to keys -----------------------------------------------

		currentTime := float(sdl_getticks)/1000.0;

		SDL_PumpEvents;
		key_map := sdl_getkeyboardstate(numkeys'access);


		-- these are only 2 keyboard responses needed in level=5 (epilogue)
		if( key_map( SDL_SCANCODE_ESCAPE ) /= 0 ) then userexit:=true; end if;
		if( key_map( SDL_SCANCODE_Q ) /= 0 ) then userexit:=true; end if;

		etime:=currentTime-keytime;

		
		if( key_map( SDL_SCANCODE_H )  /= 0 ) then --Help toggle
			if etime>dwell then
				help:= not help;
				keytime:=currentTime;
			end if;

		elsif( key_map( SDL_SCANCODE_X )  /= 0 ) then --Help toggle
			if etime>dwell then
				details:= not details;
				keytime:=currentTime;
			end if;


		elsif( key_map( SDL_SCANCODE_U )  /= 0 ) then --UnEven toggle
			if etime>dwell then
				uneven:= not uneven;
				--loadPic( to_string(pname) );
				subdivid;
				keytime:=currentTime;
			end if;


		elsif( key_map( SDL_SCANCODE_F )  /= 0 ) then --Fewer partitions
			if etime>dwell then
				nparts := nparts-1;
				if nparts<2 then nparts:=2; end if;
				-- keep np2 in synch:
				np2 := nparts*nparts;

				subdivid;
				keytime:=currentTime;
			end if;

		elsif( key_map( SDL_SCANCODE_M )  /= 0 ) then -- More partitions
			if etime>dwell then
				nparts := nparts+1;
				if nparts>npmx then nparts:=npmx; end if;
				-- keep np2 in synch:
				np2 := nparts*nparts;

				subdivid;
				keytime:=currentTime;
			end if;

		elsif( key_map( SDL_SCANCODE_P )  /= 0 ) then --Previous image
			if etime>dwell then
				npic := npic-1;
				if npic<1 then npic:=totpic; end if;
				sname:=shortname(npic);
				pname:=picname(npic);
				loadPic( to_string(pname) );
				keytime:=currentTime;

				declare 
					cptr : chars_ptr := 
						new_string( to_string(sname) &"     ...type <h> for Help");
					title : interfaces.c.char_array := value(cptr);
				begin
					SDL_SetWindowTitle(mainWindow, title);
				end; --declare

			end if;

		elsif( key_map( SDL_SCANCODE_N )  /= 0 ) then --Next image
			if etime>dwell then
				npic := npic+1;
				if npic>totpic then npic:=1; end if;
				sname:=shortname(npic);
				pname:=picname(npic);
				loadPic( to_string(pname) );
				keytime:=currentTime;
				
				declare
					cptr : chars_ptr := 
						new_string( to_string(sname) &"     ...type <h> for Help");
					title : interfaces.c.char_array := value(cptr);
				begin
					SDL_SetWindowTitle(mainWindow, title);
				end; --declare

			end if;

		elsif( key_map( SDL_SCANCODE_RETURN )  /= 0 ) then --scramble
			if etime>dwell then
				scramble;
				keytime:=currentTime;
			end if;

		end if;





		MouseState:=SDL_GetMouseState(mousex'access,mousey'access);
		state := integer( MouseState );
		ileft := integer( SDL_BUTTON(1) );
		iright:= integer( SDL_BUTTON(3) );
		if    bitmatch(state, ileft)   then 
			if (currentTime - ppreviousTime) > pdlay then
				handle_mouse_pick(Wwid,Whit, mousex, mousey);
				ppreviousTime := currentTime;
			end if;
		end if;






----///////////////////// end response to key/mouse




-- perhaps we should maintain aspect ratio ?
-------- here we handle user-resized window ----------------------
		SDL_GetWindowSize( mainWindow, Nwid'access, Nhit'access );
		if( (Nwid /= Wwid) or (Nhit /= Whit) ) then
			Wwid:=Nwid;  Whit:=Nhit;
			SDL_GL_GetDrawableSize( mainWindow, Fwid'access, Fhit'access );
			glViewport(0,0,Fwid,Fhit);
		end if;


		updateMVP( Wwid, Whit );

		--------- begin drawing =============================

		glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);



		-- use this to draw ordinary textured objects:
		glUseProgram(pgmTexShadID);
		glUniformMatrix4fv(MatID, 1, GL_FALSE, MVP(1,1)'address);
		glUniform1i(uniftex, 0);

		glBindTexture(GL_TEXTURE_2D, pic_texid);

		for k in 1..np2 loop
			if pselblockB<0 and pselblockA=k then
				alt:=true;
			else
				alt:=false;
			end if;
			partobj.draw(subpic(k),vertbuff,uvbuff,elembuff,alt);
		end loop;







		--// drawing completed /////////////////////////////////////////////////


		if help  then

			utex.print2d("RufaSwap Help",      0.05, 0.90, 20);

			utex.print2d("<esc> to quit",      0.05, 0.80, 20);
			utex.print2d("<n>   next pic",     0.05, 0.75, 20);
			utex.print2d("<p>   prev pic",     0.05, 0.70, 20);

			utex.print2d("<m>   more slices",  0.05, 0.55, 20);
			utex.print2d("<f>  fewer slices",  0.05, 0.50, 20);
			utex.print2d("<u>  uneven slices",  0.05, 0.45, 20);

		elsif details then

			-- intent is to show technical details here so that I can track
			-- down the antialiasing problem under OS-X in case a MacBundle
			-- is used rather than the command line version.

			utex.print2d(" Ndim: " &
				interfaces.c.int'image(Nwid)&" X "
				& interfaces.c.int'image(Nhit), 0.05, 0.8, 15 );

			utex.print2d(" hdpi: " &
				interfaces.c.int'image(Fwid)&" X "
				& interfaces.c.int'image(Fhit), 0.05, 0.7, 15 );


--------- begin OGL queries -----------------------------------------

			glGetIntegerv(GL_CONTEXT_PROFILE_MASK, profile'address);
			if( profile = GL_CONTEXT_CORE_PROFILE_BIT ) then
				utex.print2d("ogl-query:  Core Profile", 0.02, 0.6, 10);
			end if;

			-- Note that OSX currently requires the forward_compatible flag!
			glGetIntegerv(GL_CONTEXT_FLAGS, flags'address);
			if( flags = GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT ) then
				utex.print2d("ogl-query:  Forward-Compatible bit is set", 0.02, 0.5, 10);
			end if;

			glgetintegerv(gl_major_version, major'address);
			glgetintegerv(gl_minor_version, minor'address);
			utex.print2d( "ogl-query: OGL-major: "&glint'image(major), 0.02, 0.4, 10);
			utex.print2d( "ogl-query: OGL-minor: "&glint'image(minor), 0.02, 0.3, 10);

			glgetintegerv(gl_max_texture_units, mtu'address);
			utex.print2d( "ogl-query: maxTexUnits: "&glint'image(mtu), 0.02, 0.2, 10);

			glgetintegerv(gl_max_texture_image_units, mtu'address);
			utex.print2d( "ogl-query: maxTexImgUnits: "&glint'image(mtu), 0.02, 0.13, 10);

			glgetintegerv(gl_max_combined_texture_image_units, mtu'address);
			utex.print2d( "ogl-query: maxCombTexImgUnits: "&glint'image(mtu), 0.02, 0.06, 10);


--------- end OGL queries -----------------------------------------





		end if;



		if not scrambled then
			utex.print2d("Hit <enter> to Scramble",    0.05,0.25,20);

		elsif winner then

			utex.print2d("Correct!",    0.25,0.5,60);

			if not playedonce  then
				snd4ada_hpp.playSnd(fanfare); -- fanfare

				playedonce:=true;
				playSecs := float(SDL_GetTicks) / 1000.0;
			end if;

			elapsedSec := float(SDL_GetTicks)/1000.0 - playSecs;
			if elapsedSec > 5.0 then winner:=false; end if;

		else
			playedonce:=false;
		end if;

		SDL_GL_SwapWindow( mainWindow );


   end loop; --------------------------- main event loop end -------------------


	declare
      FileId : text_io.File_Type;
   begin
      text_io.Create
         (File => FileId,
          Mode => text_io.Out_File,
          Name => savename);

		put_line(FileId, integer'image(totpic) );
		put_line(FileId, integer'image(npic) );
		put_line(FileId, integer'image(nparts) );
		new_line(FileId);

      text_io.Close
         (File => FileId);

	end; --declare


	snd4ada_hpp.termSnds;

	release_stuff;

	utex.cleanuptext;

	SDL_GL_DeleteContext(mainGLContext);
	SDL_DestroyWindow(mainWindow);

	SDL_Quit;

end rufaswap;

