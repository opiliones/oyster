#!/bin/sh

DIR=${0%/*}
. $DIR/../oyster

test_stack() {
  test "$1" = "`p`" || {
    echo expect "$1", but "`p`"
    exit 1
  }

  echo OK
  oyster-reset
}

push 1 push 2
test_stack ', 1 , 2 '

, 2 , 1
test_stack ', 2 , 1 '

, a dup , 1
test_stack ', a , a , 1 '

, "1  1" , 2 swap , a
test_stack ', 2 , 1  1 , a '

a=`, "1  1 " , a cmd printf '@%s@%s@'`
, "$a"
test_stack ', @1  1 @a@ '

a=`, a , " 1 1  " cmd1 printf '@%s@'`
, "$a"
test_stack ', @ 1 1  @ '

a=`, a , " 1 1  " cmd2 printf '@%s@%s@'`
, "$a"
test_stack ', @a@ 1 1  @ '

, 3 , 2 , 1 , plus dip , a
test_stack ', 5 , 1 , a '

, 3 , 2 , 1 dip_ 'plus_ 1 mul' , a
test_stack ', 9 , 1 , a '

, 3 , 2 , 1 , plus i , a
test_stack ', 3 , 3 , a '

, 3 , 2 , 1 i_ 'plus x -1' , a
test_stack ', 3 , -3 , a '

, 3 , dup , 4 rep , a
test_stack ', 3 , 3 , 3 , 3 , 3 , a '

, 3 rep_ dup 4 , a
test_stack ', 3 , 3 , 3 , 3 , 3 , a '

, b , 1 , 1 eq , a
test_stack ', b , 0 , a '

, b , 1 eq_ 0 , a
test_stack ', b , 1 , a '

, b , 1 , 1 ne , a
test_stack ', b , 1 , a '

, b , 1 ne_ 0 , a
test_stack ', b , 0 , a '

, b , 1 , 0 gt , a
test_stack ', b , 0 , a '

, b , 1 gt_ 1 , a
test_stack ', b , 1 , a '

, b , 1 , 0 ge , a
test_stack ', b , 0 , a '

, b , 1 ge_ 1 , a
test_stack ', b , 0 , a '

, b , 1 , 2 lt , a
test_stack ', b , 0 , a '

, b , 1 lt_ 1 , a
test_stack ', b , 1 , a '

, b , 1 , 2 le , a
test_stack ', b , 0 , a '

, b , 1 le_ 1 , a
test_stack ', b , 0 , a '

, b , 0 , 0 and , 1 , 0 and , 0 , 2 and , 3 and_ 4
test_stack ', b , 0 , 1 , 1 , 1 '

, b , 0 , 0 or , 1 , 0 or , 0 , 2 or , 3 or_ 4
test_stack ', b , 0 , 0 , 0 , 1 '

, b , 1 not not_ 0 , a
test_stack ', b , 0 , 1 , a '

, b , 1 , 1 plus , 1 + 1 , a
test_stack ', b , 2 , 2 , a '

, b , 2 , 1 minus , 2 - 1 , a
test_stack ', b , 1 , 1 , a '

, b , 2 , 3 mul , 2 x 3 , a
test_stack ', b , 6 , 6 , a '

, b , 6 , 2 div , 6 y 2 , a
test_stack ', b , 3 , 3 , a '

, b , 6 , 5 mod , 6 % 5 , a
test_stack ', b , 1 , 1 , a '

#, b , 2 , 10 pow , 2 ^ 10 , a
#test_stack ', b , 1024 , 1024 , a '

, b , 5 , 'dup , 1 le' , '' , 'dup , 1 minus' , mul linrec , a
test_stack ', b , 120 , a '

, b , 5 linrec_ 'dup le_ 1' '' 'dup - 1' mul , a
test_stack ', b , 120 , a '

, b , 5 , 'dup , 1 le' , '' , ', 1 minus' tailrec , a
test_stack ', b , 1 , a '

, b , 5 tailrec_ 'dup , 1 le' '' ', 1 minus' , a
test_stack ', b , 1 , a '

, b , 6 , 'dup , 2 le' , 'pop , 1' , ', 1 minus dup , 1 minus' , plus binrec , a
test_stack ', b , 8 , a '

, b , 6 binrec_ 'dup le_ 2' 'pop , 1' '- 1 dup - 1' plus , a
test_stack ', b , 8 , a '

, b , 0 , 1 , 2 ? , a
test_stack ', b , 1 , a '

, b , 1 ?_ 1  2 , a
test_stack ', b , 2 , a '

, b , 0 , ', 1' , ', 2' ifel , a
test_stack ', b , 1 , a '

, b , 1 ifel_ ', 1'  ', 2' , a
test_stack ', b , 2 , a '

, b , 0 , ', 1' when , a
test_stack ', b , 1 , a '

, b , 1 when_ ', 1' , a
test_stack ', b , a '

, b , " " , a var , a
, "$a"
test_stack ', b , a ,   '

, b , " " var_ b , a
, "$b"
test_stack ', b , a ,   '

, b , a readvar , a
test_stack ', b ,   , a '

, b readvar_ b , a
test_stack ', b ,   , a '

, b , " b ' ' " esc , a
test_stack ", b , ' b '\'' '\'' ' , a "

, b esc_ " b ;  ' " , a
test_stack ", b , ' b ;  '\'' ' , a "

, b , "%Gihi'i6#::k,pjp" strlen , a
test_stack ', b , 16 , a '

, b strlen_ "%Gihi'i6#::k,pjp" , a
test_stack ', b , 16 , a '

, b , "a'b" , "a*" match , a
test_stack ', b , 0 , a '

, b , "a'b" , "a\\'?" match , a
test_stack ', b , 0 , a '

, b , "a'b" , "a'b" esc match , a
test_stack ', b , 0 , a '

, b , "a'b'c" , "*\\'" stripll , a
test_stack ', b , c , a '

, b , "a'b'c" , "*\\'" stripls , a
test_stack ", b , b'c , a "

, b , "a'b'c" , "\\'*" striprl , a
test_stack ', b , a , a '

, b , "a'b'c" , "\\'*" striprs , a
test_stack ", b , a'b , a "
#"

, b , "SG$&)'+&*" , 2 , 4 substr , a
test_stack ", b , $&)' , a "

, b , "SG$&)'+&*" , "?&" , @ gsub , a
test_stack ", b , SG@)'@* , a "

, b , "SG$&)'+&*" , "?&" , "'" sub , a
test_stack ", b , SG')'+&* , a "

, b , " " unit , a
test_stack ", b , ' '  , a "

, b ,[ 1 , 2 , 3 ] init , a
test_stack ", b , 1 2  , a "

, b ,[ 1 , 2 , 3 ] last , a
test_stack ', b , 3 , a '

, b ,[ 1 , 2 , 3 ] head , a
test_stack ', b , 1 , a '

, b ,[ 1 , 2 , 3 ] tail , a
test_stack ', b , 2 3  , a '

, b ,[ 1 , 2 , 3 ] , 4 add , a
test_stack ', b , 1 2 3 4  , a '

, b ,[ 1 , 2 , 3 ] , 0 cons , a
test_stack ', b , 0 1 2 3  , a '

, b ,[ 1 , 2 , 3 , 4 ] , -3 , 2  range , a
test_stack ', b , 2 3  , a '

, b ,[ 1 , 2 , 3 ] , 0 index , a
test_stack ', b , 1 , a '

, b ,[ 1 , 2 , 3 ] , 0 has , a
test_stack ', b , 1 , a '

, b ,[ 1 , 2 , 3 ] , 2 has , a
test_stack ', b , 0 , a '

, b ,[ 1 , 2 , 3 ] , 0 drop , a
test_stack ', b , 1 2 3  , a '

, b ,[ 1 , 2 , 3 ] , 1 drop , a
test_stack ', b , 2 3  , a '

, b ,[ 1 , 2 , 3 ] , 0 take , a
test_stack ', b ,  , a '

, b ,[ 1 , 2 , 3 ] , 3 take , a
test_stack ', b , 1 2 3  , a '

, b ,[ 1 , 2 , 3 ] ,[ 4 , 5 ] concat , a
test_stack ', b , 1 2 3 4 5  , a '

, b , " this is  a pen " words , a
test_stack ', b , this is a pen  , a '

, b ,[ this , is , a , pen ] uwords , a
test_stack ', b , this is a pen , a '

, b , " this is  a pen " , s sep , a
test_stack ", b , ' thi' ' i' '  a pen '  , a "

, b ,[ this , is , a , pen ] , "  " usep , a
test_stack ', b , this  is  a  pen , a '

, b ,[ this , is , a , pen ] , "dup match_ '*s*'" filter , a
test_stack ', b , this is  , a '

, b , 0 ,[ 1 , 2 , 3 ] , 'plus' fold , a
test_stack ', b , 6 , a '

, b ,[ this , is , a , pen ] , "strcat_ '_'" map , a
test_stack ', b , this_ is_ a_ pen_  , a '

, b ,[ this , is , a , pen ] , 2 , not ins , a
test_stack ', b , this is not a pen  , a '

, b ,[ this , is , a , pen ] , 0 , that ch , a
test_stack ', b , that is a pen  , a '

, b ,[ this , is , a , pen ] , 2 del , a
test_stack ', b , this is pen  , a '

, b ,[[ apple , 1 ] ,[ orange , 2 ] ,[ banana , 3 ]] , orange lookup , a
test_stack ', b , 2 , a '

