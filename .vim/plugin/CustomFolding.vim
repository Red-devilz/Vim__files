" Customized version of folded text, idea by 
" http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
fu! CustomFoldText(string) "{{{1

	
	" Add a few spaces for indentation
	let indent_level = indent(v:foldstart)
    let indent_spaces = repeat(' ',indent_level)
	
	" get first non-blank line
	" let fs = v:foldstart
	" while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
	" endwhile
	
	" Get the first non empty fold line
	" if fs > v:foldend
        let line = getline(v:foldstart)
		let line = substitute(line, '^\t*', '','g')
		let line = substitute(line, '^\s*', '','g')
		
    " else
        " let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    " endif

    " let pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
    " " remove leading comments from line
    " let line = substitute(line, '^\s*'.pat.'\s*', '', '')
    " " remove foldmarker from line
    " let pat  = '\%('. pat. '\)\?\s*'. split(&l:fmr, ',')[0]. '\s*\d\+'
    " let line = substitute(line, pat, '', '')

	"   let line = substitute(line, matchstr(&l:cms,
	"	    \ '^.\{-}\ze%s').'\?\s*'. split(&l:fmr,',')[0].'\s*\d\+', '', '')

    if get(g:, 'custom_foldtext_max_width', 0)
	let w = g:custom_foldtext_max_width - &foldcolumn - (&number ? 8 : 0)
    else
	let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    endif
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = '+'. v:folddashes
    let lineCount = line("$")
    if has("float")
	try
	    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
	catch /^Vim\%((\a\+)\)\=:E806/	" E806: Using Float as String
	    let foldPercentage = printf("[of %d lines] ", lineCount)
	endtry
    endif

    if exists("*strwdith")
	let expansionString = repeat(a:string, w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    else
	let expansionString = repeat(a:string, w - strlen(substitute(foldSizeStr.line.foldLevelStr.foldPercentage, '.', 'x', 'g')))
    endif

    return  indent_spaces . line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf

set foldtext=CustomFoldText('.')
" set foldtext = MyFoldText()
