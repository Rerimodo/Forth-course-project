: even? ( n -- [n % 2 = 0] )
	2 % 0 = ;

: prime? ( n -- res )
	dup 2 <         ( n [n<2] )
	if drop 0       ( 0 )
	else
		1 >r        ( n | i )
		repeat 
			dup     ( n n | i )
			r>      ( n n i )
			1 +     ( n n [i+1] )
			dup     ( n n [i+1] [i+1] )
			>r      ( n n [i+1] | [i+1] )
			% 0 =   ( n [n % [i+1] = 0] | [i+1])
		until 
		r>          ( n i )
		=           ( res )
	then ;

: prime?-allot ( n -- addr )
	prime? 1 allot dup rot swap ! ;

: concatenate ( s1 s2 -- s12 )
	2dup count swap count + 1 +     ( s1 s2 [l12+1] )
	heap-alloc                      ( s1 s2 s12 )
	-rot swap rot                   ( s2 s1 s12 )
	dup >r 	                        ( s2 s1 s12 | s12 )
	dup rot                         ( s2 s12 s12 s1 | s12 )
	dup count >r                    ( s2 s12 s12 s1 | s12 l1 )
	string-copy r>                  ( s2 s12 l1 | s12 )
	+ swap 	                        ( [s12 + l1] s2 | s12 ) 
	string-copy r> ;                ( s12 )

: divsqr? ( a b -- [a = k * b^2] ) 
	2dup % 0 =  ( a b r1 )
	-rot        ( r1 a b ) 
	dup         ( r1 a b b ) 
	-rot        ( r1 b a b ) 
	/           ( r1 b a/b ) 
	swap        ( r1 a/b b ) 
	% 0         ( r1 [a/b]%b 0) 
	= land ;
 
: primary? 
	1 swap 2                    ( res n i )
    repeat  
        2dup divsqr?            ( res n i r1 ) 
		if 
            rot                 ( n i res )
            drop 0              ( n i 0 )
            -rot 1              ( 0 n i 1 )
        else
       		2dup % 0 =          ( res n i [n%i = 0] )
            if 
                dup             ( res n i i )
                -rot            ( res i n i )
                /               ( res i [n/i] )
                swap            ( res [n/i] i )
            then 
            1 + swap dup 1 =    ( res [i+1] n [n=1] )
       		-rot swap rot       ( res n [i+1] [n=1])
        then 
    until 
    drop drop ;
