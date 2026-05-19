" 
" Keep versions of files in EECS 482 github repos
"
" return relative time
function version482#RelTime()
    return(reltimestr(reltime())->substitute('\.\(...\).*', '\1', '') / 1000)
endfunction
let $TZ='America/Detroit'
let $SSH_ASKPASS='echo'
let $SSH_ASKPASS_REQUIRE='force'
let s:startTimeAbs = localtime()
let s:startTimeRel = version482#RelTime()
" return absolute time
function version482#Time()
    return(s:startTimeAbs + (version482#RelTime() - s:startTimeRel))
endfunction
let s:version = 'vim-20251011'
let s:minTimeInterval = 10      " minimum time between versions
let s:minTagInterval = 60       " minimum time between tags/pushes
let s:maxAge = 60*60            " maximum age of version482 file
let s:maxSize = 50*1024*1024    " maximum size of version482 file
let s:username = substitute($USER, "[^a-zA-Z0-9]", "", "g")
let s:hash = {}                 " last hash value for each version file
let s:size = {}                 " last size for each version file
let s:prior = {}                " prior contents for each file
let s:priorTime = {}            " last time each file was written
let s:priorTag = {}             " last time each repo was tagged
let s:sessionStart = version482#Time()
let s:hashInitial = sha256(s:username . ' ' . s:sessionStart)
let s:timerStarted = 0
let s:tagTimerStarted = 0
let s:versionDir = {}   " .version482 directory name for each source file directory
let s:proj = {}         " project for each source file directory
autocmd BufReadPost * call version482#NewBuffer()
autocmd BufWritePre * call version482#Save()
autocmd TextChanged,TextChangedI * call version482#TextChanged()
" see if directory is in an EECS 482 git repo
" store .version482 directory name in s:versionDir, and make sure the
" .version482 directory exists
function version482#InitVersionDir(dirname)
    if has_key(s:versionDir, a:dirname)
        return
    endif
    let s:versionDir[a:dirname] = ''
    " Get top level of working tree
    let l:top = systemlist('cd "' . a:dirname . '" ; git rev-parse --show-toplevel')[0]
    if v:shell_error
        return
    endif
    " Get name of main repo and make sure it's not a version482 repo
    let l:out = system('cd "' . a:dirname . '" ; git remote -v | grep "eecs482.*(push)" | tail -n 1')
    if stridx(l:out, 'version482') >= 0
        " in a version482 repo
        return
    endif
    let l:matches = matchlist(l:out, '\(eecs482/[a-z.]*\)\.\(\d\d*\)')
    if (empty(l:matches))
        return
    endif
    let s:proj[a:dirname] = l:matches[2]
    let l:repo = l:matches[1] . '.' . s:proj[a:dirname]
    " echo 'l:repo=' . l:repo . ', s:proj[' . a:dirname . ']=' . s:proj[a:dirname]
    let s:versionDir[a:dirname] = fnamemodify(l:top, ':p') . '.version482'
    if s:proj[a:dirname] =~ '[012]'
        " initialize Project 0-2 .version482 directory
        if ! isdirectory(s:versionDir[a:dirname])
            " try to make the .version482 directory
            call mkdir(s:versionDir[a:dirname])
            if ! isdirectory(s:versionDir[a:dirname])
                let s:versionDir[a:dirname] = ''
            endif
        endif
    else
        " clone Project 3-4 .version482 repo if needed
        if ! isdirectory(s:versionDir[a:dirname])
            call system('cd "' . l:top . '" ; git clone git@github.com:' . l:repo . '.version482 .version482')
        endif
        if ! isdirectory(s:versionDir[a:dirname])
            " Couldn't clone .version482 repo
            let s:versionDir[a:dirname] = ''
            return
        endif
        " Make sure version482 is in its own repo
        let l:version482_top = systemlist('cd "' . s:versionDir[a:dirname] . '" ; git rev-parse --show-toplevel')[0]
        if v:shell_error
            let s:versionDir[a:dirname] = ''
            return
        endif
        if l:version482_top == l:top
            " version482 is part of the main project repository
            let s:versionDir[a:dirname] = ''
            return
        endif
        " compute correct branch for this local repo
        let l:branch = s:username . system('uname -s')
        if filereadable('/etc/os-release')
            let l:branch .= systemlist('cat /etc/os-release | grep "^ID=" | sed "s/^.*=//"')[0]
        endif
        let l:branch .= l:top
        let l:branch = substitute(l:branch, "[^a-zA-Z0-9]", "", "g")
        " am I on the correct branch?
        let l:branch1 = trim(system('cd "' . s:versionDir[a:dirname] . '"; git branch --show-current'))
        if l:branch1 != l:branch
            " try to create the branch
            call system('cd "' . s:versionDir[a:dirname] . '"; git checkout -b ' . l:branch)
            if v:shell_error
                " git checkout -b fails if the branch already exists locally
                " Try checking out the existing branch.
                call system('cd "' . s:versionDir[a:dirname] . '"; git checkout ' . l:branch)
            else
                " git checkout -b worked.  Try pulling from remote, in case
                " branch already exists on remote
                call system('cd "' . s:versionDir[a:dirname] . '"; git pull origin ' . l:branch)
                " add upstream reference to github
                call system('cd "' . s:versionDir[a:dirname] . '"; git push --set-upstream origin ' . l:branch)
            endif
            if v:shell_error
                let s:versionDir[a:dirname] = ''
                return
            endif
        endif
    endif
endfunction
function version482#NewBuffer()
    if ! has('nvim')
        " helps remove display glitches on startup
        sleep 100m
    endif
    call version482#InitVersionDir(fnamemodify(expand('%'), ':p:h'))
endfunction
function version482#TextChanged(...)
    let l:now = version482#Time()
    let l:filename = fnamemodify(expand('%'), ':p')
    " Limit the rate of versioning events.  Also log events where time has
    " gone backward by more than minTimeInterval.
    if has_key(s:priorTime, l:filename) && abs(l:now - s:priorTime[l:filename]) < s:minTimeInterval
        " make sure this version is eventually saved
        " replace any pending timer event, so these don't pile up
        if s:timerStarted
            call timer_stop(s:timer)
        endif
        let s:timerStarted = 1
        let s:timer = timer_start(s:minTimeInterval * 1000, 'version482#TextChanged')
        return
    endif
    let l:dirname = fnamemodify(l:filename, ':h')
    call version482#InitVersionDir(l:dirname)
    " make sure file is in an EECS 482 git repo
    if s:versionDir[l:dirname] == ''
        return
    endif
    " make sure file is a program source file, i.e., has extension {cpp,cc,h,hpp,py}
    let l:ext = fnamemodify(l:filename, ':e')
    if l:ext != 'cpp' && l:ext != 'cc' && l:ext != 'h' && l:ext != 'hpp' && l:ext != 'py'
        return
    endif
    " make sure file isn't too big
    if (wordcount().bytes > 10 * 1024 * 1024)
        return
    endif
    let l:versionDirname = s:versionDir[l:dirname]
    if s:proj[l:dirname] =~ '[012]'
        " Project 0-2
        " check if version file has grown too old or too big
        if l:now - s:sessionStart > s:maxAge || (has_key(s:size, l:versionDirname) && s:size[l:versionDirname] > s:maxSize)
            " start new version file by mimicking restarting vim
            let s:hash = {}
            let s:size = {}
            let s:prior = {}
            let s:priorTime = {}
            let s:sessionStart = l:now
            let s:hashInitial = sha256(s:username . ' ' . s:sessionStart)
        endif
        if ! has_key(s:hash, l:versionDirname)
            let s:hash[l:versionDirname] = s:hashInitial
        endif
        if ! has_key(s:size, l:versionDirname)
            let s:size[l:versionDirname] = 0
        endif
        let l:priorName = fnamemodify(l:versionDirname, ':p') . s:sessionStart . '.' . s:username . '.prior'
        let l:currentName = fnamemodify(l:versionDirname, ':p') . s:sessionStart . '.' . s:username . '.current'
        if ! has_key(s:prior, l:filename)
            let s:prior[l:filename] = []
        endif
        call writefile(s:prior[l:filename], l:priorName)
        let l:current = getline(1, '$')
        call writefile(l:current, l:currentName)
        let l:versionfile = fnamemodify(l:versionDirname, ':p') . s:sessionStart . '.' . s:username
        let l:diff = system('diff "' . l:priorName . '" "' . l:currentName . '"; rm "' . l:priorName . '" "' . l:currentName . '"')
        let l:dict = {}
        let l:dict['file'] = l:filename
        let l:dict['diff'] = l:diff
        " let l:line = s:version .  ' ' . l:now . ' ' . s:size[l:versionDirname] . ' ' . s:hash[l:versionDirname] . ' ' . l:filename . ' ' .  json_encode(l:line)
        let l:line = s:version .  ' ' . l:now . ' ' . s:size[l:versionDirname] . ' ' . s:hash[l:versionDirname] . ' ' . json_encode(l:dict)
        call writefile([l:line], l:versionfile, 'a')
        let s:prior[l:filename] = l:current
        let s:priorTime[l:filename] = l:now
        let s:hash[l:versionDirname] = sha256(l:line)
        let s:size[l:versionDirname] += strlen(l:line) + 1
    else
        " Project 3-4
        " create/update file
        let l:basename = fnamemodify(l:filename, ':t')
        call writefile(getline(1, '$'), fnamemodify(l:versionDirname, ':p') . l:basename)
        " commit changes
        call system('cd "' . l:versionDirname . '"; git add -f "' . l:basename . '"; git commit --allow-empty -m "'. s:version . '"')
        let s:priorTime[l:filename] = l:now
    endif
    if ! has('nvim')
        " Redraw screen to fix glitches.  Unfortunately, this has the
        " side effect of blanking the entire screen when changing a range
        " of text (e.g., change word).  nvim doesn't have these problems.
        mode
    endif
endfunction
" called when a file is saved
function version482#Save(...)
    " add version482 entry, so it's as new as the saved file
    " force the entry by clearing s:priorTime
    let s:priorTime = {}
    call version482#TextChanged()
    let l:now = version482#Time()
    let l:filename = fnamemodify(expand('%'), ':p')
    let l:dirname = fnamemodify(l:filename, ':h')
    call version482#InitVersionDir(l:dirname)
    " make sure file is in an EECS 482 git repo
    if s:versionDir[l:dirname] == ''
        return
    endif
    let l:versionDirname = s:versionDir[l:dirname]
    " limit the rate of tagging/pushing
    if has_key(s:priorTag, l:versionDirname) && l:now - s:priorTag[l:versionDirname] < s:minTagInterval
        " make sure this event is eventually tagged
        " replace any pending timer event, so these don't pile up
        if s:tagTimerStarted
            call timer_stop(s:tagTimer)
        endif
        let s:tagTimerStarted = 1
        let s:tagTimer = timer_start((s:minTagInterval - (l:now - s:priorTag[l:versionDirname]))*1000, 'version482#Save')
        return
    endif
    if s:proj[l:dirname] =~ '[012]'
        " Project 0-2
        " try to create edit tag and push it to github
        let l:dateString = strftime("%Y.%m.%d_%H.%M.%S", l:now)
        " Make sure this git repository has at least one commit, so HEAD~ refers
        " to something when undoing the first temporary commit.
        call system('cd "' . l:versionDirname . '"; git log > /dev/null')
        if v:shell_error
            call system('cd "' . l:versionDirname . '"; git commit -m "initial commit" --allow-empty')
        endif
        " create first temporary commit
        call system('cd "' . l:versionDirname . '"; git commit -m edit-' . l:dateString . '-tmp1 --allow-empty')
        if ! v:shell_error
            " add version files to repo (only for the second temporary commit)
            call system('cd "' . l:versionDirname . '"; git add -f .')
            " create second temporary commit
            call system('cd "' . l:versionDirname . '"; git commit -am edit-' . l:dateString . '-tmp2 --allow-empty')
            if ! v:shell_error
                " create edit tag for the second temporary commit
                call system('cd "' . l:versionDirname . '"; git tag -a edit-' . l:dateString . ' -m ""')
                if ! v:shell_error
                    let s:priorTag[l:versionDirname] = l:now
                    " remove version482 files that are guaranteed not to change
                    for l:f in glob(fnamemodify(l:versionDirname, ':p') . '*', 1, 1)
                        if now - fnamemodify(l:f, ':t:r') > s:maxAge
                            call delete(l:f)
                        endif
                    endfor
                endif
                " Undo second temporary commit.  Use --mixed to unstage the files
                " that were staged because of the -a argument to git commit.
                call system('cd "' . l:versionDirname . '"; git reset --mixed HEAD~')
            endif
            " Undo first temporary commit.  Use --soft to preserve the files that
            " that were already staged.
            call system('cd "' . l:versionDirname . '"; git reset --soft HEAD~')
        endif
        " push tags
        call system('cd "' . l:versionDirname . '"; git push --tags --quiet &')
    else
        " Project 3-4
        call system('cd "' . l:versionDirname . '"; git push --quiet &')
        let s:priorTag[l:versionDirname] = l:now
    endif
endfunction
